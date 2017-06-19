//
//  StoreInfomationViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/14.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class StoreInfomationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TypeChoseDelegate,GoodsTypeDelegate,CategoryGoodsViewDelegate {



    var method = Methods()
    //当前的页码
    var pageIndex:Int = 0{
        didSet{
//            reloadGoodsDate()
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
    var EnvlotionData:JSON?{
        didSet{
            EvaluationTable.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        }
    }
    var envlotionList:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.EvaluationTable.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
            }
        }
    }
    var categoryArr = ["商品","评价"]{
        didSet{
            DispatchQueue.main.async {
                self.shopType.reloadWithArray(array: self.categoryArr)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatView()
        HttpTool.shareHttpTool.Http_GoodsCategory { (data)  in
            self.cateInfoData = data.arrayValue
            
        }
        HttpTool.shareHttpTool.Http_StoreEnvlotion { (data) in
            print(data)
            let storeAve = Float((data["serviceAppr"].floatValue + data["distributionAppr"].floatValue + data["productAppr"].floatValue)/3.0)
            self.categoryArr = ["商品","评价(\(storeAve.getOneDecimal())分)"]
            self.EnvlotionData = data
        }
    }
    func getEnvlotionList(){
        HttpTool.shareHttpTool.Http_EnvlotionList(startIndex: pageIndex, rows: 15) { (data) in
            print(data)
//            self.EvaluationTable.mj_header.endRefreshing()
            if data.arrayValue.count == 0{
                self.myNoticeError(title: "没有更多了")
            }
            self.EvaluationTable.mj_footer.endRefreshing()
            self.envlotionList += data.arrayValue
        }
    }
    var shopType:TypeChoseView!
    var typeList:LeftTypeView!
    var category:CategoryGoodsView!
    let goodsInfoView = UIView()
    lazy var EvaluationTable:UITableView={
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.tableFooterView = UIView()
//        table.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.pageIndex = 0
//            self.envlotionList = []
//            self.getEnvlotionList()
//        })
        table.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageIndex += 1
            self.getEnvlotionList()
        })
        return table
    }()
    var storeImage:UIImageView!//店铺图片
    var storeName:UILabel!//店铺名字
    var storeRemark:UILabel!//店铺规则备注
    var storeOpenTime:UILabel!//店铺营业时间
    var storeNotice:UILabel!//店家公告
    var normChose:NormChoseView!//规格弹窗
    func creatView(){
        self.view.backgroundColor = MyGlobalColor()
        let topView = UIImageView()
        topView.frame = CGRect(x: 0, y: 0, width: app_width, height: 180)
        topView.backgroundColor = setMyColor(r: 250, g: 172, b: 14, a: 1)
        topView.isUserInteractionEnabled = true
        self.view.addSubview(topView)
        
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
        backBtn.setImage(UIImage(named:"fanhui-baise"), for: .normal)
        backBtn.addTarget(self, action: #selector(self.backPage), for: .touchUpInside)
        topView.addSubview(backBtn)
        
        let searchBtn = UIButton()
        searchBtn.frame = CGRect(x: app_width - 40, y: 30, width: 25, height: 25)
        searchBtn.setImage(UIImage(named:"sousuo-bai"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        topView.addSubview(searchBtn)
        
        shopType = TypeChoseView(frame: CGRect(x: 0, y: topView.bottomPosition(), width: app_width, height: 40))
        shopType.typeChoseDelegate = self
        ////////////////////店铺信息/////////////////////////
        storeImage = UIImageView(frame: CGRect(x: 15, y: 70, width: 60, height: 60))
        storeImage.contentMode = .scaleAspectFill
        storeImage.layer.cornerRadius = storeImage.frame.width/2
        storeImage.layer.borderWidth = 2
        storeImage.layer.borderColor = setMyColor(r: 252, g: 192, b: 69, a: 1).cgColor
//        storeImage.backgroundColor = UIColor.white
        method.loadImage(imgUrl: "\(storeInfomation!.storeImg!)", Img_View: storeImage)
        topView.addSubview(storeImage)
        
        storeName = UILabel()
        method.creatLabel(lab: storeName, x: storeImage.rightPosition() + 15, y: storeImage.frame.origin.y, wid: app_width - storeImage.rightPosition(), hei: 20, textString: "\(storeInfomation!.storeName!)", textcolor: UIColor.white, textFont: 14, superView: topView)
        
        storeRemark = UILabel()
        method.creatLabel(lab: storeRemark, x: storeName.frame.origin.x, y: storeName.bottomPosition(), wid: storeName.frame.width, hei: 20, textString: "¥\(storeInfomation!.startLimit!)元起送／配送费¥\(storeInfomation!.deliveryFee!)／满¥\(storeInfomation!.freeLimit!)元免配送费", textcolor: UIColor.white, textFont: 10, superView: topView)
        
        storeOpenTime = UILabel()
        method.creatLabel(lab: storeOpenTime, x: storeName.frame.origin.x, y: storeRemark.bottomPosition(), wid: storeName.frame.width, hei: 20, textString: "营业时间：\(storeInfomation!.businessHours!)", textcolor: UIColor.white, textFont: 11, superView: topView)
        
        storeNotice = UILabel()
        method.creatLabel(lab: storeNotice, x: 15, y: storeImage.bottomPosition(), wid: topView.frame.width - 30, hei: 50, textString: "公告：\(storeInfomation!.storeNotice!)", textcolor: UIColor.white, textFont: 11, superView: topView)
        ////////////////////商品分类和评论/////////////////////////
        
        shopType.item_width = app_width/CGFloat(categoryArr.count)
        shopType.reloadWithArray(array: categoryArr)
        
        self.view.addSubview(shopType)
        
        goodsInfoView.frame = CGRect(x: 0, y: shopType.bottomPosition() + 1, width: app_width, height: app_height - shopType.bottomPosition())
        goodsInfoView.backgroundColor = UIColor.white
        self.view.addSubview(goodsInfoView)
        
        typeList = LeftTypeView(frame: CGRect(x: 0, y: 0, width: 100, height: app_height - nav_height - tab_height))
        typeList.delegate = self
        goodsInfoView.addSubview(typeList)
        
        category = CategoryGoodsView(frame: CGRect(x: typeList.rightPosition(), y: 0, width: app_width - typeList.rightPosition(), height: goodsInfoView.frame.height))
        category.delegate = self
        category.currentVC = self
        goodsInfoView.addSubview(category)
        
        normChose = NormChoseView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height))
        self.view.addSubview(normChose)
    }
    /*******************************************************************************
     //////////////////////////////事件处理///////////////////////////////////////////
     *******************************************************************************/
    
    func EvaluationChange(score:String){
        categoryArr = ["商品","评价(\(score)分)"]
    }
    
    func pullLoadMore(pageIndex:Int){
        self.pageIndex = pageIndex
    }
    
    func goodsNormChose(goodsInfo:JSON){
        normChose.goodsInfo = goodsInfo
        normChose.animationHide(hide: false)
    }
    func searchBtnClick(){
        //
        self.pushToNext(vc: GoodsSearchViewController())
    }
    //一级分类的点击
    func typeClick(index:Int) {
        print(index)
        //索引变0
        self.pageIndex = 0
        self.category?.pageIndex = 0
        self.category?.goodsInfo = []
        category.categoryData = cateInfoData[index]
        self.pageClassifyID = cateInfoData[index]["classifyID"].stringValue
    }
    //点击了分类或者排序。。。。
    func categoryTypeChose(classifyID:String,sortType:goodsSortType,orderOrCategory:Bool){
        //索引变0
        self.pageIndex = 0
        self.category?.pageIndex = 0
        self.category?.goodsInfo = []
        if orderOrCategory{
            //排序处理
            self.pageGoodsSortType = sortType
        }else{
            //分类处理
            self.pageClassifyID = classifyID
        }
    }
//    商品选择
    func goodsChose(goodsId:String){
        let vc = GoodsDetailViewController()
        vc.goodsId = goodsId
        self.pushToNext(vc: vc)
    }
    func TypeChoseClick(index: Int) {
        //类别切换
        if index == 0{
            //商品信息
            goodsInfoView.isHidden = false
            EvaluationTable.removeFromSuperview()
        }else{
            //评价
            goodsInfoView.isHidden = true
            EvaluationTable.frame = goodsInfoView.frame
            self.view.addSubview(EvaluationTable)
            self.getEnvlotionList()
        }
    }
    func reloadGoodsDate(){
        HttpTool.shareHttpTool.Http_GetGoodsByCategory(classifyID: pageClassifyID, startIndex: pageIndex, sortType: pageGoodsSortType.rawValue) { (data) in
            //print(data)
            self.category.goodsInfo += data.arrayValue
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension StoreInfomationViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return indexPath.section == 0 ? 100 : 80
        return 100
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10:0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? 1 : envlotionList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            //总评价
            let cell = StoreAllEvaluationTableViewCell()
            if EnvlotionData != nil{
                cell.initViewWithData(data: EnvlotionData!)
            }
            
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as? StoreEvaluationTableViewCell
            if cell == nil{
                cell = StoreEvaluationTableViewCell()
            }
            
            let ave_score = Float((envlotionList[indexPath.row]["serviceAppr"].floatValue + envlotionList[indexPath.row]["distributionAppr"].floatValue + envlotionList[indexPath.row]["productAppr"].floatValue)/3.0).getOneDecimal()
            cell!.Score             = ave_score
            cell!.imgUrl            = envlotionList[indexPath.row]["headUrl"].stringValue
            cell!.Eva_Context.text  = envlotionList[indexPath.row]["content"].stringValue
            cell!.userName.text     = envlotionList[indexPath.row]["nickName"].stringValue
            cell!.userScore.text    = "\(ave_score)"
            cell!.Eva_time.text     = method.convertTime(time: envlotionList[indexPath.row]["createDate"].doubleValue) 
            return cell!
        }
    }
}
