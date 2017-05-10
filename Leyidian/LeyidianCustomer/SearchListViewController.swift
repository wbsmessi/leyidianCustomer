//
//  SearchListViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/5.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

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
    var searchStr:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "搜索结果", canBack: true)
        creatView()
        searchGoods()
        // Do any additional setup after loading the view.
    }
    func searchGoods(){
        HttpTool.shareHttpTool.Http_goodsSearch(startIndex: 0, searchText: searchStr) { (data) in
            print(data)
            self.goodsInfo = data.arrayValue
        }
    }
    let tableList = UITableView()
    func creatView(){
        
        tableList.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height)
        tableList.tableFooterView = UIView()
        tableList.delegate = self
        tableList.dataSource = self
        tableList.rowHeight = 100
        self.view.addSubview(tableList)
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
        cell!.goodsInfo = goodsInfo[indexPath.row]
        cell!.imageUrl = goodsInfo[indexPath.row]["cover"].stringValue
        cell!.oldPrice = "¥" + goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
        cell!.goodsName.text = goodsInfo[indexPath.row]["commodityName"].stringValue
        cell!.goodsDetail.text = goodsInfo[indexPath.row]["commodityRemark"].stringValue
        cell!.goodsPrice.text = goodsInfo[indexPath.row]["discountPrice"].doubleValue.getMoney()
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
