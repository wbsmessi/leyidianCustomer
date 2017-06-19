//
//  PrePayOrderViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class PrePayOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CouponTicketChoseDelegate {

    var method = Methods()
    var orderInfo:[LZCartModel] = []{
        didSet{
            for i in 0..<orderInfo.count{
                
                let item:LZCartModel = orderInfo[i]
                let goodsStr = "{\"discountPrice\":\"\(item.price!)\",\"commodityName\":\"\(item.name!)\",\"detailsID\":\"\(item.detailsID!)\",\"norm\":\"\(item.detail!)\",\"price\":\"\(item.price!)\",\"commodityID\":\"\(item.goodsId!)\",\"num\":\"\(item.number)\",\"commodityImg\":\"\(item.image!)\"}"
                let data = (goodsStr).data(using: .utf8)
                do{
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    let dic = JSON(jsonDic)
                    self.orderInfoJSON.append(dic)
                }catch{
                }
                
            }
            print(orderInfoJSON)
        }
    }
    var orderInfoJSON:[JSON] = []
    //是否含有收获地址
    var addressInfo:JSON!
    var couponInfo:[JSON] = []
    var cartID:String!
    var detailsIDs:[Int]!
    
    var totalMoney:Double = 0.0{
        didSet{
            DispatchQueue.main.async {
                self.payMoneyLab?.text = "¥"+self.totalMoney.getMoney()
            }
        }
    }
    //优惠券可抵扣金额
    var couponWorth:Double = 0.0
    //已优惠金额
    var couponMoney:Double = 0.0
    //商品原价总价格
    var goodsOldMoney:Double = 0.0
//    已选择的优惠券信息
    var chosedCouponInfo:JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.goodsOldMoney = self.couponMoney + self.totalMoney
        
        self.setTitleView(title: "订单确认", canBack: true)
        creatView()
        //计算配送费
        if let peisong = Double(storeInfomation!.deliveryFee){
            print(Double(storeInfomation!.freeLimit))
            if Double(storeInfomation!.freeLimit) > totalMoney{
                totalMoney += peisong
            }else{
                self.totalMoney += 0.0
            }
        }
    }
    //商家留言
    let messageText = UITextView()
    var payMoneyLab:UILabel?
    func creatView(){
        
        let table = UITableView()
        table.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height - 40)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        self.view.addSubview(table)
        table.backgroundColor = MyGlobalColor()
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: table.bottomPosition(), width: app_width, height: 40)
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        let shifujine = UILabel()
        method.creatLabel(lab: shifujine, x: 20, y: 0, wid: 80, hei: 40, textString: "实付金额:", textcolor: UIColor.black, textFont: 14, superView: bottomView)
        
        
        
        let payMoney = UILabel()
        method.creatLabel(lab: payMoney, x: shifujine.rightPosition(), y: 0, wid: app_width - shifujine.rightPosition() - 100, hei: 40, textString: "", textcolor: MyMoneyColor(), textFont: 14, superView: bottomView)
        self.payMoneyLab = payMoney
        
        let toPayBtn = UIButton()
        method.creatButton(btn: toPayBtn, x: app_width - 100, y: 0, wid: 100, hei: 40, title: "确认支付", titlecolor: UIColor.white, titleFont: 14, bgColor: MyAppColor(), superView: bottomView)
        toPayBtn.addTarget(self, action: #selector(toPayBtnClick), for: .touchUpInside)
        
//        method.drawLineWithColor(startX: 0, startY: 0, wid: app_width, hei: 1.6, lineColor: setMyColor(r: 238, g: 238, b: 238, a: 1), add: bottomView)
//        method.drawLine(startX: 0, startY: 0, wid: app_width, hei: 0.6, add: bottomView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return indexPath.row == 0 ? 60 : 35
            case 1:
                return 140
            case 2:
                return indexPath.row == 0 ? 100:35
            default:
                return 100
        }
    }
    var titleArr = ["收货人","手机号码","收货地址","详细地址","预计送达时间"]
//    可使用的优惠券数量
    let canUserCouponCount = UILabel()
    //优惠券选择情况
    let conponStatus = UILabel()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                let cell = AddressTableViewCell()
                cell.addressRemark = "" //不显示备注，就直接改为空
                cell.addresslab.textColor = UIColor.black
                //这个地方和收获地址不一样，是先显示名字
                cell.addresslab.text = addressInfo["address"].stringValue + addressInfo["addressInfo"].stringValue
                cell.phoneAndNameStr = addressInfo["contactParson"].stringValue + "       " + addressInfo["phone"].stringValue
                cell.deleteBtn.isHidden = true //删除按钮隐藏
                return cell
            }else{
                let cell = UITableViewCell()
                let title = UILabel()
                method.creatLabel(lab: title, x: 15, y: 0, wid: 80, hei: 35, textString: "预计送达时间", textcolor: UIColor.black, textFont: 12, superView: cell.contentView)
//                预计送达时间
//                3600为模拟送货时间一个小时，到时候加上服务端饭回来的送达时间
                let timeStr = method.convertTime(time: Double(method.getNowTimeStamp() + 3600)*1000)
                
                let titleTime = UILabel()
                titleTime.textAlignment = .right
                method.creatLabel(lab: titleTime, x: app_width - 200, y: 0, wid: 185, hei: 35, textString: timeStr, textcolor: UIColor.black, textFont: 12, superView: cell.contentView)
                return cell
            }
        case 1:
            //商品信息
            let cell = OrderDetailGoodsInfoTableViewCell()
            cell.creatViewWithGoods(Goods: orderInfoJSON)
            return cell
        case 2:
            let cell = UITableViewCell()
            if indexPath.row == 0{
                
                let itemView1 = ItemInfoView(frame: CGRect(x: 15, y: 5, width: app_width - 30, height: 30), title: "商品原价", info: "¥"+goodsOldMoney.getMoney(), infoColor: UIColor.gray)
                cell.contentView.addSubview(itemView1)
                
                let itemView2 = ItemInfoView(frame: CGRect(x: 15, y: itemView1.bottomPosition(), width: app_width - 30, height: itemView1.frame.height), title: "商品已优惠", info: "-¥" + couponMoney.getMoney(), infoColor: MyMoneyColor())
                cell.contentView.addSubview(itemView2)
                
                //计算配送费
                var deliveryFeeMon = "0"
                if let peisong = Double(storeInfomation!.deliveryFee){
                    print(Double(storeInfomation!.freeLimit))
                    if Double(storeInfomation!.freeLimit) > totalMoney{
                        deliveryFeeMon = "\(peisong)"
                    }
                }
                let itemView3 = ItemInfoView(frame: CGRect(x: 15, y: itemView2.bottomPosition(), width: app_width - 30, height: itemView1.frame.height), title: "配送费", info: "¥" + deliveryFeeMon, infoColor: UIColor.gray)
                cell.contentView.addSubview(itemView3)
            }else{
                
                cell.accessoryType = .disclosureIndicator
                let title = UILabel()
                method.creatLabel(lab: title, x: 15, y: 0, wid: 60, hei: 35, textString: "优惠券", textcolor: myAppBlackColor(), textFont: 14, superView: cell.contentView)
                
                
                method.creatLabel(lab: canUserCouponCount, x: title.rightPosition(), y: 0, wid: 100, hei: 35, textString: "(0张可用)", textcolor: MyAppColor(), textFont: 12, superView: cell.contentView)
                
                
                conponStatus.textAlignment = .right
                method.creatLabel(lab: conponStatus, x: app_width - 150, y: 0, wid: 120, hei: 35, textString: "未使用", textcolor: UIColor.gray, textFont: 10, superView: cell.contentView)
            }
            return cell
        default:
            let cell = UITableViewCell()
            //去掉cell的行横线
            cell.separatorInset = UIEdgeInsetsMake(0, app_width, 0, 0)
            let title = UILabel()
            method.creatLabel(lab: title, x: 15, y: 5, wid: 100, hei: 15, textString: "给商家留言：", textcolor: UIColor.gray, textFont: 11, superView: cell.contentView)
            
            messageText.frame = CGRect(x: 15, y: 20, width: app_width - 30, height: 80)
            messageText.font = UIFont.systemFont(ofSize: 11)
            messageText.textColor = UIColor.gray
            messageText.delegate = self
            messageText.returnKeyType = .done
            cell.contentView.addSubview(messageText)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1{
            let vc = GoodsListViewController()
            //商品详情列表
            vc.goodsInfo = orderInfoJSON
            self.pushToNext(vc: vc)
        }
        
        if indexPath == IndexPath(row: 1, section: 2) {
            if self.couponInfo.count != 0{
                //如果要重新选择优惠券，则价格还原
                self.totalMoney += self.couponWorth
                //清楚原来的选择
                DispatchQueue.main.async {
                    self.conponStatus.text = "未使用"
                }
                let vc = CouponViewController()
                vc.delegate = self
                vc.isCouponTicketChose = true
                vc.initChoseView(couponData: self.couponInfo)
                self.pushToNext(vc: vc)
            }else{
                self.myNoticeError(title: "(无可用优惠券)")
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
//        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
//            //在这里做你响应return键的代码
//            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
//        }
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    func CouponTicketChose(couponInfo:JSON){
        self.chosedCouponInfo = couponInfo
        DispatchQueue.main.async {
            self.conponStatus.text = couponInfo["ticketInstName"].stringValue
        }
        self.couponWorth = couponInfo["worth"].doubleValue
        let mon = self.totalMoney - couponInfo["worth"].doubleValue
        //如果付款金额小于0，则置为0元
        if mon < 0{
            self.totalMoney = 0.0
        }else{
            self.totalMoney -= couponInfo["worth"].doubleValue
        }
    }
    //
    func toPayBtnClick(){
        var ticketId = ""
        if let coupon = self.chosedCouponInfo{
            ticketId = coupon["ticketInstID"].stringValue
        }
        HttpTool.shareHttpTool.Http_CreateOrder(detailsIDs: detailsIDs, addressID: self.addressInfo!["addressID"].stringValue, cartID: cartID, ticketID: ticketId, remark: messageText.text ?? "") { (data)  in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                if data["resultData"]["paySuccess"].stringValue == "SUCCESS"{
                    //当价格为0时，服务端直接支付成功，
                    self.pushToNext(vc: PaySuccessViewController())
                }else{
                    let vc = PayWayChoseViewController()
                    vc.payMoney = self.totalMoney.getMoney()
                    vc.orderNo = data["resultData"]["orderNo"].stringValue
                    DispatchQueue.main.async {
                        self.pushToNext(vc: vc)
                    }
                }
            }else{
                self.myNoticeError(title: "下单失败！")
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        HttpTool.shareHttpTool.Http_canChoseCoupon(amount: totalMoney) { (data) in
            print(data)
            DispatchQueue.main.async {
                self.canUserCouponCount.text = "(\(data.arrayValue.count)张可用)"
            }
            self.couponInfo = data.arrayValue
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
