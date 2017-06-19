//
//  GoodsDetailViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/10.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,HomeScrollTableViewDelegate,NormChoseViewDelegate {

    var nowGoodsId:String?
    var isXianshiTejia:Bool = false
//    var
    var method = Methods()
    var daojishiTimer:Timer?
    let bgYellowColor = setMyColor(r:253, g:186, b:0, a:1)
    var goodsId:String!//商品的id
    var guessYouLikeGoods:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.table.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)
            }
        }
    }
    var limitCount:Int = 0
    //当前购物车中商品总件数
    var currentGoodsCount:Int = 0{
        didSet{
            DispatchQueue.main.async {
                self.countInCar.text = "\(self.currentGoodsCount)"
            }
        }
    }
    var goodsInfo:JSON!
    //抢购剩余时间，秒
    var daojishiTime:Int = 0{
        didSet{
            let min = daojishiTime/60%60 //分钟xianshi
            let hours = daojishiTime/60/60%24 //小时
            let days = daojishiTime/60/60/24 //天数
            DispatchQueue.main.async {
                self.shenyuDay.text = String(format: "%02ld", days) //倒计时天数
                self.shenyuHours.text = String(format: "%02ld", hours)//倒计时小时
                self.shenyuMinites.text = String(format: "%02ld", min)//倒计时分钟
            }
        }
    }
    let backBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        backBtn.frame = CGRect(x: 20, y: 30, width: 30, height: 30)
        backBtn.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        backBtn.setImage(UIImage(named:"fanhui-baise"), for: .normal)
        backBtn.layer.cornerRadius = backBtn.frame.width/2
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        loadData()
        
        
        // Do any additional setup after loading the view.
    }
    func loadData(){
        HttpTool.shareHttpTool.Http_GetGoodsInfo(goodsId: goodsId) { (data) in
            print(data)
            self.goodsInfo = data
            let nowtime = self.method.getNowTimeStamp()
            self.limitCount = data["snappedupLimit"].int ?? 0
            if data["snappedupStartTime"].intValue/1000 < nowtime && nowtime < data["snappedupTime"].intValue/1000{
                self.isXianshiTejia = true
                //抢购的剩余时间
                DispatchQueue.main.async {
                    self.creatView(infoJson: data)
                    self.daojishiTime = data["snappedupTime"].intValue/1000 - nowtime
                    self.daojishiTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updateDaojishiTime), userInfo: nil, repeats: true)
                }
//
            }else{
                DispatchQueue.main.async {
                    self.creatView(infoJson: data)
                }
            }
            self.guessYouLike(classifyID: data["parentID"].stringValue)
        }
    }
    func updateDaojishiTime(){
        if daojishiTime <= 0{
            daojishiTimer?.invalidate()
            daojishiTimer = nil
            self.myNoticeError(title: "抢购时间已到期")
            self.backPage()
        }else{
            daojishiTime -= 60
        }
    }
    func guessYouLike(classifyID:String){
//        c表示销量最高排序
        HttpTool.shareHttpTool.Http_GetGoodsByCategory(classifyID: classifyID, startIndex: 0, sortType: "C") { (data) -> (Void) in
//            print(data)
            self.guessYouLikeGoods = data.arrayValue
        }
    }
//    DECMaBannerView(frame: CGRect(x:0,y:0,width:app_width,height:app_width))
    let loopView : DECMaBannerView = DECMaBannerView(frame: CGRect(x:0,y:0,width:app_width,height:app_width), radiusNeed: false)
    let countInCar = UILabel()//购物车中商品总数量
    var normChose:NormChoseView!
    var addcarBtn:UIButton!
    let table = UITableView()
    let goodsDetaildWeb = UIWebView()
    let shenyuDay = UILabel()//倒计时天数
    let shenyuHours = UILabel()//倒计时小时
    let shenyuMinites = UILabel()//倒计时分钟
    
    func creatView(infoJson:JSON) {
        //当前商品的id，留着在没有规格商品的时候备用
        self.nowGoodsId = infoJson["commodityID"].stringValue
        
        let topView = UIView()
//        app_height/3 + 70
        let topViewHeight:CGFloat = isXianshiTejia ? 130 : 80
        topView.frame = CGRect(x: 0, y: 0, width: app_width, height: app_width + topViewHeight)
        topView.backgroundColor = MyGlobalColor()
//        self.view.addSubview(topView)
        var imgArr:[String] = []
        if infoJson["imgList"].arrayValue.count == 0{
            imgArr.append(infoJson["cover"].stringValue)
        }else{
            for item in infoJson["imgList"].arrayValue{
                imgArr.append(item["imgUrl"].stringValue)
            }
        }
        
//        print(imgArr)
        loopView.titleArray = imgArr
        topView.addSubview(loopView)
//        商品名称
        let goodsName = UILabel()
        method.creatLabel(lab: goodsName, x: 15, y: loopView.bottomPosition() + 10, wid: app_width - 30, hei: 20, textString: infoJson["commodityName"].stringValue, textcolor: UIColor.black, textFont: 14, superView: topView)
//        商品描述
        let goodsDetail = UILabel()
        method.creatLabel(lab: goodsDetail, x: 15, y: goodsName.bottomPosition(), wid: app_width - 30, hei: 25, textString: infoJson["commodityPrompt"].stringValue, textcolor: UIColor.gray, textFont: 12, superView: topView)
        
        let moneyIcon = UILabel()
        method.creatLabel(lab: moneyIcon, x: 15, y: goodsDetail.bottomPosition() + 5, wid: 10, hei: 10, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: topView)
        
//        let salePrice = isXianshiTejia ? infoJson["discountPrice"].doubleValue.getMoney():infoJson["retailPrice"].doubleValue.getMoney()
        var salePrice = infoJson["retailPrice"].doubleValue.getMoney()
        
        let oldPrice = UILabel()
        if method.hasStringInArr(arrStr: infoJson["commodityTypes"].stringValue){
            salePrice = infoJson["discountPrice"].doubleValue.getMoney()
        }else{
            oldPrice.isHidden = true
        }
//
//        
        let nowPrice = UILabel()
        method.creatLabel(lab: nowPrice, x: moneyIcon.rightPosition(), y: goodsDetail.bottomPosition(), wid: 100, hei: 15, textString: salePrice, textcolor: MyMoneyColor(), textFont: 16, superView: topView)
        nowPrice.font = UIFont(name: "Helvetica-Bold", size: 16)
        nowPrice.sizeToFit()
        
        
        method.creatLabel(lab: oldPrice, x: nowPrice.rightPosition() + 10, y: moneyIcon.frame.origin.y - 2, wid: 100, hei: 15, textString: "¥"+infoJson["retailPrice"].doubleValue.getMoney(), textcolor: UIColor.gray, textFont: 12, superView: topView)
        oldPrice.sizeToFit()
        //添加删除线
        let line = CALayer()
        line.frame=CGRect(x: 0, y: oldPrice.frame.height/2, width: oldPrice.frame.width, height: 0.6)
        line.backgroundColor = UIColor.gray.cgColor
        oldPrice.layer.addSublayer(line)
        
        let count = UILabel()
        count.textAlignment = .right
        method.creatLabel(lab: count, x: app_width - 170, y: nowPrice.frame.origin.y, wid: 150, hei: 20, textString: "销量：\(infoJson["sales"].intValue)", textcolor: UIColor.gray, textFont: 12, superView: topView)
        //限时特购计时器
        if isXianshiTejia{
            let daojishiView = UIView()
            daojishiView.frame = CGRect(x: 0, y: topView.frame.height - 50, width: app_width, height: 40)
            daojishiView.backgroundColor = bgYellowColor
            topView.addSubview(daojishiView)
            
            let shalou = UIImageView()
            method.creatImage(img: shalou, x: 15, y: 10, wid: 20, hei: 20, imgName: "shalou", imgMode: .center, superView: daojishiView)
            let shengyu = UILabel()
            method.creatLabel(lab: shengyu, x: shalou.rightPosition() + 10, y: 10, wid: 40, hei: 20, textString: "剩余", textcolor: UIColor.white, textFont: 12, superView: daojishiView)
            
//            let shenyuDay = UILabel()
            creatDaojishiView(orgin_x: shengyu.rightPosition(), timeTitleLab: shenyuDay, title: "天", superView: daojishiView)
            
//            let shenyuHours = UILabel()
            creatDaojishiView(orgin_x: shengyu.rightPosition() + 50, timeTitleLab: shenyuHours, title: "小时", superView: daojishiView)
            
//            let shenyuMinites = UILabel()
            creatDaojishiView(orgin_x: shengyu.rightPosition() + 110, timeTitleLab: shenyuMinites, title: "分", superView: daojishiView)
        }
        
        table.frame = CGRect(x: 0, y: 0, width: app_width, height: app_height - 50)
        table.delegate = self
        table.dataSource = self
        table.tableHeaderView = topView
        table.showsVerticalScrollIndicator = false
        table.register(UINib.init(nibName: "StoreIntroductionTableViewCell", bundle: nil), forCellReuseIdentifier: "storeIntroCell")
        self.view.addSubview(table)
        
        let upPullLoad = UIView()
        upPullLoad.frame = CGRect(x: 0, y: 0, width: app_width, height: 40)
        upPullLoad.backgroundColor = setMyColor(r: 247, g: 248, b: 249, a: 1)
        table.tableFooterView = upPullLoad
        
        let uoloadWord = UILabel()
        method.creatLabel(lab: uoloadWord, x: app_width/2 - 60, y: 0, wid: 120, hei: 30, textString: "向上拖动，查看图文", textcolor: setMyColor(r: 76, g: 77, b: 78, a: 1), textFont: 12, superView: upPullLoad)
        uoloadWord.textAlignment = .center
//        method.drawLineWithColor(startX: 15, startY: 15, wid: app_width/2 - 80, hei: 0.6, lineColor: UIColor.red, add: upPullLoad)
        method.drawLine(startX: 15, startY: 15, wid: app_width/2 - 80, hei: 0.6, add: upPullLoad)
        method.drawLine(startX: app_width/2 + 65, startY: 15, wid: app_width/2 - 80, hei: 0.6, add: upPullLoad)
        
        
        goodsDetaildWeb.frame = CGRect(x: 0, y: table.bottomPosition(), width: app_width, height: table.frame.height)
//        goodsDetaildWeb.delegate = self
        goodsDetaildWeb.scrollView.delegate = self
        let htmlUrl = "\(shareHeaderUrl)/classifyapp/commodityInfoPage?storeID=" + infoJson["storeID"].stringValue + "&commodityID=" + infoJson["commodityID"].stringValue
//        let htmlStr = htmlUrl
        print(htmlUrl)
        if let url = URL(string: htmlUrl){
            let request = URLRequest(url: url)
            goodsDetaildWeb.loadRequest(request)
        }
        
        self.view.addSubview(goodsDetaildWeb)
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: app_height - 50, width: app_width, height: 50)
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        method.drawLine(startX: 0, startY: 0, wid: app_width, hei: 0.6, add: bottomView)
        
        let buyCarBtn = UIButton()
        setbottomBtn(btn: buyCarBtn, x: 0, title: "购物车", img: "gouwuche-wei", superView: bottomView)
        method.drawLine(startX: bottomView.frame.width/3-1, startY: 0, wid: 0.6, hei: bottomView.frame.height, add: buyCarBtn)
        buyCarBtn.addTarget(self, action: #selector(buyCarBtnClick), for: .touchUpInside)
        
        let shopBtn = UIButton()
        setbottomBtn(btn: shopBtn, x: bottomView.frame.width/3, title: "进店逛逛", img: "首页-未选中", superView: bottomView)
        shopBtn.addTarget(self, action: #selector(shopBtnClick), for: .touchUpInside)
        
        addcarBtn = UIButton()//添加购物车按钮
        method.creatButton(btn: addcarBtn, x: bottomView.frame.width * 2/3, y: 0, wid: bottomView.frame.width/3, hei: bottomView.frame.height, title: "加入购物车", titlecolor: UIColor.white, titleFont: 14, bgColor: bgYellowColor, superView: bottomView)
        addcarBtn.addTarget(self, action: #selector(addcarBtnClick), for: .touchUpInside)
        
        //移动到最外层
        self.view.bringSubview(toFront: backBtn)
        
        normChose = NormChoseView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height))
        normChose.goodsInfo = goodsInfo
        normChose.delegate = self
        self.view.addSubview(normChose)
        
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let maxoffset_y:CGFloat = 100
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        if scrollView.isKind(of: UITableView.classForCoder()){
            let valueNum = table.contentSize.height - app_height

            if offsetY - valueNum > maxoffset_y{
                self.gotoGoodsDetail()
            }
        }else{
            if offsetY < 0 && -offsetY > maxoffset_y{
                self.gotoUpInfo()
            }
        }
    }
    //去商品详情
    func gotoGoodsDetail(){
        UIView.animate(withDuration: 0.5) { 
            self.table.frame.origin.y = -(self.table.frame.height)
            self.goodsDetaildWeb.frame.origin.y = 0
        }
    }
//    去顶部信息
    func gotoUpInfo(){
        UIView.animate(withDuration: 0.5) {
            self.table.frame.origin.y = 0
            self.goodsDetaildWeb.frame.origin.y = self.table.frame.height
        }
//        UIView.animate(withDuration: 0.5, animations: { 
//            
//        }, completion: nil)
    }
    //倒计时view
    func creatDaojishiView(orgin_x:CGFloat,timeTitleLab:UILabel,title:String,superView:UIView){
        
        method.creatLabel(lab: timeTitleLab, x: orgin_x, y: 13, wid: 15, hei: 15, textString: "03", textcolor: UIColor.gray, textFont: 10, superView: superView)
//        timeTitleLab.frame = CGRect(x: orgin_x, y: 13, width: 15, height: 15)
//        timeTitleLab.textColor = UIColor.gray
//        timeTitleLab.font = UIFont.systemFont(ofSize: 10)
        timeTitleLab.backgroundColor = UIColor.white
        timeTitleLab.textAlignment = .center
//        superView.addSubview(timeTitleLab)
        
        let Title = UILabel()
        method.creatLabel(lab: Title, x: timeTitleLab.rightPosition() + 5, y: 13, wid: 30, hei: 15, textString: title, textcolor: UIColor.white, textFont: 12, superView: superView)
    }
    func setbottomBtn(btn:UIButton,x:CGFloat,title:String,img:String,superView:UIView){
        method.creatButton(btn: btn, x: x, y: 0, wid: superView.frame.width/3, hei: 50, title: "", titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.clear, superView: superView)
        
        let icon = UIImageView()
        icon.frame = CGRect(x: btn.frame.width/2 - 15, y: 5, width: 30, height: 30)
        icon.image = UIImage(named: img)
        btn.addSubview(icon)
        
        if title == "购物车"{
            
            countInCar.textAlignment = .center
            method.creatLabel(lab: countInCar, x: icon.frame.width - 10, y: 0, wid: 15, hei: 15, textString: "\(currentGoodsCount > 99 ? 99:currentGoodsCount)", textcolor: UIColor.white, textFont: 8, superView: icon)
            countInCar.backgroundColor = MyMoneyColor()
            countInCar.layer.cornerRadius = countInCar.frame.width/2
            countInCar.clipsToBounds = true
        }
        
        let buyCarTitle = UILabel()
        method.creatLabel(lab: buyCarTitle, x: 0, y: 35, wid: btn.frame.width, hei: 15, textString: title, textcolor: UIColor.gray, textFont: 10, superView: btn)
        buyCarTitle.textAlignment = .center
    }
    
    //没有可选商品规格时，直接添加到购物车
    let addCarView = UIView()
    var defaultCount:Int = 0{
        didSet{
            DispatchQueue.main.async {
                if self.defaultCount >= 1{
                    self.buyNumber.text = "\(self.defaultCount)"
                }else{
                    self.buyNumber.textColor = UIColor.red
                    self.addCarView.removeFromSuperview()
                }
            }
        }
    }
    var buyNumber:UILabel!
    func addcarBtnClick(){
        
//        guard true else {
//            self.myNoticeError(title: "此商品已售罄")
//            return
//        }
        if method.isLogin(){
            if self.goodsInfo["normList"].arrayValue.count == 0{
                //            //没有可选商品规格时，直接添加到购物车
                //            let addCarView = UIView()
                addCarView.frame = CGRect(x: 0, y: 0, width: addcarBtn.frame.width, height: addcarBtn.frame.height)
                addCarView.backgroundColor = MyAppColor()
                addcarBtn.addSubview(addCarView)
                
                let lab = UILabel()
                lab.textAlignment = .center
                method.creatLabel(lab: lab, x: 0, y: 0, wid: 40, hei: addCarView.frame.height, textString: "数量:", textcolor: UIColor.white, textFont: 12, superView: addCarView)
                
                //加减号的宽高  -3  表示最后+和边距的距离   3*3 = 9
                let btnwidth = (addcarBtn.frame.width - lab.frame.width) * 2/7 - 3
                let cutBtn = UIButton()
                method.creatButton(btn: cutBtn, x: lab.rightPosition(), y: (addcarBtn.frame.height - btnwidth)/2, wid: btnwidth, hei: btnwidth, title: "", titlecolor: UIColor.white, titleFont: 14, bgColor: UIColor.clear, superView: addCarView)
                cutBtn.addTarget(self, action: #selector(cutgoodsFromCar), for: .touchUpInside)
                cutBtn.setImage(UIImage(named:"jianbuy"), for: .normal)
                
                buyNumber = UILabel()
                method.creatLabel(lab: buyNumber, x: cutBtn.rightPosition(), y: 0, wid: btnwidth * 1.5, hei: addCarView.frame.height, textString: "\(defaultCount)", textcolor: UIColor.white, textFont: 12, superView: addCarView)
                buyNumber.textAlignment = .center
                //            self.buyGoodsNumber = buyNumber
                
                let addBtn = UIButton()
                method.creatButton(btn: addBtn, x: buyNumber.rightPosition(), y: (addcarBtn.frame.height - btnwidth)/2, wid: btnwidth, hei: btnwidth, title: "", titlecolor: UIColor.white, titleFont: 14, bgColor: UIColor.clear, superView: addCarView)
                addBtn.addTarget(self, action: #selector(addgoodsToCar), for: .touchUpInside)
                //            addBtn.layer.cornerRadius = cutBtn.frame.width/2
                addBtn.setImage(UIImage(named:"jiabuy"), for: .normal)
                
                //点击了添加就先加一个
                self.addgoodsToCar()
            }else{
                normChose.goodsInfo = goodsInfo
                normChose.animationHide(hide: false)
            }
        }else{
            needLoginApp()
        }
        
    }
    func needLoginApp(){
        let alert = UIAlertController(title: nil, message: "需要登录才能加入购物车", preferredStyle: .alert)
        let act1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let act2 = UIAlertAction(title: "立即登录", style: .default, handler: { (alt) in
            self.pushToNext(vc: LoginAppViewController())
        })
        alert.addAction(act1)
        alert.addAction(act2)
        self.present(alert, animated: true, completion: nil)
    }
    //无规格的时候直接添加商品
    func addgoodsToCar(){
        if let id = nowGoodsId{
            method.addTocar(goodId: id, norm: "") { (resultValue) -> (Void) in
                if resultValue{
                    self.defaultCount += 1
                    self.currentGoodsCount += 1
                }
            }
        }
    }
    //无规格的时候直接减少商品
    func cutgoodsFromCar(){
        if let id = nowGoodsId{
            method.cutFromcar(goodsId: id) { (resultValue) -> (Void) in
                if resultValue{
                    self.defaultCount -= 1
                    self.currentGoodsCount -= 1
                }
            }
        }
        
    }
//    跳转购物车
    func buyCarBtnClick(){
//        print("11")
        if method.isLogin(){
            let vc = LZCartViewController()
            vc.isHomeCarPage = false
            self.pushToNext(vc: vc)
        }else{
            needLoginApp()
        }
        
    }
//    跳转店铺首页
    func shopBtnClick(){
//        print("11")
        let vc = StoreInfomationViewController()
        self.pushToNext(vc: vc)
    }
//    返回
    func backBtnClick() {
        self.backPage()
    }
    func goodsChose(goodsId:String){
        let vc = GoodsDetailViewController()
        vc.goodsId = goodsId
        self.pushToNext(vc: vc)
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshCarNumber()
    }
    func NormChoseEnd(){
        //规格选择结束
        refreshCarNumber()
    }
    func HomeScrollTableViewNormChose(goodsInfo:JSON){
        normChose.goodsInfo = goodsInfo
        normChose.animationHide(hide: false)
    }
    //计算购物车中商品的总件数
    func refreshCarNumber(){
        HttpTool.shareHttpTool.Http_GetCarGoods { (data) -> (Void) in
            //
            
            var count = 0
            for item in data["detailsList"].arrayValue{
                //
                count += item["num"].intValue
            }
            self.currentGoodsCount = count
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension GoodsDetailViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1{
            //去店铺主页
            shopBtnClick()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: app_width - 30, hei: 40, textString: "商品提示：此商品每单限购\(limitCount)份", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            if limitCount == 0{
                lab.isHidden = true
            }
            return cell
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "storeIntroCell") as? StoreIntroductionTableViewCell
            if cell == nil{
                cell = UINib(nibName: "StoreIntroductionTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! StoreIntroductionTableViewCell?
            }
            cell!.storeImage.layer.cornerRadius = 5
            cell!.accessoryType = .disclosureIndicator
            method.loadImage(imgUrl: storeInfomation?.storeImg ?? "", Img_View: cell!.storeImage)
            cell!.storeName.text = storeInfomation?.storeName
            cell!.storeInfo.text = "¥\(storeInfomation?.startLimit ?? "0.00")元起送/满\(storeInfomation?.freeLimit ?? 0)元免配送费/配送费¥\(storeInfomation?.deliveryFee ?? "0")"
            cell!.storeOpenTime.text = "营业时间\(storeInfomation?.businessHours ?? "未设置")"
            cell!.status.backgroundColor = MyAppColor()
            if storeInfomation!.status == "0"{
                cell!.status.text = "营业中"
            }else{
                cell!.status.text = "已下班"
            }
            if app_width <= 320.0{
                cell!.storeInfo.font = UIFont.systemFont(ofSize: 9)
            }else if app_width >= 540.0{
                cell!.storeInfo.font = UIFont.systemFont(ofSize: 12)
            }
            
            return cell!
        case 2:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as? HomeScrollTableViewCell
            if cell == nil{
                cell = HomeScrollTableViewCell()
            }
            cell!.selfCurrentVC = self
            cell!.delegate = self
            cell!.initView(goodsInfo: guessYouLikeGoods)
            return cell!
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 35:0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let title = UILabel()
        method.creatLabel(lab: title, x: 15, y: 0, wid: 200, hei: 34, textString: "猜你喜欢", textcolor: UIColor.black, textFont: 13, superView: headerView)
        let moreIcon = UIImageView()
        method.creatImage(img: moreIcon, x: app_width - 30, y: 7, wid: 20, hei: 20, imgName: "kebianjijiantou", imgMode: .scaleAspectFit, superView: headerView)
        
        method.drawLine(startX: 15, startY: 34, wid: app_width - 15, hei: 0.6, add: headerView)
        return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.limitCount == 0 ? 0:40
        case 1:
            return 90
        case 2:
//            var selfHeight = (app_width-20)/2
            return (app_width-20)/2
        default:
            return 60
        }
        //        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
