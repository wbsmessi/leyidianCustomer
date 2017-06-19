//
//  SearchListViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/5.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class SearchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,goodsTableListTableViewCellDelegate {

    var pageIndex:Int = 0
    var goodsInfo:[JSON] = []{
        didSet{
            if goodsInfo.count == 0{
                self.myNoticeError(title: "无搜索结果")
            }
            DispatchQueue.main.async {
                self.tableList.reloadData()
            }
        }
    }
    var method = Methods()
    var searchStr:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "搜索结果", canBack: true)
        creatView()
        searchGoods()
        // Do any additional setup after loading the view.
    }
    func searchGoods(){
        HttpTool.shareHttpTool.Http_goodsSearch(startIndex: pageIndex, searchText: searchStr) { (data) in
            print(data)
            self.tableList.mj_header.endRefreshing()
            self.tableList.mj_footer.endRefreshing()
            self.goodsInfo += data.arrayValue
        }
    }
    let tableList = UITableView()
    var normChose:NormChoseView!//规格弹窗
    func creatView(){
        
        tableList.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height)
        tableList.tableFooterView = UIView()
        tableList.delegate = self
        tableList.dataSource = self
        tableList.rowHeight = 100
        self.view.addSubview(tableList)
        tableList.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageIndex = 0
            self.goodsInfo = []
            self.searchGoods()
        })
        tableList.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageIndex += 1
            self.searchGoods()
        })
        
        normChose = NormChoseView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height))
        self.view.addSubview(normChose)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return goodsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? goodsTableListTableViewCell
        if cell == nil{
            cell = goodsTableListTableViewCell()
        }
        cell!.creatView(cell_wid: app_width)
        cell!.delegate = self
        cell!.goodsInfo = goodsInfo[indexPath.row]
        cell!.imageUrl = goodsInfo[indexPath.row]["cover"].stringValue
        cell!.oldPrice = "¥" + goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
        cell!.goodsName.text = goodsInfo[indexPath.row]["commodityName"].stringValue
        cell!.goodsDetail.text = goodsInfo[indexPath.row]["commodityRemark"].stringValue
        cell!.goodsPrice.text = goodsInfo[indexPath.row]["discountPrice"].doubleValue.getMoney()
        
        var salePrice = goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
        
        if method.hasStringInArr(arrStr: goodsInfo[indexPath.row]["commodityTypes"].stringValue){
            salePrice = goodsInfo[indexPath.row]["discountPrice"].doubleValue.getMoney()
            
        }else{
            cell!.goodsOldPrice.isHidden = true
        }
        cell!.goodsPrice.text = salePrice
        cell!.goodsStatus = goodsInfo[indexPath.row]["status"].stringValue
        cell!.goodsActiveType = goodsInfo[indexPath.row]["commodityTypes"].stringValue
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //跳转到商品详情页
        self.toGoodsDetail(id: goodsInfo[indexPath.row]["commodityID"].stringValue)
    }
    func toGoodsDetail(id:String){
        let vc = GoodsDetailViewController()
        vc.goodsId = id
        self.pushToNext(vc: vc)
    }
    func goodsTableListAlertNormChose(goods:JSON){
        normChose.goodsInfo = goods
        normChose.animationHide(hide: false)
    }
//    func alertNormChose(goods:JSON){
//        
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
