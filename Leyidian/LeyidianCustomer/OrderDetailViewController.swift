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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "订单详情", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        loadData()
    }
    func loadData(){
        HttpTool.shareHttpTool.Http_OrderDetail(orderID: orderId) { (data) in
            print(data)
            self.orderInfo = data
            DispatchQueue.main.async {
                self.creatView()
            }
        }
    }
    var orderTable:UITableView!
    func creatView(){
        orderTable = UITableView()
        orderTable.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height - 50)
        orderTable.delegate = self
        orderTable.dataSource = self
        orderTable.tableFooterView = UIView()
//        orderTable.allowsSelection = false
        self.view.addSubview(orderTable)
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: orderTable.bottomPosition() + 10, width: app_height - 40, height: 40)
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: app_width - 70, y: 5, wid: 60, hei: 30, title: "", titlecolor: MyAppColor(), titleFont: 12, bgColor: UIColor.white, superView: bottomView)
        rightBtn.layer.borderColor = MyAppColor().cgColor
        rightBtn.layer.borderWidth = 0.6
        rightBtn.layer.cornerRadius = 5
        
        let centerBtn = UIButton()
        method.creatButton(btn: centerBtn, x: app_width - 140, y: 5, wid: 60, hei: 30, title: "", titlecolor: MyAppColor(), titleFont: 12, bgColor: UIColor.white, superView: bottomView)
        centerBtn.layer.borderColor = MyAppColor().cgColor
        centerBtn.layer.borderWidth = 0.6
        centerBtn.layer.cornerRadius = 5
        centerBtn.isHidden = true
        let leftBtn = UIButton()
        method.creatButton(btn: leftBtn, x: app_width - 210, y: 5, wid: 60, hei: 30, title: "", titlecolor: MyAppColor(), titleFont: 12, bgColor: UIColor.white, superView: bottomView)
        leftBtn.layer.borderColor = MyAppColor().cgColor
        leftBtn.layer.borderWidth = 0.6
        leftBtn.layer.cornerRadius = 5
        leftBtn.isHidden = true
        
//        case waitPay        = "0"
//        case waitRecive     = "1"
//        case send           = "2"
//        case waitEnv        = "3"
//        case finish         = "4"
//        case cancle         = "5"
//        case refund         = "6"
//        case refunded       = "7"
//        case allOrder       = "10"
//        0待付款 1 已付款 2 已发货 3 已签收 4 已完成 5 取消 6 申请退款 7 已退款）
        switch orderInfo["order"]["orderStatus"].stringValue {
        case "0":
            //            return "待支付"
            rightBtn.setTitle("立即支付", for: .normal)
            rightBtn.addTarget(self, action: #selector(cancleOrder), for: .touchUpInside)
            centerBtn.setTitle("取消订单", for: .normal)
            centerBtn.addTarget(self, action: #selector(printOrder), for: .touchUpInside)
            centerBtn.isHidden = false
//            leftBtn.setTitle("取消订单", for: .normal)
//            leftBtn.isHidden = false
//            leftBtn.addTarget(self, action: #selector(cancleOrder), for: .touchUpInside)
        case "1":
            //return "已付款"
            rightBtn.setTitle("取消订单", for: .normal)
            rightBtn.addTarget(self, action: #selector(cancleOrder), for: .touchUpInside)
            //            centerBtn.setTitle("打印订单", for: .normal)
            //            centerBtn.addTarget(self, action: #selector(printOrder), for: .touchUpInside)
            //            centerBtn.isHidden = false
            //            leftBtn.setTitle("取消订单", for: .normal)
            //            leftBtn.isHidden = false
        //            leftBtn.addTarget(self, action: #selector(cancleOrder), for: .touchUpInside)
        case "2":
            //            return "待签收"
            rightBtn.setTitle("立即签收", for: .normal)
            rightBtn.addTarget(self, action: #selector(verArrive), for: .touchUpInside)
            centerBtn.setTitle("联系快递", for: .normal)
            centerBtn.addTarget(self, action: #selector(connectCustomer), for: .touchUpInside)
            centerBtn.isHidden = false
//            leftBtn.setTitle("打印订单", for: .normal)
//            leftBtn.isHidden = false
//            leftBtn.addTarget(self, action: #selector(printOrder), for: .touchUpInside)
        case "3":
            //return "待评价"
            rightBtn.setTitle("评价送积分", for: .normal)
            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
//            centerBtn.setTitle("打印订单", for: .normal)
//            centerBtn.isHidden = false
//            centerBtn.addTarget(self, action: #selector(printOrder), for: .touchUpInside)
        case "4":
            //            return "待评价"
            rightBtn.setTitle("删除订单", for: .normal)
            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
//            centerBtn.setTitle("打印订单", for: .normal)
//            centerBtn.isHidden = false
//            centerBtn.addTarget(self, action: #selector(printOrder), for: .touchUpInside)
        case "5":
            //            return "待评价"
            rightBtn.setTitle("删除订单", for: .normal)
            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
//            centerBtn.setTitle("打印订单", for: .normal)
//            centerBtn.isHidden = false
//            centerBtn.addTarget(self, action: #selector(printOrder), for: .touchUpInside)
//        case "6":
//            //            return "退款单"
//            rightBtn.setTitle("删除订单", for: .normal)
//            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
        default:
            rightBtn.setTitle("删除订单", for: .normal)
            rightBtn.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
        }
    }
    func connectCustomer(){
        method.callTelphone(phoneNo: orderInfo["order"]["phone"].stringValue)
    }
    //打印订单
    func printOrder(){
        
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
        
    }
    //确认送达
    func verArrive(){
//        HttpTool.shareHttpTool.Http_verifyDelivery(orderNo: orderInfo["order"]["orderNo"].stringValue) { (data) in
//            print(data)
//            if data["code"].stringValue == "SUCCESS"{
//                self.myNoticeSuccess(title: "确认成功")
//                self.backPage()
//            }else{
//                self.myNoticeError(title: data["msg"].stringValue)
//            }
//        }
    }
    //立即配送
    func toSend(){
//        let vc = DeliveryPeopleViewController()
//        vc.isChosePeople = true
//        vc.delegate = self
//        self.pushToNext(vc: vc)
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
    func creatItem(title:String,value:String,Y:CGFloat,item_height:CGFloat,superView:UIView){
        let titleLab = UILabel()
        method.creatLabel(lab: titleLab, x: 15, y: Y, wid: app_width/3, hei: item_height, textString: title, textcolor: UIColor.gray, textFont: 12, superView: superView)
        
        let valueLab = UILabel()
        method.creatLabel(lab: valueLab, x: titleLab.rightPosition(), y: Y, wid: app_width * 2/3 - 30, hei: item_height, textString: value, textcolor: UIColor.gray, textFont: 12, superView: superView)
        valueLab.textAlignment = .right
        if title == "订单总收入"{
            valueLab.textColor = MyAppColor()
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
            //==1待配送状态，没有这一栏信息
            if self.orderInfo["order"]["orderStatus"].stringValue == "1"{
                return 0
            }else{
                return 1
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
            return 120
        case 3:
            return 100
        case 4:
            return 150
        default:
            return 60
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            let icon = UIImageView()
            method.creatImage(img: icon, x: 15, y: 10, wid: 15, hei: 15, imgName: "dingdanzhuangtai", imgMode: .scaleAspectFit, superView: cell.contentView)
            let title = UILabel()
            method.creatLabel(lab: title, x: icon.rightPosition() + 5, y: 0, wid: 100, hei: 35, textString: "订单状态", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            
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
                method.creatLabel(lab: title, x: 15, y: 0, wid: 100, hei: 35, textString: "预计送达时间", textcolor: UIColor.black, textFont: 10, superView: cell.contentView)
                
                let time = UILabel()
                method.creatLabel(lab: time, x: 120, y: 0, wid: app_width - 135, hei: 35, textString: method.convertTime(time: orderInfo["order"]["predictTime"].doubleValue), textcolor: UIColor.black, textFont: 10, superView: cell.contentView)
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
            if self.orderInfo["order"]["orderStatus"].stringValue == "5"{
                lab.text = "取消原因"
                height = 70/3
                creatItem(title: "取消方", value: "", Y: 30, item_height: height, superView: cell.contentView)
                creatItem(title: "取消原因", value: "", Y: 30+height, item_height: height, superView: cell.contentView)
                creatItem(title: "联系电话", value: orderInfo["order"]["phone"].stringValue, Y: 30 + 2 * height, item_height: height, superView: cell.contentView)
            }else{
                creatItem(title: "配送员", value: orderInfo["order"]["deliveryPerson"].stringValue, Y: 30, item_height: height, superView: cell.contentView)
                creatItem(title: "联系电话", value: orderInfo["order"]["deliveryPhone"].stringValue, Y: 30+height, item_height: height, superView: cell.contentView)
            }
            
            return cell
        case 4:
            let cell = UITableViewCell()
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: 200, hei: 30, textString: "订单详情", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            method.drawLine(startX: 15, startY: 30, wid: app_width - 15, hei: 0.6, add: cell.contentView)
            
            let height:CGFloat = 120/6
            creatItem(title: "订单号", value: orderInfo["order"]["orderNo"].stringValue, Y: 30, item_height: height, superView: cell.contentView)
            creatItem(title: "下单时间", value: method.convertTime(time: orderInfo["order"]["createDate"].doubleValue), Y: 30+height, item_height: height, superView: cell.contentView)
            creatItem(title: "结算金额", value: "¥"+orderInfo["order"]["settleFee"].doubleValue.getMoney(), Y: 30+2*height, item_height: height, superView: cell.contentView)
            creatItem(title: "配送费", value: "¥"+orderInfo["order"]["courierFee"].doubleValue.getMoney(), Y: 30+3*height, item_height: height, superView: cell.contentView)
            creatItem(title: "优惠券抵扣", value: "-¥"+orderInfo["order"]["ticketFee"].doubleValue.getMoney(), Y: 30+4*height, item_height: height, superView: cell.contentView)
            creatItem(title: "订单总收入", value: "¥"+orderInfo["order"]["orderFee"].doubleValue.getMoney(), Y: 30+5*height, item_height: height, superView: cell.contentView)
            return cell
        default:
            let cell = UITableViewCell()
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: app_width - 30, hei: 60, textString: "备注："+orderInfo["order"]["remark"].stringValue, textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            lab.numberOfLines = 2
            lab.lineBreakMode = .byCharWrapping
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
