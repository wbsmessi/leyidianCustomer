//
//  LZCartViewController.swift
//  CartDemo_Swift
//
//  Created by Artron_LQQ on 16/6/27.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit
import SwiftyJSON


class LZCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddressViewDelegate {
    var method = Methods()
    var dataArray: [LZCartModel] = []
    var selectArray: [LZCartModel] = []
    var addressInfo:JSON?
    //    当前是否上班
    var shopOpen:Bool = true
    //是否是编辑状态
    var isEdit:Bool = false{
        didSet{
//            submitBtn?.setTitle(isEdit ? "删除":"去结算", for: .normal)
            bottomBackgroundView.isHidden = isEdit
            bottomBackgroundViewEdit.isHidden = !isEdit
            if isEdit{
                bottomBackgroundViewEdit.addSubview(allSelectButton!)
            }else{
                bottomBackgroundView.addSubview(allSelectButton!)
            }
            tableView?.reloadData()
        }
    }
    var currentPayMoney:Double = 0.00{
        didSet{
            //处理结算按钮的颜色问题
            var btnTitle = "去结算"
            let minMoney = storeInfomation?.startLimit ?? "0.00"
            let needMore = Double(minMoney)! - currentPayMoney
            if needMore > 0.00 {
                btnTitle = "还差" + needMore.getMoney() + "元起送"
                commitButton.backgroundColor = UIColor.lightGray
            }else{
                commitButton.backgroundColor = MyAppColor()
            }
            commitButton.setTitle(btnTitle, for: .normal)
        }
    }
    var tableView: UITableView? = nil
    var saveMoneyLabel: UILabel?
    var priceLabel: UILabel?
    var allSelectButton: UIButton?
    var storeNameStr:NSMutableAttributedString?{
        didSet{
            DispatchQueue.main.async {
                self.storeName.attributedText = self.storeNameStr
            }
        }
    }
    var commitButton:UIButton!
    //header   店铺名称+状态
    let storeName = UILabel()
    //是否是四大主页之一的购物车
    var isHomeCarPage:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.setupNavBar()
        
//        self.emptyView()
        self.setupTableView()
        self.setupBottomView()
        
        emptyView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*创建表视图*/
    func setupTableView() {
        
        tableView = UITableView(frame: CGRect.zero,style: UITableViewStyle.plain)
        let table_height = isHomeCarPage ? app_height - nav_height - 2*tab_height : app_height - nav_height - tab_height
        tableView?.frame = CGRect(x: 0, y: nav_height, width: app_width, height: table_height)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = MyGlobalColor()
//        tableView?.rowHeight = 100
        tableView?.showsVerticalScrollIndicator = false
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        
    }
    /*计算总金额*/
    func priceCount() {
//        print(43763476347634768)
        var price: Double = 0.0
        var saveMoney: Double = 0.00
        for model in self.selectArray {
            print(model.number)
            let pri = Double(model.price!)
            price += pri! * Double(model.number)
            print(price)
            
            let oldpri = Double(model.oldprice!)
            saveMoney += oldpri! * Double(model.number)
            print(saveMoney)
        }
//        for model in self.dataArray {
//            print(model.number)
//            let chosed = model.select ?? false
//            if  chosed == true{
//                let pri = Double(model.price!)
//                price += pri! * Double(model.number)
//                
//                let oldpri = Double(model.oldprice!)
//                saveMoney += oldpri! * Double(model.number)
//            }
//        }
        currentPayMoney = price
        saveMoney = (saveMoney - price <= 0.0) ? 0.0 : saveMoney - price
        DispatchQueue.main.async {
            self.saveMoneyLabel?.text = "已优惠：¥\(saveMoney.getMoney())"
            self.priceLabel?.attributedText = self.priceString("\(price.getMoney())")
        }
    }
    
    
    /*创建自定义导航*/
    func setupNavBar() {
        self.setTitleView(title: "购物车", canBack: !isHomeCarPage)
        
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: app_width - 80, y: 34, wid: 80, hei: 30, title: "编辑", titlecolor: UIColor.black, titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        rightBtn.addTarget(self, action: #selector(toEditCar(btn:)), for: .touchUpInside)
//
    }
    func toEditCar(btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.setTitle(btn.isSelected ? "完成":"编辑", for: .normal)
        isEdit = btn.isSelected
    }
    /*创建底部视图*/
    //正常状态的底部view
    let bottomBackgroundView = UIView()
    //编辑状态的底部view
    let bottomBackgroundViewEdit = UIView()
    func setupBottomView() {
        //正常状态的底部view
        let backView_Y = isHomeCarPage ? app_height - 2*tab_height : app_height - tab_height
        bottomBackgroundView.frame = CGRect(x: 0, y: backView_Y, width: app_width, height: tab_height)
        bottomBackgroundView.backgroundColor = MyGlobalColor()
        self.view.addSubview(bottomBackgroundView)
        
        method.drawLine(startX: 0, startY: 0, wid: app_width, hei: 0.6, add: bottomBackgroundView)
        
        let seletAllButton = UIButton(type: .custom)
        seletAllButton.frame = CGRect(x: 10, y: 5, width: 80, height: tab_height - 10)
        seletAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        seletAllButton.setTitle("  全选", for: UIControlState())
        seletAllButton.setImage(UIImage(named: "weixuanze"), for: UIControlState())
        seletAllButton.setImage(UIImage(named: "xuanze-1"), for: UIControlState.selected)
        seletAllButton.setTitleColor(UIColor.gray, for: UIControlState())
        seletAllButton.addTarget(self, action: #selector(selectAllButtonClick), for: UIControlEvents.touchUpInside)
        bottomBackgroundView.addSubview(seletAllButton)
        allSelectButton = seletAllButton
        
        commitButton = UIButton(type: .custom)
        commitButton.frame = CGRect(x: app_width - 100, y: 0, width: 100, height: tab_height)
        
        let minMoney = storeInfomation?.startLimit ?? "0.00"
//        print(minMoney ?? "0.00")
        var btnTitle = "去结算"
        if Double(minMoney)! > 0.00 {
            btnTitle = "还差" + minMoney + "元起送"
            commitButton.backgroundColor = UIColor.lightGray
        }else{
            commitButton.backgroundColor = MyAppColor()
        }
        commitButton.setTitle(btnTitle, for: UIControlState())
        commitButton.titleLabel!.font=UIFont.systemFont(ofSize: 12)
        commitButton.titleLabel?.lineBreakMode = .byCharWrapping
        commitButton.titleLabel?.numberOfLines = 2
        commitButton.addTarget(self, action: #selector(comitButtonClick), for: UIControlEvents.touchUpInside)
        bottomBackgroundView.addSubview(commitButton)
        
        let saveMoney = UILabel()
        method.creatLabel(lab: saveMoney, x: seletAllButton.rightPosition() + 10, y: 5, wid: app_width - 120 - seletAllButton.rightPosition(), hei: 20, textString: "已优惠：¥0.00", textcolor: UIColor.gray, textFont: 12, superView: bottomBackgroundView)
        saveMoney.textAlignment = .right
        self.saveMoneyLabel = saveMoney
        
        let priceLabel = UILabel()
        priceLabel.frame = CGRect(x: saveMoney.frame.origin.x, y: saveMoney.bottomPosition(), width: saveMoney.frame.width, height: 20)
        priceLabel.font = UIFont.systemFont(ofSize: 13)
        priceLabel.textColor = MyMoneyColor()
        priceLabel.textAlignment = .right
        bottomBackgroundView.addSubview(priceLabel)
        self.priceLabel = priceLabel
        priceLabel.attributedText = self.priceString("0.00")
        
        //编辑状态的底部view
        bottomBackgroundViewEdit.frame = bottomBackgroundView.frame
        bottomBackgroundViewEdit.backgroundColor = MyGlobalColor()
        bottomBackgroundViewEdit.isHidden = true
        self.view.addSubview(bottomBackgroundViewEdit)
        method.drawLine(startX: 0, startY: 0, wid: app_width, hei: 0.6, add: bottomBackgroundViewEdit)

        let editBtn = UIButton()
        editBtn.frame = commitButton.frame
        editBtn.backgroundColor = MyAppColor()
        editBtn.setTitle("删除", for: UIControlState())
        editBtn.titleLabel!.font=UIFont.systemFont(ofSize: 16)
        editBtn.addTarget(self, action: #selector(deleteCarGoods), for: UIControlEvents.touchUpInside)
        bottomBackgroundViewEdit.addSubview(editBtn)
        
        
    }
    func deleteCarGoods(){
        //批量删除商品，  ID 是
        var detailsId = ""
        for i in 0..<self.selectArray.count{
            detailsId += "\(self.selectArray[i].detailsID!)"
            if i != self.selectArray.count - 1{
                detailsId += ","
            }
        }
        print(detailsId)
        deleteGoodsById(id:detailsId)
    }
    func deleteGoodsById(id:String){
        var newDataArr:[LZCartModel] = []
        for item in self.dataArray{
            if item.select != true{
                newDataArr.append(item)
            }
        }
        
        HttpTool.shareHttpTool.Http_DeleteGoodsFromCar(detailsID: id) { (data) in
            //暂无处理
            if data["code"].stringValue == "SUCCESS"{
//                self.dataArray = newDataArr
//                DispatchQueue.main.async {
//                    self.tableView?.reloadData()
//                    self.priceCount()
//                }
//                if self.selectArray.count == self.dataArray.count {
//                    self.allSelectButton?.isSelected = true
//                } else {
//                    self.allSelectButton?.isSelected = false
//                }
//                
//                if self.dataArray.count == 0 {
//                    
//                    self.emptyView()
//                }
                self.reloadCarData()
            }
        }
    }
    /*富文本字符串*/
    func priceString(_ price: String) -> NSMutableAttributedString {
        
        let text = "实付金额:¥" + price
        let attributedString = NSMutableAttributedString.init(string: text)
        
        let rang = (text as NSString).range(of: "实付金额:")
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: rang)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: rang)
        
        return attributedString
    }
    
    /*全选按钮点击事件*/
    func selectAllButtonClick(_ button: UIButton) {
        
        button.isSelected = !button.isSelected
        
        for model in self.selectArray {
            model.select = false
        }
        
        self.selectArray.removeAll()
        
        if button.isSelected {
            for model in self.dataArray {
                model.select = true
                
                self.selectArray.append(model)
            }
        }
        
        self.tableView?.reloadData()
        self.priceCount()
    }
    /*提交按钮点击事件*/
    func comitButtonClick() {
        guard shopOpen else {
            self.myNoticeError(title: "商家已下班")
            return
        }
        guard commitButton.backgroundColor == MyAppColor() else {
            return
        }
        guard addressInfo != nil else {
            self.myNoticeError(title: "请先选择收获地址")
            return
        }
        var detailsIDs:[Int] = []
        for model in self.selectArray {
            detailsIDs.append(model.detailsID!)
//            print("选择的商品:\(model)")
        }
        
        submitOrder(detailsIDs: detailsIDs)
        
        
    }
    func submitOrder(detailsIDs: [Int]){
        print(detailsIDs)
        HttpTool.shareHttpTool.Http_CreateOrder(detailsIDs: detailsIDs, addressID: self.addressInfo!["addressID"].stringValue) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                let vc = PrePayOrderViewController()
                vc.addressInfo = self.addressInfo
                vc.orderInfo = data["resultData"]
                DispatchQueue.main.async {
                    self.pushToNext(vc: vc)
                }
            }else{
                self.myNoticeError(title: data["msg"].stringValue)
            }
        }
    }
    /*购物车为空时的视图*/
    let backgroundEmptyView = UIView()
    func emptyView() {
        backgroundEmptyView.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height - tab_height)
        backgroundEmptyView.backgroundColor = UIColor.white
        self.view.addSubview(backgroundEmptyView)
        
        
        let imageView = UIImageView(image: UIImage(named: "gouwuc"))
        imageView.frame = CGRect(x: 10, y: app_height/3 - nav_height - tab_height, width: app_width - 20, height: app_width * 0.2)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundEmptyView.addSubview(imageView)
        
        
        let label = UILabel()
        method.creatLabel(lab: label, x: 0, y: imageView.bottomPosition(), wid: app_width, hei: 40, textString: "辛苦忙碌一天，还是买买买最开心～", textcolor: UIColor.gray, textFont: 14, superView: backgroundEmptyView)
        label.textAlignment = .center
        
        let gotoBuy = UIButton()
        method.creatButton(btn: gotoBuy, x: app_width/3, y: label.bottomPosition(), wid: app_width/3, hei: app_width/10, title: "去逛逛", titlecolor: UIColor.white, titleFont: 14, bgColor: MyAppColor(), superView: backgroundEmptyView)
//        gotoBuy.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        gotoBuy.layer.cornerRadius = gotoBuy.frame.height/2
        gotoBuy.addTarget(self, action: #selector(gotoBuyClick), for: .touchUpInside)
//        先隐藏
        self.backgroundEmptyView.isHidden = true
    }
    func gotoBuyClick(){
        self.tabBarController?.selectedIndex=0
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadCarData()
    }
    override func viewDidAppear(_ animated: Bool) {
        if !method.isLogin(){
            
            let vc = LoginAppViewController()
            vc.buycarCome = true
            self.present(vc, animated: true, completion: {
                self.clearAllNotice()
                self.tabBarController?.selectedIndex=0
            })
//            self.present(vc, animated: true, completion: nil)
            
        }
    }

    func reloadCarData(){
        HttpTool.shareHttpTool.Http_GetCarGoods { (data) in
            print(data)
            self.selectArray = []
            self.dataArray = []
            for item in data["detailsList"].arrayValue{
                let model = LZCartModel()
                model.detailsID = item["detailsID"].intValue
                model.goodsId   = item["commodityID"].stringValue
                model.name      = item["commodityName"].stringValue
                model.price     = item["commodityCouponPrice"].doubleValue.getMoney()
                model.number    = item["num"].intValue
                model.detail    = item["norm"].stringValue
                model.oldprice  = item["commoditySettlePrice"].doubleValue.getMoney()
                model.image     = item["commodityImg"].stringValue
                self.dataArray.append(model)
            }
            if data["detailsList"].arrayValue.count == 0{
                DispatchQueue.main.async {
                    self.backgroundEmptyView.isHidden = false
                }
            }else{
                DispatchQueue.main.async {
                    self.backgroundEmptyView.isHidden = true
                }
            }
            DispatchQueue.main.async {
                self.allSelectButton?.isSelected = false
                let name = data["storeName"].stringValue
                //上下班
                self.shopOpen = data["storeStatus"].stringValue == "1" ? true:false
                let status = data["storeStatus"].stringValue == "1" ? "(上班)":"(下班)"
                let attStr = NSMutableAttributedString(string: name + status)
                let range = ((name + status) as NSString).range(of: status)
//                let range = NSMakeRange(2, 4)
                attStr.addAttributes([NSForegroundColorAttributeName:MyAppColor()], range: range)
                
                self.storeNameStr = attStr
                
                self.tableView?.reloadData()
                self.priceCount()
            }
        }
    }
    
    func postAddressInfo(address:JSON){
        self.addressInfo = address
    }
}
extension LZCartViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(indexPath.row)
        if indexPath == IndexPath(row: 0, section: 0){
            //去地址选择
            let vc = AddressViewController()
            vc.isChoseAddress = true
            vc.delegate = self
            self.pushToNext(vc: vc)
        }
        if indexPath.section == 1{
            print("11111")
            let vc = GoodsDetailViewController()
            vc.goodsId = self.dataArray[indexPath.row].goodsId!
            self.pushToNext(vc: vc)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 40 : 100
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 30 : 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func turnToShopInfo(){
//        print("11")
        let vc = StoreInfomationViewController()
        self.pushToNext(vc: vc)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()//height = 30
        let tap = UITapGestureRecognizer(target: self, action: #selector(turnToShopInfo))
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor.white
        storeName.isUserInteractionEnabled = true
        
//        storeName.frame = CGRect(x: 15, y: 0, width: 200, height: 30)
//        storeName.textColor = UIColor.black
//        storeName.font = UIFont.systemFont(ofSize: 12)
//        view.addSubview(storeName)
        DispatchQueue.main.async {
            self.storeName.attributedText = self.storeNameStr
        }
        
        method.creatLabel(lab: storeName, x: 15, y: 0, wid: 200, hei: 30, textString: "", textcolor: UIColor.black, textFont: 12, superView: view)
        
        let img = UIImageView()
        method.creatImage(img: img, x: app_width - 35, y: 0, wid: 30, hei: 30, imgName: "kebianjijiantou", imgMode: .center, superView: view)
        
        method.drawLine(startX: 15, startY: 30, wid: app_width - 15, hei: 0.6, add: view)
        return view
    }
    
    /*tableView 代理方法 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            //收获地址、
            let addressLab = UILabel()
            method.creatLabel(lab: addressLab, x: 15, y: 0, wid: app_width - 50, hei: 40, textString: "添加收货地址", textcolor: UIColor.black, textFont: 12, superView: cell.contentView)
            if self.addressInfo != nil{
                addressLab.text = self.addressInfo!["address"].stringValue + self.addressInfo!["addressInfo"].stringValue
            }
            return cell
        }else{
            //  商品信息
            var cell: LZCartTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cartCellID") as? LZCartTableViewCell
            if cell == nil {
                cell = LZCartTableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "cartCellID")
            }
            cell?.addAndCut.isHidden = isEdit
            
            let model = dataArray[(indexPath as NSIndexPath).row]
            
            cell?.configCellDateWithModel(model)
            
            /*点击cell数量加按钮回调*/
            cell?.addNumber({number in
                
                model.number = number
                self.priceCount()
//                print("aaa\(model.select)")
            })
            
            /*点击cell数量减按钮回调*/
            cell?.cutNumber({number in
                
                model.number = number
                self.priceCount()
//                print("bbbbb\(number)")
            })
            
            /*选择cell商品回调*/
            cell?.selectAction({select in
                
                model.select = select
                
                if select {
                    self.selectArray.append(model)
                } else {
                    
                    let index = self.selectArray.index(of: model)
                    self.selectArray.remove(at: index!)
                }
                
                if self.selectArray.count == self.dataArray.count {
                    
                    self.allSelectButton?.isSelected = true
                } else {
                    self.allSelectButton?.isSelected = false
                }
                
                self.priceCount()
                
                print("select\(select)")
            })
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "提示",message: "删除后无法恢复,是否继续删除?",preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "确定",style: UIAlertActionStyle.default,handler:{okAction in
            
            let goodsId = self.dataArray[indexPath.row].detailsID
            
            self.deleteGoodsById(id: "\(goodsId!)")
//            let model = self.dataArray.remove(at: (indexPath as NSIndexPath).row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//            
//            if self.selectArray.contains(model) {
//                
//                let index = self.selectArray.index(of: model)
//                self.selectArray.remove(at: index!)
//                
//                self.priceCount()
//            }
//            
//            if self.selectArray.count == self.dataArray.count {
//                
//                self.allSelectButton?.isSelected = true
//            } else {
//                self.allSelectButton?.isSelected = false
//            }
//            
//            if self.dataArray.count == 0 {
//                self.allSelectButton?.isSelected = false
//                self.emptyView()
//            }
        })
        
        let cancel = UIAlertAction(title: "取消",style: UIAlertActionStyle.cancel,handler: {cancelAction in
            
            
        })
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除"
    }
}
