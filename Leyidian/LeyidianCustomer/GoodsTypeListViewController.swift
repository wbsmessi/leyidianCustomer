//
//  GoodsTypeListViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/8.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class GoodsTypeListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TypeChoseDelegate,GoodsCollectionViewCellDelegate {
//    HomePageTitleArr=["优选精品","限时抢购","折扣特价","掌柜推荐"]
    var typeName:String!
    var activeGoodsType:ActivitieGoods!
    var method = Methods()
    //当前选择的分类id
    var loadClassifyID:String = ""
    var categoryData:[JSON] = []{
        didSet{
            //加载分类
            var titelArr:[String] = ["全部"]
            for item in categoryData{
                titelArr.append(item["classifyName"].stringValue)
            }
            shopType.item_width = app_width/CGFloat((titelArr.count < 5) ? titelArr.count : 5)
            shopType.reloadWithArray(array: titelArr)
            //默认加载第一个全部的东西
            reloadData(classifyID: "")
        }
    }
    var goodsData:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.goodsList.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        switch typeName {
        case "优选精品":
            activeGoodsType = ActivitieGoods.PreferredGoods
        case "限时抢购":
            activeGoodsType = ActivitieGoods.Timelimit
        case "折扣特价":
            activeGoodsType = ActivitieGoods.BargainPrice
        default:
            //推荐
            activeGoodsType = ActivitieGoods.Recommend
        }
        self.setTitleView(title: typeName, canBack: true)
        creatView()
        loadCategoryData()
    }
    func loadCategoryData(){
        HttpTool.shareHttpTool.Http_GoodsCategory { (data)  in
            print(data)
            if data.arrayValue.count > 0{
                var da = data.arrayValue
                da.remove(at: 0)
                self.categoryData = da
            }else{
                self.categoryData = []
            }
            
        }
    }
    
    func reloadData(classifyID:String){
        self.loadClassifyID = classifyID
        HttpTool.shareHttpTool.Http_ActiveGoods(startIndex: 0, type: activeGoodsType.rawValue,classifyID:classifyID) { (data) in
            print(data)
            if data.arrayValue.count == 0{
                self.myNoticeNodata()
            }
            self.goodsList.mj_header.endRefreshing()
            self.goodsData = data.arrayValue
        }
    }
    //商品的分类
    lazy var shopType:TypeChoseView={
        let shopType = TypeChoseView(frame: CGRect(x: 0, y: nav_height, width: app_width, height: 50))
        shopType.typeChoseDelegate = self
        return shopType
    }()
    var goodsList:UICollectionView!
    var normChose:NormChoseView!//规格弹窗
    func creatView(){
//        let categoryArr = ["全部分类","分类一","分类二","分类三"]
//        shopType.item_width=app_width/CGFloat(categoryArr.count)
//        shopType.reloadWithArray(array: categoryArr)
        self.view.addSubview(shopType)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        goodsList = UICollectionView(frame: CGRect(x: 0, y: shopType.bottomPosition(), width: app_width, height: app_height - shopType.bottomPosition()), collectionViewLayout: layout)
        goodsList.backgroundColor = UIColor.white
        goodsList.delegate = self
        goodsList.dataSource = self
        goodsList.showsVerticalScrollIndicator=false
        goodsList.register(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: "goodscell")
        self.view.addSubview(goodsList)
        self.goodsList.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.reloadData(classifyID: self.loadClassifyID)
        })
        
        normChose = NormChoseView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height))
        self.view.addSubview(normChose)
    }
    func alertNormChose(goods:JSON){
        normChose.goodsInfo = goods
        normChose.animationHide(hide: false)
    }
    func TypeChoseClick(index:Int){
        print(index)
        
        if index == 0{
            //默认全部
            self.reloadData(classifyID: "")
        }else{
            self.reloadData(classifyID: categoryData[index - 1]["classifyID"].stringValue)
        }
    }
    //跳转到商品详情页
    func toGoodsDetail(id:String){
        let vc = GoodsDetailViewController()
        vc.goodsId = id
        self.pushToNext(vc: vc)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension GoodsTypeListViewController{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (app_width-20)/2, height: (app_width-20) * 2/3)
    }
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ///////
        toGoodsDetail(id: goodsData[indexPath.item]["commodityID"].stringValue)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodscell", for: indexPath) as! GoodsCollectionViewCell
        
        cell.delegate = self
        cell.goodsInfo = goodsData[indexPath.item]
        cell.indexRow = indexPath.item
        cell.imageUrl = goodsData[indexPath.item]["cover"].stringValue
        cell.oldPrice = "¥"+goodsData[indexPath.item]["retailPrice"].stringValue
        cell.goodsNameStr = goodsData[indexPath.item]["commodityName"].stringValue
        cell.goodsDetail.text = goodsData[indexPath.item]["commodityRemark"].stringValue
        cell.nowPrice.text = goodsData[indexPath.item]["discountPrice"].stringValue
        
        var salePrice = goodsData[indexPath.item]["retailPrice"].doubleValue.getMoney()
        if method.hasStringInArr(arrStr: goodsData[indexPath.item]["commodityTypes"].stringValue){
            salePrice = goodsData[indexPath.item]["discountPrice"].doubleValue.getMoney()
            cell.goodsOldPrice.isHidden = false
        }else{
            cell.goodsOldPrice.isHidden = true
        }
        cell.nowPrice.text = salePrice
        
        cell.goodsStatus = goodsData[indexPath.item]["status"].stringValue
        return cell
    }
}

