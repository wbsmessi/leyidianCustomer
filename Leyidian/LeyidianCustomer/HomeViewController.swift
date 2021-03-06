//
//  ViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/2/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import MJRefresh

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,HomeScrollTableViewDelegate,TypeChoseDelegate,RecommendCategoryDelegate,AddressChoseAlertDelegate,AddressChoseDelegate,DECMaBannerViewDelegate,GoodsCollectionViewCellDelegate,HomeAdvertisingViewDelegate {

    //当前选择的店铺类型
    var selectedStoreType:String = ""
    var method = Methods()
    //当前的定位
    var nowLocationLat:String?{
        get{
            let location = MyUserInfo.value(forKey: userInfoKey.locationLat.rawValue) as? String
            return location ?? ""
        }
        set{
            MyUserInfo.setValue(newValue!, forKey: userInfoKey.locationLat.rawValue)
        }
    }
    //当前的定位
    var nowLocationLon:String?{
        get{
            let location = MyUserInfo.value(forKey: userInfoKey.locationLon.rawValue) as? String
            return location ?? ""
        }
        set{
            MyUserInfo.setValue(newValue!, forKey: userInfoKey.locationLon.rawValue)
        }
    }
    var nowLocationName:String?{
        get{
            let locationname = MyUserInfo.value(forKey: userInfoKey.locationString.rawValue) as? String
            return "请送至：" + (locationname ?? "")
        }
        set{
            MyUserInfo.setValue(newValue!, forKey: userInfoKey.locationString.rawValue)
        }
    }
    var storeStatus:String = "0"{
        didSet{
            
            if storeStatus == "1"{
                noticeNoStore()
            }
        }
    }
    
    var loopViewList:[JSON] = []{
        didSet{
            self.loopView.imgJSON = loopViewList
        }
    }
    var commtypeList:[JSON] = []{
        didSet{
//            500 + height
            var height:CGFloat = (app_width * 0.1 + 10) * CGFloat(commtypeList.count) + 340 + app_width * 5/6
            for item in commtypeList{
                
                if item["storeCommodityList"].count%2 == 0{
                    height += CGFloat(item["storeCommodityList"].count/2) * ((app_width-20) * 2/3 + 10)  //   /2 * 3/4
                }else{
                    height += CGFloat((item["storeCommodityList"].count/2 + 1)) * ((app_width-20) * 2/3 + 10)
                }
            }
            DispatchQueue.main.async {
                self.reRecommendCollection.frame = CGRect(x: 0, y: 0, width: app_width, height: height)
                self.reRecommendCollection.reloadData()
                self.goodsTypeTable.tableHeaderView = self.reRecommendCollection
            }
            
        }
    }
    
    var storeClassifyList:[JSON] = []{
        didSet{
            self.goodsTypeTable.reloadData()
        }
    }
    
    var shopTypeInfo:[JSON] = []{
        didSet{
            var shopName:[String] = []
            for item in shopTypeInfo{
                shopName.append(item["storeName"].stringValue)
            }
            self.shopTypeDetial.reloadData(data: shopTypeInfo)
           
            self.shopType.reloadWithArray(array: shopName)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView()
        mainView()
        
        firstStart()
        
    }
    func firstStart(){
        if let _ = MyUserInfo.value(forKey: userInfoKey.firstEnter.rawValue) as? String {
            //非首次启动
            if nowLocationLat != nil && nowLocationLat != ""{
                self.loadData()
            }else{
                AddressInfo()
            }
            
        }else{
            //首次启动，去引导页
            MyUserInfo.setValue("notfirst", forKey: userInfoKey.firstEnter.rawValue)
            let vc=GuidePageViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.superVC = self
            //            vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present(vc, animated: false, completion: nil)
            
        }
    }
    func AddressInfo(){
        //获取当前地理位置的经纬度
        if nowLocationLat == ""{
            method.getAddressInfoBy(succesce: { (data) -> (Void) in
                if data != nil{
                    print(data!.0)
                    DispatchQueue.main.async {
                        self.choseAddress.setTitle("请送至:" + data!.0, for: .normal)
                    }
                    self.nowLocationName = data!.0
                    self.nowLocationLat = data!.1.coordinate.latitude.getSixLocation()
                    self.nowLocationLon = data!.1.coordinate.longitude.getSixLocation()
                    //                    print(data!.1.coordinate.latitude)
                    //                    print(data!.1.coordinate.longitude)
                    self.loadData()
                }else{
                    self.NoInfomation.isHidden = false
                    self.myNoticeError(title: "获取位置信息失败！")
                }
            })
        }else{
            self.loadData()
        }
    }
    /*******************************************************************************
    //////////////////////////////UI部分////////////////////////////////////////////
    *********************************************************************************/
//    地址选择按钮
    let choseAddress = UIButton()
    lazy var alertAddress:AddressChoseAlert={
       let alert = AddressChoseAlert(frame: CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height))
        alert.delegate = self
        return alert
    }()
    func AddressChoseRowClick(index:Int){
        choseAddress.isSelected = false
        print(index)
        if index == 0{
            let vc = AddressChoseViewController()
            vc.delegate = self
            self.pushToNext(vc: vc)
        }else{
            let vc = AddNewAddressViewController()
            vc.isAddNew = true
            self.pushToNext(vc: vc)
        }
    }
    let messageBtn = UIButton()
    func titleView() {
        self.navigationController?.navigationBar.isHidden = true
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: app_width, height: nav_height)
        titleView.backgroundColor = setMyColor(r: 255, g: 186, b: 0, a: 1)
        self.view.addSubview(titleView)
        
        method.creatButton(btn: choseAddress, x: 15, y: 34, wid: 250, hei: 20, title: nowLocationName ?? "", titlecolor: UIColor.black, titleFont: 14, bgColor: UIColor.clear, superView: titleView)
//        choseAddress.titleLabel?.textAlignment = .left
        choseAddress.contentHorizontalAlignment = .left
        

        choseAddress.addTarget(self, action: #selector(choseAddressClick(btn:)), for: .touchUpInside)
//        choseAddress.sizeToFit()
        
        
        let choseIcon = UIImageView()
        choseIcon.image = UIImage(named: "jiantou-up")
        choseIcon.frame = CGRect(x: choseAddress.frame.origin.x+choseAddress.frame.width, y: choseAddress.frame.origin.y, width: 20, height: 20)
        titleView.addSubview(choseIcon)
        
        
        messageBtn.frame = CGRect(x: app_width - 40, y: 30, width: 25, height: 25)
        messageBtn.setImage(UIImage(named:"xiaoxi-bai"), for: .normal)
        messageBtn.addTarget(self, action: #selector(turnToMessageVC), for: .touchUpInside)
        titleView.addSubview(messageBtn)
    }
    
    //店铺的分类
    lazy var shopType:TypeChoseView={
       let shopType = TypeChoseView(frame: CGRect(x: 0, y: nav_height, width: app_width - 50, height: 50))
        shopType.typeChoseDelegate = self
        return shopType
    }()
    lazy var shopTypeDetial:shopDetailView = {
        let shopTypeDetial = shopDetailView(frame: CGRect(x: 0, y: nav_height + 50, width: app_width, height: 80))
        return shopTypeDetial
    }()
    var adverstingView:HomeAdvertisingView!//轮播下面的广告图片
    let loopView : DECMaBannerView = DECMaBannerView.init(frame: CGRect(x:0,y:0,width:app_width,height:230))
    var reRecommendCollection:UICollectionView!
    var goodsTypeTable:UITableView!
    var normChose:NormChoseView!//规格弹窗
    func mainView(){
        
        self.view.addSubview(shopType)
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRect(x: app_width - 45, y: 10 + nav_height, width: 30, height: 30)
        rightBtn.setImage(UIImage(named:"xuanze"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClick(btn:)), for: .touchUpInside)
        self.view.addSubview(rightBtn)
        
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: -340 - app_width * 5/6, width: self.view.frame.width, height: 340 + app_width * 5/6)
        topView.backgroundColor = MyGlobalColor()
//        topView.backgroundColor = setMyColor(r: 240, g: 240, b: 240, a: 1)
        self.view.addSubview(topView)
        
        //轮播图
        loopView.delegate = self
        topView.addSubview(loopView)
        
        //搜索按钮-跳转搜索页面
//        let searchBtn = UIButton()
//        searchBtn.frame = CGRect(x: 20, y: 190, width: app_width - 40, height: 30)
//        searchBtn.setImage(UIImage(named:"sousuo"), for: .normal)
//        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
//        topView.addSubview(searchBtn)
        
        let searchBtn = UIButton()
        searchBtn.frame = CGRect(x: 20, y: 190, width: app_width - 40, height: 30)
        searchBtn.setImage(UIImage(named:"sousuo"), for: .normal)
        searchBtn.contentHorizontalAlignment = .left
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        topView.addSubview(searchBtn)
        searchBtn.layer.cornerRadius = searchBtn.frame.height/2
        searchBtn.layer.borderColor = setMyColor(r: 204, g: 204, b: 204, a: 1).cgColor
        searchBtn.layer.borderWidth = 0.6
        searchBtn.backgroundColor = UIColor.white
        
        //四项推荐类型
        let RCM_CATEGORY = RecommendCategoryView(frame: CGRect(x: 0, y: 230, width: app_width, height: 90))
        RCM_CATEGORY.bgImageName = "tubiaodi"
        RCM_CATEGORY.initView(imgArr: HomePageImgArr, titleArr: HomePageTitleArr)
        RCM_CATEGORY.delegate=self
        topView.addSubview(RCM_CATEGORY)
        
        //广告图片区域 height 200
        adverstingView = HomeAdvertisingView(frame: CGRect(x: 0, y: RCM_CATEGORY.bottomPosition() + 10, width: app_width, height: app_width * 5/6))
        adverstingView.delegate = self
        topView.addSubview(adverstingView)
        
        /***************************推荐类的collection************************/
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.footerReferenceSize = CGSize(width: app_width, height: 10)
        layout.headerReferenceSize = CGSize(width: app_width, height: app_width * 0.1)
        // 设置间距
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        reRecommendCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height - shopType.bottomPosition() - tab_height), collectionViewLayout: layout)
        reRecommendCollection.contentInset = UIEdgeInsetsMake(topView.frame.height, 0, 0, 0)//cellection 的tableHerder_height
        reRecommendCollection.bounces = false
        reRecommendCollection.addSubview(topView)
        reRecommendCollection.backgroundColor = UIColor.white
        reRecommendCollection.delegate = self
        reRecommendCollection.dataSource = self
        reRecommendCollection.showsVerticalScrollIndicator=false
        reRecommendCollection.register(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: "goodscell")
        reRecommendCollection.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        reRecommendCollection.register(SectionFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "footerId")
//        reRecommendCollection.frame = CGRect(x: 0, y: 0, width: app_width, height: reRecommendCollection.contentSize.height)
        reRecommendCollection.isScrollEnabled = false
        
        /***************************分类的table************************/
        goodsTypeTable = UITableView(frame: CGRect(x: 0, y: shopType.bottomPosition(), width: app_width, height: app_height - shopType.bottomPosition() - tab_height), style: .grouped)
        //生成了再加
//        goodsTypeTable.tableHeaderView=reRecommendCollection
//        (app_width-20) * 2/3
        goodsTypeTable.rowHeight = (app_width-20)/2
        goodsTypeTable.delegate = self
        goodsTypeTable.separatorStyle = .none
        goodsTypeTable.dataSource = self
        goodsTypeTable.showsVerticalScrollIndicator=false
        goodsTypeTable.backgroundColor = MyGlobalColor()
        self.view.addSubview(goodsTypeTable)
        self.goodsTypeTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.reloadHomePageData(storeType:self.selectedStoreType)
        })
        //
        self.view.addSubview(self.shopTypeDetial)
        
        normChose = NormChoseView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height))
        self.view.addSubview(normChose)
        
        NoInfomation = NoInfomationView(frame: CGRect(x: 0, y: self.shopType.bottomPosition(), width: app_width, height: app_height - self.shopType.bottomPosition() - tab_height))
        NoInfomation.isHidden = true
        NoInfomation.feedbackBtn.addTarget(self, action: #selector(noinfomationClick), for: .touchUpInside)
        self.view.addSubview(self.NoInfomation)
    }
    func noinfomationClick(){
        self.pushToNext(vc: FeedBackViewController())
    }
    // test
    /*******************************************************************************
     //////////////////////////////各种点击事件处理/////////////////////////////////////
     *********************************************************************************/
    func HomeAdvertisingImageClick(info:JSON){
        /*switch info["redirectWay"].stringValue {
        case "S"://跳转商品详情
            self.toGoodsDetail(id: info["commodityID"].stringValue)
        case "O"://跳转链接
            let vc = LYDWebViewController()
            vc.loadUrl = info["redirectUrl"].stringValue
            self.pushToNext(vc: vc)
        default:
            _=""
        }*/
        if info["commodityID"].stringValue != ""{
            self.toGoodsDetail(id: info["commodityID"].stringValue)
        }
    }
    func alertNormChose(goods:JSON){
        
        normChose.goodsInfo = goods
        normChose.animationHide(hide: false)
    }
    func HomeScrollTableViewNormChose(goodsInfo:JSON){
        normChose.goodsInfo = goodsInfo
        normChose.animationHide(hide: false)
    }
    //没有商店信息提示
    func noticeNoStore(){
        DispatchQueue.main.async {
            let colsedView = StoreClosedView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height))
            self.view.addSubview(colsedView)
        }
    }
    
    func DECMaBannerClick(BannerView: DECMaBannerView, index: Int) {
        print(index)
        
        
        switch self.loopViewList[index - 1]["redirectWay"].stringValue {
        case "S"://跳转商品详情
            self.toGoodsDetail(id: self.loopViewList[index - 1]["commodityID"].stringValue)
//        case "C":
//            ""
        case "O"://跳转链接
            let vc = LYDWebViewController()
            vc.loadUrl = self.loopViewList[index - 1]["redirectUrl"].stringValue
            self.pushToNext(vc: vc)
        default:
            _=""
        }
    }
    func searchBtnClick(){
        self.pushToNext(vc: GoodsSearchViewController())
    }
//    地图选择的delegate
    func addressChose(coordinate:CLLocationCoordinate2D,addressInfo:String){
        choseAddress.setTitle("请送至:" + addressInfo, for: .normal)
        //        coordinate.latitude
        self.nowLocationName = addressInfo
        self.nowLocationLat = coordinate.latitude.getSixLocation()
        self.nowLocationLon = coordinate.longitude.getSixLocation()
        self.loadData()
    }
    func loadData(){
        self.goodsTypeTable.mj_header.endRefreshing()
        //加载店铺类型数据
        
        HttpTool.shareHttpTool.Http_getShopType() { (data) in
            self.shopTypeInfo = data.arrayValue
            if data.arrayValue.count > 0{
                self.loadHomePage(storeType:data[0]["storeType"].stringValue)
            }
        }
    }
    
    //        首页数据
    var noInfoView:NoStoreView?
    func loadHomePage(storeType:String){
        self.selectedStoreType = storeType
        self.reloadHomePageData(storeType:storeType)
        
        /*暂时不判断距离
        if nowLocation == nil{
            DispatchQueue.main.async {
                self.noInfoView = NoStoreView(frame: CGRect(x: 0, y: nav_height + 50, width: app_width, height: app_height - tab_height - nav_height + 50))
                self.view.addSubview(self.noInfoView!)
            }
            
        }else{
            DispatchQueue.main.async {
                self.noInfoView?.removeFromSuperview()
            }
            self.reloadHomePageData(storeType:storeType)
        }*/
        
    }
    var NoInfomation:NoInfomationView!
    func reloadHomePageData(storeType:String){
        self.goodsTypeTable.mj_header.endRefreshing()
        if shopTypeInfo.count == 0{
            self.loadData()
        }else{
            if let _ = nowLocationLat{
                HttpTool.shareHttpTool.Http_getHomePageInfo(storeType:storeType,lon: self.nowLocationLon!, lat: self.nowLocationLat!) { (datajson) in
                    //self.goodsTypeTable.mj_header.endRefreshing()
                    print(datajson!)
                    if let data = datajson{
                        //当前商铺信息
                        PAY_ORDER_TIME_OUT = data["PAY_ORDER_TIME_OUT"].intValue
                        TICKET_SHEAR_LIMIT = data["TICKET_SHEAR_LIMIT"].doubleValue
                        DispatchQueue.main.async {
                            self.NoInfomation.isHidden = true
                            storeInfomation = ShopModel(shopInfo:data["store"])
                            //轮播图数据
                            //self.loopView.imgJSON = data["bannerList"].arrayValue
                            self.loopViewList = data["bannerList"].arrayValue
                            self.commtypeList = data["commtypeList"].arrayValue
                            self.storeClassifyList = data["storeClassifyList"].arrayValue
                            self.adverstingView.initView(imgJSON: data["spreadList"].arrayValue)
                            //            self.goodsTypeTable.mj_header.endRefreshing()
                            //已打烊提示
                            self.storeStatus = data["store"]["status"].stringValue
                            
                        }
//                        if data["code"].stringValue == "SUCCESS"{
//                            
//                        }else{
//                            //店铺信息置为空
//                            storeInfomation = nil
//                            DispatchQueue.main.async {
//                                self.NoInfomation.isHidden = false
//                            }
//                        }
                    }else{
                        //店铺信息置为空
                        storeInfomation = nil
                        DispatchQueue.main.async {
                            self.NoInfomation.isHidden = false
                        }
                    }
                    
                    
                }
            }else{
//                self.myNoticeError(title: "需要先选择收货地址")
            }
        }
        
    }
    
    func choseAddressClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        if btn.isSelected{
            self.view.addSubview(alertAddress)
        }else{
            alertAddress.removeFromSuperview()
        }
        //地图页面
        
//        self.pushToNext(vc: AddressChoseViewController())
    }
    func turnToMessageVC() {
        //通知页面
        self.pushToNext(vc: MessageCenterViewController())
    }
    
    //店铺选择的delegate
    func TypeChoseClick(index:Int){
        //选择的店铺类型id
        let shopType = shopTypeInfo[index]["storeType"].stringValue
        self.selectedStoreType = shopType
//        print(shopTypeId)
        self.loadHomePage(storeType: shopType)
    }
    //限时特惠优选精品掌柜推荐折扣特价。。。。的选择
    func didSelectItem(index:Int){
        print(index)
        let vc = GoodsTypeListViewController()
//        yxzr
        vc.typeName = HomePageTitleArr[index]
        pushToNext(vc: vc)
    }
    
    func rightBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.setImage(UIImage(named: btn.isSelected ? "xuanz-yanse":"xuanze"), for: .normal)
        shopTypeDetial.animationShow(show:btn.isSelected)
    }
    
    func shopTypeDetailShow(show:Bool){
        
    }
    func noticeNumber(){
        HttpTool.shareHttpTool.Http_getNoticeNum{ (data) in
            print(data)
            DispatchQueue.main.async {
                if data["resultData"]["notice_type_p"].intValue > 0 || data["resultData"]["notice_type_s"].intValue > 0{
                    //需要通知的红点
                    self.messageBtn.setImage(UIImage(named:"youxiaoxi-bai"), for: .normal)
                }else{
                    self.messageBtn.setImage(UIImage(named:"xiaoxi-bai"), for: .normal)
                }
            }
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
    override func viewWillAppear(_ animated: Bool) {
        self.noticeNumber()
//        self.reloadHomePageData(storeType:self.selectedStoreType)
        self.tabBarController?.tabBar.tintColor = MyAppColor()
    }
    override func viewDidAppear(_ animated: Bool) {
        loopView.startOrCloseScroll(status: true)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        normChose.animationHide(hide: true)
        loopView.startOrCloseScroll(status: false)
    }
    func moreBtnClick(btn:UIButton){
        didSelectItem(index: (btn.tag/1000)-1)
        
    }
//    var tablecell = HomeScrollTableViewCell()
}
extension HomeViewController{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (app_width-5)/2, height: (app_width-20) * 2/3)
    }
//    返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId", for: indexPath) as! SectionHeaderCollectionReusableView
//            headerView.backgroundColor = UIColor.red
            headerView.headImgUrl = commtypeList[indexPath.section]["img"].stringValue
            var btntag:Int = 0
            switch commtypeList[indexPath.section]["typeName"].stringValue {
            case "优选精品":
                btntag = 1000
            case "限时抢购":
                btntag = 2000
            case "折扣特价":
                btntag = 3000
            default:
                btntag = 4000
            }
            headerView.moreBtn.tag = btntag
            headerView.moreBtn.addTarget(self, action: #selector(moreBtnClick(btn:)), for: .touchUpInside)
            
            reusableview = headerView
        }
        
        if kind == UICollectionElementKindSectionFooter{
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "footerId", for: indexPath) as! SectionFooterCollectionReusableView
            reusableview = footerView
        }
        return reusableview
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collection的选择
        let goodsId = commtypeList[indexPath.section]["storeCommodityList"][indexPath.row]["commodityID"].stringValue
        self.toGoodsDetail(id: goodsId)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commtypeList[section]["storeCommodityList"].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return commtypeList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodscell", for: indexPath) as! GoodsCollectionViewCell
        cell.selfViewController = self
        cell.delegate = self
        
        cell.goodsInfo = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]
        cell.indexRow = indexPath.item
//        cell.goodsNumInCar = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["commodityNum"].intValue
        cell.goodsName.text = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["commodityName"].stringValue
        cell.imageUrl = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["cover"].stringValue
        cell.goodsDetail.text = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["commodityRemark"].stringValue
        
        cell.oldPrice = "¥"+commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["retailPrice"].doubleValue.getMoney()
        var salePrice = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["retailPrice"].doubleValue.getMoney()
        
        if method.hasStringInArr(arrStr: commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["commodityTypes"].stringValue){
           salePrice = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["discountPrice"].doubleValue.getMoney()
            cell.goodsOldPrice.isHidden = false
        }else{
            cell.goodsOldPrice.isHidden = true
        }
        cell.nowPrice.text = salePrice
        cell.goodsStatus = commtypeList[indexPath.section]["storeCommodityList"][indexPath.item]["status"].stringValue
        return cell
    }
    /*************table的代理*******************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return storeClassifyList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view1 = UIView()
//        view1.backgroundColor = UIColor.white
        
        let img = UIImageView()
        img.backgroundColor = UIColor.red
        let imgUrl = storeClassifyList[section]["classifyImg"].stringValue
        method.loadImage(imgUrl: imgUrl, Img_View: img)
//        print(img.frame)
//        img.frame = CGRect(x: 0, y: 0, width: app_width, height: app_width * 0.1)
        img.contentMode = .scaleToFill
        
//        let moreBtn = UIButton()
//        method.creatButton(btn: moreBtn, x: app_width - 40, y: 0, wid: app_width * 0.1, hei: app_width * 0.1, title: "", titlecolor: UIColor.clear, titleFont: 0, bgColor:  UIColor.clear, superView: img)
//        moreBtn.setImage(UIImage(named:"gengduo"), for: .normal)
//        moreBtn.addTarget(self, action: #selector(moreBtnClick(btn:)), for: .touchUpInside)
        return img
//        view1.addSubview(img)
//        
//        return view1
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return app_width * 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as? HomeScrollTableViewCell
        if cell == nil{
            cell = HomeScrollTableViewCell()
        }
        cell!.selfCurrentVC = self
        cell!.delegate = self
        cell!.initView(goodsInfo: storeClassifyList[indexPath.section]["storeCommodityList"].arrayValue)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    func goodsChose(goodsId: String) {
        self.toGoodsDetail(id:goodsId)
    }
    
}

