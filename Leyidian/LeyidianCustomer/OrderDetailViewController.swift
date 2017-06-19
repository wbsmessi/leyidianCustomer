//
//  OrderDetailViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/24.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var orderId:String!
    var orderInfo:JSON!
    var bgView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    func loadData(){
        HttpTool.shareHttpTool.Http_OrderDetail(orderID: orderId) { (data) in
            print(data)
            self.orderInfo = data
            self.orderStatusInfo = data["recordList"].arrayValue
            DispatchQueue.main.async {
                if self.bgView != nil{
                    self.bgView!.removeFromSuperview()
                }
                self.creatView()
            }
        }
    }
    //订单状态
    var statusView:orderStatusView?
    var orderStatusInfo:[JSON] = []
    func orderStatusViewHide(hide:Bool){
        if statusView == nil{
            statusView = orderStatusView(frame: CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height - 40))
            statusView!.orderNo = self.orderInfo["order"]["orderNo"].stringValue
            statusView!.arriveTime = self.orderInfo["order"]["predictTime"].doubleValue
            statusView!.infoArr = self.orderStatusInfo
            self.view.addSubview(statusView!)
        }
        statusView!.isHidden = hide
    }
    func segmentValueChanged(segment:UISegmentedControl){
        print(segment.selectedSegmentIndex)
        orderStatusViewHide(hide: segment.selectedSegmentIndex == 1 ? true:false)
    }
    var orderTable:UITableView!
    func creatView(){
        let orderStatusStr = orderInfo["order"]["orderStatus"].stringValue
        if (orderStatusStr == orderTypeEnum.refundFaild.rawValue || orderStatusStr == orderTypeEnum.refund.rawValue || orderStatusStr == orderTypeEnum.refunded.rawValue){
            //订单详情
            let titleLab = UILabel()
            method.creatLabel(lab: titleLab, x: app_width/2 - 75, y: 20, wid: 150, hei: 44, textString: "订单详情", textcolor: setMyColor(r: 51, g: 51, b: 51, a: 1), textFont: 18, superView: self.view)
            titleLab.textAlignment = .center
        }else{
            let segment = UISegmentedControl(items: ["订单状态","订单详情"])
            segment.frame = CGRect(x: app_width/2 - 75, y: 30, width: 150, height: 28)
            segment.selectedSegmentIndex = 1
            segment.tintColor = MyAppColor()
            segment.setTitleTextAttributes([NSForegroundColorAttributeName:myAppBlackColor()], for: .normal)
            segment.addTarget(self, action: #selector(segmentValueChanged(segment:)), for: .valueChanged)
            self.view.addSubview(segment)
        }
        
        
        bgView = UIView()
        bgView!.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height)
        bgView!.backgroundColor = MyGlobalColor()
        self.view.addSubview(bgView!)
        
        orderTable = UITableView()
        orderTable.frame = CGRect(x: 0, y: 0, width: app_width, height: bgView!.frame.height - 41)
        orderTable.delegate = self
        orderTable.dataSource = self
        orderTable.tableFooterView = UIView()
//        orderTable.allowsSelection = false
        orderTable.backgroundColor = MyGlobalColor()
        orderTable.showsVerticalScrollIndicator = false
        bgView!.addSubview(orderTable)
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: orderTable.bottomPosition()+1, width: app_height - 40, height: 40)
        bottomView.backgroundColor = UIColor.white
        bgView!.addSubview(bottomView)
        
//        method.drawLine(startX: 0, startY: 0, wid: app_width, hei: 1, add: bottomView)
        
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: app_width - 80, y: 5, wid: 70, hei: 30, title: "", titlecolor: MyAppColor(), titleFont: 12, bgColor: UIColor.white, superView: bottomView)
        rightBtn.layer.borderColor = MyAppColor().cgColor
        rightBtn.layer.borderWidth = 0.6
        rightBtn.layer.cornerRadius = 5
        
        let centerBtn = UIButton()
        method.creatButton(btn: centerBtn, x: app_width - 160, y: 5, wid: 70, hei: 30, title: "", titlecolor: MyAppColor(), titleFont: 12, bgColor: UIColor.white, superView: bottomView)
        centerBtn.layer.borderColor = MyAppColor().cgColor
        centerBtn.layer.borderWidth = 0.6
        centerBtn.layer.cornerRadius = 5
        centerBtn.isHidden = true
        let leftBtn = UIButton()
        method.creatButton(btn: leftBtn, x: app_width - 240, y: 5, wid: 70, hei: 30, title: "", titlecolor: MyAppColor(), titleFont: 12, bgColor: UIColor.white, superView: bottomView)
        leftBtn.layer.borderColor = MyAppColor().cgColor
        leftBtn.layer.borderWidth = 0.6
        leftBtn.layer.cornerRadius = 5
        leftBtn.isHidden = true
        
        let shareOrderBtn = UIButton()
        method.creatButton(btn: shareOrderBtn, x: 20, y: app_height - 50, wid: 50, hei: 50, title: "", titlecolor: UIColor.clear, titleFont: 0, bgColor: UIColor.clear, superView: self.view)
        shareOrderBtn.setBackgroundImage(UIImage(named:"shareoder"), for: .normal)
        shareOrderBtn.addTarget(self, action: #selector(shareOrderBtnClick), for: .touchUpInside)
        shareOrderBtn.imageView?.contentMode = .scaleAspectFit
        shareOrderBtn.isHidden = true
        
//        case waitPay        = "0"//待付款
//        case paid           = "1"//待收货
//        case send           = "2"//已发货
//        case waitEnv        = "3"//待评价 已签收
//        case finish         = "4"//已完成
//        case cancle         = "5"//已取消
//        case arrived        = "6"//已送达
//        case refund         = "9"//退款中
//        case refunded       = "7"//已退款
//        case refundFaild    = "10"//退款失败
//        case allOrder       = "100"//
        switch orderStatusStr {
        case orderTypeEnum.waitPay.rawValue:
            //            return "待支付"
            rightBtn.setTitle("立即支付", for: .normal)
            rightBtn.addTarget(self, action: #selector(topayOrder), for: .touchUpInside)
            centerBtn.setTitle("取消订单", for: .normal)
            centerBtn.addTarget(self, action: #selector(cancleOrder), for: .touchUpInside)
            centerBtn.isHidden = false
        case orderTypeEnum.paid.rawValue:
            //return "已付款"
            rightBtn.setTitle("取消订单", for: .normal)
            rightBtn.addTarget(self, action: #selector(cancleOrder), for: .touchUpInside)
        case orderTypeEnum.send.rawValue:
            //            return "待签收"
            rightBtn.setTitle("立即签收", for: .normal)
            rightBtn.addTarget(self, action: #selector(receiptOrder), for: .touchUpInside)
            centerBtn.setTitle("联系快递", for: .normal)
            centerBtn.addTarget(self, action: #selector(connectCustomer), for: .touchUpInside)
            centerBtn.isHidden = true
        case orderTypeEnum.arrived.rawValue:
            //            return "待签收"
            rightBtn.setTitle("立即签收", for: .normal)
            rightBtn.addTarget(self, action: #selector(receiptOrder), for: .touchUpInside)
            centerBtn.setTitle("联系快递", for: .normal)
            centerBtn.addTarget(self, action: #selector(connectCustomer), for: .touchUpInside)
            centerBtn.isHidden = true
        case orderTypeEnum.waitEnv.rawValue:
            //return "待评价"
            if TICKET_SHEAR_LIMIT <= orderInfo["order"]["orderFee"].doubleValue{
                shareOrderBtn.isHidden = false
            }
            
            rightBtn.setTitle("评价送积分", for: .normal)
            rightBtn.addTarget(self, action: #selector(toEvaluation), for: .touchUpInside)
//        case "4":
//            //            return "待评价"
//            rightBtn.setTitle("删除订单", for: .normal)
//            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
//        case "5":
//            rightBtn.setTitle("删除订单", for: .normal)
//            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
        case orderTypeEnum.arrived.rawValue:
            rightBtn.setTitle("立即签收", for: .normal)
            rightBtn.addTarget(self, action: #selector(receiptOrder), for: .touchUpInside)
            centerBtn.setTitle("联系快递", for: .normal)
            centerBtn.addTarget(self, action: #selector(connectCustomer), for: .touchUpInside)
            centerBtn.isHidden = false
        default:
            rightBtn.setTitle("删除订单", for: .normal)
            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
        }
        
        
    }
    
    func shareOrderBtnClick(){
        UMSocialUIManager.showShareMenuViewInWindow(platformSelectionBlock: { (platformType, userInfo) in
            UMSocialSwiftInterface().shareOrderToPlatformType(orderNo: self.orderInfo["order"]["orderNo"].stringValue, platformType: platformType, vc: self)
        })
    }
    
    func connectCustomer(){
        method.callTelphone(phoneNo: orderInfo["order"]["phone"].stringValue)
    }
    //支付订单
    func topayOrder(){
        
        let vc = PayWayChoseViewController()
        vc.payMoney = orderInfo["order"]["orderFee"].doubleValue.getMoney()
        vc.orderNo = orderInfo["order"]["orderNo"].stringValue
        self.pushToNext(vc: vc)
    }
    //删除订单
    func deleteOrder(){
        HttpTool.shareHttpTool.Http_DeleteOrder(orderID: orderInfo["order"]["orderID"].stringValue) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "删除成功")
                self.backPage()
            }else{
                self.myNoticeError(title: data["msg"].stringValue)
            }
        }
    }
    //取消订单
    func cancleOrder(){
        let vc = CancleReasonViewController()
        vc.orderNo = orderInfo["order"]["orderNo"].stringValue
        self.pushToNext(vc: vc)
    }
    //    签收订单
    func receiptOrder(index:Int){
        let orderID = orderInfo["order"]["orderID"].stringValue
        HttpTool.shareHttpTool.Http_Receipt(orderID: orderID) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "订单签收成功")
                self.backPage()
            }else{
                self.myNoticeError(title: data["msg"].stringValue)
            }
        }
    }
    //立即评价
    func toEvaluation(){
        let vc = EvaluationViewController()
//        orderInfo["order"]
        vc.orderInfo = orderInfo["order"]
        self.pushToNext(vc: vc)
    }
    func postDeliveryInfo(info:JSON){
//        let deliveryID = info["deliveryID"].stringValue
//        HttpTool.shareHttpTool.Http_deliveryOrder(orderNo: orderInfo["order"]["orderNo"].stringValue, deliveryID: deliveryID) { (data) in
//            print(data)
//            if data["code"].stringValue == "SUCCESS"{
//                self.myNoticeSuccess(title: "配送成功")
//                self.backPage()
//            }else{
//                self.myNoticeError(title: data["msg"].stringValue)
//            }
//        }
    }
    func getOrderStatusTitle(status:String)->String{
        //        case waitSend           = "1"
        //        case waitArrive         = "2"
        //        case waiSure            = "6"
        //        case finished           = "4"
        //        case cancle             = "5"
        switch status {
        case "1":
            return "待配送"
        case "2":
            return "待送达"
        case "4":
            return "已完成"
        case "5":
            return "已取消"
        case "6":
            return "待确认"
        default:
            return "未知"
        }
    }
    func creatItem(title:String,value:String,Y:CGFloat,item_height:CGFloat,superView:UIView,needAppcolor:Bool){
        let titleLab = UILabel()
        method.creatLabel(lab: titleLab, x: 15, y: Y, wid: app_width/3, hei: item_height, textString: title, textcolor: myAppGryaColor(), textFont: 12, superView: superView)
        
        let valueLab = UILabel()
        method.creatLabel(lab: valueLab, x: titleLab.rightPosition(), y: Y, wid: app_width * 2/3 - 30, hei: item_height, textString: value, textcolor: myAppBlackColor(), textFont: 12, superView: superView)
        valueLab.textAlignment = .right
        if needAppcolor {
            valueLab.textColor = MyMoneyColor()
        }
//        if title == "订单总收入"{
//            valueLab.textColor = MyAppColor()
//        }
    }
    func getCancleType(type:String)->String{
        switch type {
        case "U":
            return "用户取消"
            //后台吧P和S写反了，将错就错
        case "P":
            return "商家取消"
        case "S":
            return "平台取消"
        default:
            return "用户取消"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension OrderDetailViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            let statusStr = self.orderInfo["order"]["orderStatus"].stringValue
            if  (statusStr == orderTypeEnum.waitEnv.rawValue || statusStr == orderTypeEnum.send.rawValue || statusStr == orderTypeEnum.arrived.rawValue || statusStr == orderTypeEnum.finish.rawValue || statusStr == orderTypeEnum.cancle.rawValue || statusStr == orderTypeEnum.refund.rawValue || statusStr == orderTypeEnum.refunded.rawValue || statusStr == orderTypeEnum.refundFaild.rawValue){
                return 1
            }else{
                return 0
            }
        case 4:
            return 1
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 35
        case 1:
            return indexPath.row == 0 ? 60:35
        case 2:
            return 140
        case 3:
            return 110
        case 4:
            return 220
        default:
            return 70
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            let icon = UIImageView()
            method.creatImage(img: icon, x: 15, y: 10, wid: 15, hei: 15, imgName: "dingdanzhuangtai", imgMode: .scaleAspectFit, superView: cell.contentView)
            let title = UILabel()
            method.creatLabel(lab: title, x: icon.rightPosition() + 5, y: 0, wid: 100, hei: 35, textString: "订单状态", textcolor: myAppBlackColor(), textFont: 12, superView: cell.contentView)
            
            let status = UILabel()
            status.textAlignment = .right
            let orderType = method.statusConvert(status: orderInfo["order"]["orderStatus"].stringValue)
            method.creatLabel(lab: status, x: app_width - 120, y: 0, wid: 100, hei: 35, textString: method.getStatusName(type: orderType), textcolor: MyAppColor(), textFont: 12, superView: cell.contentView)
            return cell
        case 1:
            if indexPath.row == 0{
                let cell = AddressTableViewCell()
                cell.addressRemark = "" //不显示备注，就直接改为空
                cell.addresslab.textColor = UIColor.black
                cell.addressStr = orderInfo["order"]["address"].stringValue
                //这个地方和收获地址不一样，是先显示名字
                cell.phoneAndNameStr = orderInfo["order"]["nickName"].stringValue + "       " + orderInfo["order"]["phone"].stringValue
                cell.deleteBtn.isHidden = true //删除按钮隐藏
                return cell
            }else{
                let cell = UITableViewCell()
                let title = UILabel()
                method.creatLabel(lab: title, x: 15, y: 0, wid: 100, hei: 35, textString: "预计送达时间", textcolor: myAppBlackColor(), textFont: 12, superView: cell.contentView)
                
                let time = UILabel()
                method.creatLabel(lab: time, x: 120, y: 0, wid: app_width - 135, hei: 35, textString: method.convertTime(time: orderInfo["order"]["predictTime"].doubleValue), textcolor: myAppBlackColor(), textFont: 12, superView: cell.contentView)
                time.textAlignment = .right
                return cell
            }
            
        case 2:
            let cell = OrderDetailGoodsInfoTableViewCell()
            //确定cell的类型.需要具体到某一个订单的类型
            //加载商品信息
            cell.creatViewWithGoods(Goods: orderInfo["order"]["details"].arrayValue)
            return cell
        case 3:
            let cell = UITableViewCell()
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: 200, hei: 30, textString: "配送员信息", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            method.drawLine(startX: 15, startY: 30, wid: app_width - 15, hei: 0.6, add: cell.contentView)
            
            var height:CGFloat = 70/2
             //reason
            let statusStr = self.orderInfo["order"]["orderStatus"].stringValue
            if  statusStr == orderTypeEnum.cancle.rawValue{
//                 || statusStr == orderTypeEnum.refund.rawValue || statusStr == orderTypeEnum.refunded.rawValue || statusStr == orderTypeEnum.refundFaild.rawValue
                lab.text = "取消原因"
                height = 70/3
                creatItem(title: "取消方", value: self.getCancleType(type: orderInfo["order"]["cancelType"].stringValue), Y: 35, item_height: height, superView: cell.contentView, needAppcolor:false)
                creatItem(title: "取消原因", value: orderInfo["order"]["cancelCause"].stringValue, Y: 35+height, item_height: height, superView: cell.contentView, needAppcolor:false)
                creatItem(title: "联系电话", value: orderInfo["order"]["cancelPhone"].stringValue, Y: 35 + 2 * height, item_height: height, superView: cell.contentView, needAppcolor:false)
            }else if (statusStr == orderTypeEnum.waitEnv.rawValue || statusStr == orderTypeEnum.send.rawValue || statusStr == orderTypeEnum.arrived.rawValue || statusStr == orderTypeEnum.finish.rawValue) {
                creatItem(title: "配送员", value: orderInfo["order"]["deliveryPerson"].stringValue, Y: 35, item_height: height, superView: cell.contentView, needAppcolor:false)
                creatItem(title: "联系电话", value: orderInfo["order"]["deliveryPhone"].stringValue, Y: 35+height, item_height: height, superView: cell.contentView, needAppcolor:false)
            }else if (statusStr == orderTypeEnum.refund.rawValue || statusStr == orderTypeEnum.refundFaild.rawValue || statusStr == orderTypeEnum.refunded.rawValue){
                lab.text = "退款信息"
                height = 70/3 //70 = 80 - 5 - 5
                
                creatItem(title: "申请时间", value: method.convertTime(time: orderInfo["order"]["refoundDate"].doubleValue), Y: 35, item_height: height, superView: cell.contentView, needAppcolor:false)
                creatItem(title: "申请原因", value: self.getCancleType(type: orderInfo["order"]["cancelType"].stringValue), Y: 35+height, item_height: height, superView: cell.contentView, needAppcolor:false)
                
                let lab = UILabel()
                method.creatLabel(lab: lab, x: 15, y: 30 + 2 * height, wid: app_width - 30, hei: height, textString: "退款成功后，平台将在2-5个工作日返回到你支付的账户中", textcolor: MyAppColor(), textFont: 10, superView: cell.contentView)
            }
            
            return cell
        case 4:
            let cell = UITableViewCell()
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: 200, hei: 30, textString: "订单详情", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            method.drawLine(startX: 15, startY: 30, wid: app_width - 15, hei: 0.6, add: cell.contentView)
            
            let height:CGFloat = 180/7  //180 = 190 - 5 - 5
            creatItem(title: "订单号", value: orderInfo["order"]["orderNo"].stringValue, Y: 35, item_height: height, superView: cell.contentView, needAppcolor:false)
            creatItem(title: "下单时间", value: method.convertTime(time: orderInfo["order"]["createDate"].doubleValue), Y: 35+height, item_height: height, superView: cell.contentView, needAppcolor:false)
            creatItem(title: "商品原价", value: "¥"+orderInfo["order"]["totalFee"].doubleValue.getMoney(), Y: 35+2*height, item_height: height, superView: cell.contentView, needAppcolor:false)
            
            let yiyouhuiMon = (orderInfo["order"]["totalFee"].doubleValue - orderInfo["order"]["orderFee"].doubleValue + orderInfo["order"]["courierFee"].doubleValue).getMoney()
            creatItem(title: "商品已优惠金额", value: "-¥"+yiyouhuiMon, Y: 35+3*height, item_height: height, superView: cell.contentView, needAppcolor:true)
            creatItem(title: "配送费", value: "¥"+orderInfo["order"]["courierFee"].doubleValue.getMoney(), Y: 35+4*height, item_height: height, superView: cell.contentView, needAppcolor:false)
            creatItem(title: "优惠券抵扣", value: "-¥"+orderInfo["order"]["ticketFee"].doubleValue.getMoney(), Y: 35+5*height, item_height: height, superView: cell.contentView, needAppcolor:false)
            creatItem(title: "实付金额", value: "¥"+orderInfo["order"]["orderFee"].doubleValue.getMoney(), Y: 35+6*height, item_height: height, superView: cell.contentView, needAppcolor:true)
            return cell
        default:
            let cell = UITableViewCell()
            cell.separatorInset = UIEdgeInsetsMake(0, app_width, 0, 0) // 指的是手机屏幕的宽度
            cell.contentView.backgroundColor = UIColor.white
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: app_width - 30, hei: 60, textString: "备注："+orderInfo["order"]["remark"].stringValue, textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            lab.backgroundColor = UIColor.white
            lab.numberOfLines = 2
            lab.lineBreakMode = .byCharWrapping
            
            let labcolor = UILabel()
            method.creatLabel(lab: labcolor, x: 0, y: lab.bottomPosition(), wid: app_width, hei: 10, textString: "", textcolor: UIColor.clear, textFont: 0, superView: cell.contentView)
            labcolor.backgroundColor = MyGlobalColor()
            
            return cell
            
        }
        //        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        if indexPath.section == 2{
            let vc = GoodsListViewController()
            vc.goodsInfo = orderInfo["order"]["details"].arrayValue
            self.pushToNext(vc: vc)
        }
    }
}
