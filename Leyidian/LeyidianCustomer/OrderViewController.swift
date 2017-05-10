//
//  OrderViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class OrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,OrderCellDelegate {

    var nav_title:String!
    var pageIndex:Int = 0
    var infoArr:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.orderTable.reloadData()
            }
        }
    }
    var method = Methods()
    var orderType:orderTypeEnum!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch orderType.rawValue {
        case orderTypeEnum.allOrder.rawValue:
            nav_title = "全部订单"
        case orderTypeEnum.waitPay.rawValue:
            nav_title = "待付款"
        case orderTypeEnum.send.rawValue:
            nav_title = "待收货"
        case orderTypeEnum.waitEnv.rawValue:
            nav_title = "待评价"
        default:
            nav_title = "退款单"
        }
        self.setTitleView(title: nav_title, canBack: false)
        creatView()
//        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let statusStr = (orderType == orderTypeEnum.allOrder) ? "" : orderType.rawValue
//        print(statusStr)
        HttpTool.shareHttpTool.Http_GetOrderList(status: statusStr, startIndex: pageIndex) { (data) in
            print(data)
            if data.arrayValue.count == 0{
                self.myNoticeNodata()
            }
            self.orderTable.mj_header.endRefreshing()
            self.orderTable.mj_footer.endRefreshing()
            self.infoArr += data.arrayValue
        }
    }
    
    var orderTable:UITableView!
    func creatView(){
        
        let back_btn = UIButton()
        back_btn.setImage(UIImage(named:"fanhui"), for: .normal)
        //            back_btn.backgroundColor = UIColor.red
        back_btn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
        back_btn.addTarget(self, action: #selector(back_btnClick), for: .touchUpInside)
        self.view.addSubview(back_btn)
        
        
        self.view.backgroundColor = MyGlobalColor()
        orderTable = UITableView(frame: CGRect(x: 0, y: nav_height + 10, width: app_width, height: app_height - nav_height))
        orderTable.delegate = self
        orderTable.dataSource = self
        orderTable.tableFooterView = UIView()
        orderTable.rowHeight = 180
        orderTable.separatorStyle = .none
        orderTable.showsVerticalScrollIndicator = false
        self.view.addSubview(orderTable)
        self.orderTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageIndex = 0
            self.infoArr = []
            self.loadData()
        })
        self.orderTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
//            print("ososososo")
            self.pageIndex += 1
            self.loadData()
        })
        self.orderTable.mj_header.beginRefreshing()
    }
//    case orderTypeEnum.waitPay.rawValue:
//    timerBtn.isHidden = false
//    startTimer(orderDate:Goods["createDate"].intValue)
//    rightBtn.setTitle("立即支付", for: .normal)
//    leftBtn.isHidden = false
//    leftBtn.setTitle("取消订单", for: .normal)
//    case orderTypeEnum.paid.rawValue:
//    timerBtn.isHidden = true
//    rightBtn.setTitle("取消订单", for: .normal)
//    case orderTypeEnum.send.rawValue:
//    timerBtn.isHidden = true
//    rightBtn.setTitle("立即签收", for: .normal)
//    case orderTypeEnum.waitEnv.rawValue:
//    timerBtn.isHidden = true
//    rightBtn.setTitle("立即评价", for: .normal)
//    case orderTypeEnum.refund.rawValue:
//    timerBtn.isHidden = true
//    rightBtn.setTitle("删除订单", for: .normal)
//    default:
//    timerBtn.isHidden = true
//    rightBtn.setTitle("删除订单", for: .normal)
    func rightBtnClick(orderType: orderTypeEnum, indexpath: IndexPath) {
        //根据订单的类型来判断醉右键应该执行什么操作
        switch orderType.rawValue {
        case orderTypeEnum.waitPay.rawValue://待支付
            print(indexpath)
            let vc = EvaluationViewController()
            vc.orderInfo = self.infoArr[indexpath.row]
            self.pushToNext(vc: vc)
            
        case orderTypeEnum.paid.rawValue://待发货
            //取消订单
            self.cancleOrder(index: indexpath.row)
        case orderTypeEnum.send.rawValue://待收货
//            签收
            self.receiptOrder(index: indexpath.row)
            
        case orderTypeEnum.waitEnv.rawValue://待评价
            print(indexpath)
//            评价
            let vc = EvaluationViewController()
            vc.orderInfo = self.infoArr[indexpath.row]
            self.pushToNext(vc: vc)
        case orderTypeEnum.refund.rawValue://退款
            print(indexpath)
//            删除
            self.deleteOrder(index: indexpath.row)
        default:
            self.deleteOrder(index: indexpath.row)
//            print(indexpath)
        }
    }
    func leftBtnClick(orderType: orderTypeEnum, indexpath: IndexPath) {
        print(indexpath)
        //根据订单的类型来判断左右键应该执行什么操作
        switch orderType.rawValue {
        case orderTypeEnum.waitPay.rawValue://待支付
            //取消订单
            self.cancleOrder(index: indexpath.row)
        case orderTypeEnum.paid.rawValue://待发货
            print(indexpath.row)
        case orderTypeEnum.send.rawValue://待收货
            print(indexpath)
        case orderTypeEnum.waitEnv.rawValue://待评价
            print(indexpath)
        case orderTypeEnum.refund.rawValue://退款
            print(indexpath)
        default:
            print(indexpath)
        }
    }
    
    //返回根目录
    func back_btnClick(){
        self.backToRootPage()
    }
//    删除订单
    func deleteOrder(index:Int){
        let orderId = self.infoArr[index]["orderID"].stringValue
        HttpTool.shareHttpTool.Http_DeleteOrder(orderID: orderId) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "删除订单成功")
            }
        }
    }
//    取消订单
    func cancleOrder(index:Int){
        let orderNo = self.infoArr[index]["orderNo"].stringValue
        HttpTool.shareHttpTool.Http_CancelOrder(remark: "管不着", orderNo: orderNo) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "取消订单成功")
            }
        }
    }
//    签收订单
    func receiptOrder(index:Int){
        let orderId = self.infoArr[index]["orderID"].stringValue
        HttpTool.shareHttpTool.Http_Receipt(orderID: orderId) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "订单签收成功")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension OrderViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return infoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "ordercellid") as? WaitPayOrderTableViewCell
        if cell == nil{
            cell = WaitPayOrderTableViewCell()
        }
        //确定cell的类型.需要具体到某一个订单的类型
        
        cell!.orderType = method.statusConvert(status: self.infoArr[indexPath.row]["orderStatus"].stringValue)
        cell!.indexPath = indexPath
        cell!.delegate = self
        //加载商品信息
        cell!.creatViewWithGoods(Goods: self.infoArr[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ///to detail
        print(indexPath)
        let vc = OrderDetailViewController()
        vc.orderId = self.infoArr[indexPath.row]["orderID"].stringValue
        self.pushToNext(vc: vc)
        
    }
}
