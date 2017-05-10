//
//  GoodsDetailViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/10.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HomeScrollTableViewDelegate {

    var method = Methods()
    let bgYellowColor = setMyColor(r:253, g:186, b:0, a:1)
    var goodsId:String!//商品的id
    var guessYouLikeGoods:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.table.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)
            }
        }
    }
    //当前购物车中商品总件数
    var currentGoodsCount:Int = 0{
        didSet{
            DispatchQueue.main.async {
                self.countInCar.text = "\(self.currentGoodsCount)"
            }
        }
    }
    var goodsInfo:JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        loadData()
        guessYouLike(classifyID: "1")
        // Do any additional setup after loading the view.
    }
    func loadData(){
        HttpTool.shareHttpTool.Http_GetGoodsInfo(goodsId: goodsId) { (data) in
            print(data)
            self.goodsInfo = data
            DispatchQueue.main.async {
                self.creatView(infoJson: data)
            }
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
    func creatView(infoJson:JSON) {
        let topView = UIView()
//        app_height/3 + 70
        topView.frame = CGRect(x: 0, y: 0, width: app_width, height: app_width + 70)
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
        method.creatLabel(lab: goodsName, x: 15, y: loopView.bottomPosition(), wid: app_width - 30, hei: 20, textString: infoJson["commodityName"].stringValue, textcolor: UIColor.black, textFont: 14, superView: topView)
//        商品描述
        let goodsDetail = UILabel()
        method.creatLabel(lab: goodsDetail, x: 15, y: goodsName.bottomPosition(), wid: app_width - 30, hei: 20, textString: infoJson["commodityTypes"].stringValue, textcolor: UIColor.gray, textFont: 12, superView: topView)
        
        let moneyIcon = UILabel()
        method.creatLabel(lab: moneyIcon, x: 15, y: goodsDetail.bottomPosition() + 10, wid: 10, hei: 10, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: topView)
        
        let nowPrice = UILabel()
        method.creatLabel(lab: nowPrice, x: moneyIcon.rightPosition(), y: goodsDetail.bottomPosition() + 5, wid: 100, hei: 15, textString: infoJson["discountPrice"].doubleValue.getMoney(), textcolor: MyMoneyColor(), textFont: 16, superView: topView)
        nowPrice.sizeToFit()
        
        let oldPrice = UILabel()
        method.creatLabel(lab: oldPrice, x: nowPrice.rightPosition() + 10, y: moneyIcon.frame.origin.y - 2, wid: 100, hei: 15, textString: "¥"+infoJson["retailPrice"].doubleValue.getMoney(), textcolor: UIColor.gray, textFont: 12, superView: topView)
        oldPrice.sizeToFit()
        //添加删除线
        let line = CALayer()
        line.frame=CGRect(x: 0, y: oldPrice.frame.height/2, width: oldPrice.frame.width, height: 0.6)
        line.backgroundColor = UIColor.gray.cgColor
        oldPrice.layer.addSublayer(line)
        
        let count = UILabel()
        count.textAlignment = .right
        method.creatLabel(lab: count, x: app_width - 170, y: nowPrice.frame.origin.y, wid: 150, hei: 20, textString: "已售：\(infoJson["sales"].intValue)", textcolor: UIColor.gray, textFont: 12, superView: topView)
        
        
        table.frame = CGRect(x: 0, y: 0, width: app_width, height: app_height - 50)
        table.delegate = self
        table.dataSource = self
        table.tableHeaderView = topView
        table.register(UINib.init(nibName: "StoreIntroductionTableViewCell", bundle: nil), forCellReuseIdentifier: "storeIntroCell")
        self.view.addSubview(table)
        
        
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 20, y: 30, width: 30, height: 30)
        backBtn.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        backBtn.setImage(UIImage(named:"fanhui-baise"), for: .normal)
        backBtn.layer.cornerRadius = backBtn.frame.width/2
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
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
        
        normChose = NormChoseView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height), goodsInfo: goodsInfo)
        self.view.addSubview(normChose)
    }
    func setbottomBtn(btn:UIButton,x:CGFloat,title:String,img:String,superView:UIView){
        method.creatButton(btn: btn, x: x, y: 0, wid: superView.frame.width/3, hei: 50, title: "", titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.clear, superView: superView)
        
        let icon = UIImageView()
        icon.frame = CGRect(x: btn.frame.width/2 - 15, y: 5, width: 30, height: 30)
        icon.image = UIImage(named: img)
        btn.addSubview(icon)
        
        if title == "购物车"{
            
            countInCar.textAlignment = .center
            method.creatLabel(lab: countInCar, x: icon.frame.width - 15, y: 0, wid: 15, hei: 15, textString: "\(currentGoodsCount > 99 ? 99:currentGoodsCount)", textcolor: UIColor.white, textFont: 8, superView: icon)
            countInCar.backgroundColor = MyMoneyColor()
            countInCar.layer.cornerRadius = countInCar.frame.width/2
            countInCar.clipsToBounds = true
        }
        
        let buyCarTitle = UILabel()
        method.creatLabel(lab: buyCarTitle, x: 0, y: 35, wid: btn.frame.width, hei: 15, textString: title, textcolor: UIColor.gray, textFont: 10, superView: btn)
        buyCarTitle.textAlignment = .center
    }
    func addcarBtnClick(){
        if self.goodsInfo["normList"].arrayValue.count == 0{
            //没有可选商品规格时，直接添加到购物车
            let addCarView = UIView()
            addCarView.frame = CGRect(x: 0, y: 0, width: addcarBtn.frame.width, height: addcarBtn.frame.height)
            addCarView.backgroundColor = MyAppColor()
            addcarBtn.addSubview(addCarView)
            
            let lab = UILabel()
            lab.textAlignment = .center
            method.creatLabel(lab: lab, x: 0, y: 0, wid: 50, hei: addCarView.frame.height, textString: "数量:", textcolor: UIColor.white, textFont: 12, superView: addCarView)
            
        }else{
            normChose.animationHide(hide: false)
        }
    }
//    跳转购物车
    func buyCarBtnClick(){
//        print("11")
        let vc = LZCartViewController()
        vc.isHomeCarPage = false
        self.pushToNext(vc: vc)
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
        HttpTool.shareHttpTool.Http_GetCarGoods { (data) -> (Void) in
            //
            //计算购物车中商品的总件数
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
            method.creatLabel(lab: lab, x: 15, y: 0, wid: app_width - 30, hei: 30, textString: "商品提示：此商品每单限购两份", textcolor: UIColor.gray, textFont: 10, superView: cell.contentView)
            return cell
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "storeIntroCell") as? StoreIntroductionTableViewCell
            if cell == nil{
                cell = UINib(nibName: "StoreIntroductionTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! StoreIntroductionTableViewCell?
            }
            cell!.accessoryType = .disclosureIndicator
            method.loadImage(imgUrl: storeInfomation?.storeImg ?? "", Img_View: cell!.storeImage)
            cell!.storeName.text = storeInfomation?.storeName
            cell!.storeInfo.text = "¥\(storeInfomation?.startLimit ?? "0.00")元起送／满\(storeInfomation?.freeLimit ?? 0)元免配送费／配送费¥\(storeInfomation?.deliveryFee ?? "0")"
            cell!.storeOpenTime.text = "营业时间\(storeInfomation?.businessHours ?? "未设置")"
            cell!.status.backgroundColor = MyAppColor()
            if storeInfomation!.status == "1"{
                cell!.status.text = "营业中"
            }else{
                cell!.status.text = "已下班"
            }
            
            return cell!
        case 2:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as? HomeScrollTableViewCell
            if cell == nil{
                cell = HomeScrollTableViewCell()
            }
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
        method.drawLine(startX: 15, startY: 34, wid: app_width - 15, hei: 0.6, add: headerView)
        return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 30
        case 1:
            return 80
        case 2:
            return (app_width-20) * 2/3
        default:
            return 60
        }
        //        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
