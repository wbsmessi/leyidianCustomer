//
//  CategoryViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/2/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryViewController: UIViewController,GoodsTypeDelegate,CategoryGoodsViewDelegate {

    var method = Methods()
    //当前的页码
    var pageIndex:Int = 0{
        didSet{
            reloadGoodsDate()
        }
    }
    //当前的分类
    var pageClassifyID:String = ""{
        didSet{
            reloadGoodsDate()
        }
    }
    //当前的排序
    var pageGoodsSortType:goodsSortType = goodsSortType.defaultType{
        didSet{
            reloadGoodsDate()
        }
    }
    var cateInfoData:[JSON] = []{
        didSet{
            //设置一级分类和二级默认分类
            self.typeList.dataArr = cateInfoData
            self.category.categoryData = cateInfoData[0]
            self.pageClassifyID = cateInfoData[0]["classifyID"].stringValue
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView()
        if let _=storeInfomation{
            creatView()
            HttpTool.shareHttpTool.Http_GoodsCategory { (data)  in
                print(data)
                self.cateInfoData = data.arrayValue
            }
        }else{
            let noview = NoStoreView(frame: CGRect(x: 0, y: nav_height, width: app_width, height: app_height - 113))
            noview.superVC = self
            self.view.addSubview(noview)
        }
            
//        method.addTocar(goodId: "2", norm: "1221超大件一个的")
    }
    /*******************************************************************************
     //////////////////////////////UI部分/////////////////////////////////////////
     *****************************************************************************/
    func titleView() {
        self.navigationController?.navigationBar.isHidden = true
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: app_width, height: nav_height)
        titleView.backgroundColor = UIColor.white
        self.view.addSubview(titleView)
        method.drawLine(startX: 0, startY: 63, wid: app_width, hei: 0.6, add: titleView)
        
        let searchBtn = UIButton()
        searchBtn.frame = CGRect(x: 15, y: 30, width: app_width - 60, height: 27)
        searchBtn.setImage(UIImage(named:"sousuo"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        titleView.addSubview(searchBtn)
        
        let messageBtn = UIButton()
        messageBtn.frame = CGRect(x: app_width - 40, y: 30, width: 25, height: 25)
        messageBtn.setImage(UIImage(named:"xiaoxi"), for: .normal)
        messageBtn.addTarget(self, action: #selector(turnToMessageVC), for: .touchUpInside)
        titleView.addSubview(messageBtn)
        
        
    }
    var typeList:LeftTypeView!
    var category:CategoryGoodsView!
    func creatView() {
        typeList = LeftTypeView(frame: CGRect(x: 0, y: 64, width: 100, height: app_height - nav_height - tab_height))
        typeList.delegate = self
        self.view.addSubview(typeList)
        
        category = CategoryGoodsView(frame: CGRect(x: typeList.rightPosition(), y: nav_height, width: app_width - typeList.rightPosition(), height: app_height - nav_height - tab_height))
        category.delegate = self
        self.view.addSubview(category)
    }
    /*******************************************************************************
     //////////////////////////////事件处理///////////////////////////////////////////
     *******************************************************************************/
    func searchBtnClick(){
        self.pushToNext(vc: GoodsSearchViewController())
    }
    //一级分类的点击
    func typeClick(index:Int) {
        print(index)
        category.categoryData = cateInfoData[index]
        self.pageClassifyID = cateInfoData[index]["classifyID"].stringValue
    }
    //点击了分类或者排序。。。。
    func categoryTypeChose(classifyID:String,sortType:goodsSortType,orderOrCategory:Bool){
        if orderOrCategory{
            //排序处理
            self.pageGoodsSortType = sortType
        }else{
            //分类处理
            self.pageClassifyID = classifyID
        }
    }
    func goodsChose(goodsId:String){
        let vc = GoodsDetailViewController()
        vc.goodsId = goodsId
        self.pushToNext(vc: vc)
    }
    func turnToMessageVC() {
        self.pushToNext(vc: MessageCenterViewController())
    }
    func reloadGoodsDate(){
        HttpTool.shareHttpTool.Http_GetGoodsByCategory(classifyID: pageClassifyID, startIndex: pageIndex, sortType: pageGoodsSortType.rawValue) { (data) in
            print(data)
            self.category.goodsInfo = data.arrayValue
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
