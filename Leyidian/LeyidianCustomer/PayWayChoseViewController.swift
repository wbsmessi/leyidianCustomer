//
//  PayWayChoseViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/4/1.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class PayWayChoseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DECAlertViewDelegate {

    var method = Methods()
    var payMoney:String = ""
    var orderNo:String!
    //支付方式   W = wechatpay，A = alipay
    var payWay:String = "A"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "支付", canBack: false)
        
        creatView()
        NotificationCenter.default.addObserver(self, selector: #selector(getPayResult(noti:)), name: NSNotification.Name(rawValue: "payResult"), object: nil)
        // Do any additional setup after loading the view.
    }
    //支付结果处理写在响应的支付页面
    
    func getPayResult(noti:Notification){
        
        print(noti.userInfo!["result"] as! Bool)
        if noti.userInfo!["result"] as! Bool{
            self.pushToNext(vc: PaySuccessViewController())
        }else{
            self.myNoticeError(title: "支付失败，请重试")
        }
    }
    func creatView(){
        let back_btn = UIButton()
        back_btn.setImage(UIImage(named:"fanhui"), for: .normal)
        //            back_btn.backgroundColor = UIColor.red
        back_btn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
        back_btn.addTarget(self, action: #selector(back_btnClick), for: .touchUpInside)
        self.view.addSubview(back_btn)

        self.view.backgroundColor = MyGlobalColor()
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 80, width: app_width, height: 200)
        table.delegate = self
        table.dataSource = self
        table.bounces = false
        table.tableFooterView = UIView()
        self.view.addSubview(table)
    }
    var sureAlert:DECAlertView!
    func back_btnClick(){
        
        sureAlert = DECAlertView(frame: self.view.frame, title: "提示", message: "超过支付时效后订单将被取消，请尽快完成支付", leftBtnTitle: "继续支付", rightBtnTitle: "确认离开")
        sureAlert.delegate = self
        self.view.addSubview(sureAlert)
        
//        let alert = UIAlertController(title: "确定要取消支付吗？", message: "你也可以在订单页面继续支付", preferredStyle: .alert)
//        let act1 = UIAlertAction(title: "我点错了", style: .cancel, handler: nil)
//        let act2 = UIAlertAction(title: "确定离开", style: .default) { (finish) in
//            (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).selectedIndex = 0
////            _=self.navigationController?.popToRootViewController(animated: true)
//            self.backToRootPage()
//        }
//        alert.addAction(act1)
//        alert.addAction(act2)
//        self.present(alert, animated: true, completion: nil)
    }
    func DECAlertViewClick(leftClick: Bool) {
        print("111111")
        sureAlert.removeFromSuperview()
        
        if !leftClick{
            self.backToRootPage()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? 1:2
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 15:0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 35:60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 30:0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lab = UILabel()
        lab.text = "    请选择支付方式"
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }
    var imgArr = ["zhi","wei"]
    var titleArr = ["支付宝","微信"]
//    var detailArr = ["使用支付宝安全支付","使用微信安全支付"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        if indexPath.section == 0{
            let title = UILabel()
            method.creatLabel(lab: title, x: 15, y: 0, wid: 100, hei: 35, textString: "请支付", textcolor: UIColor.black, textFont: 13, superView: cell.contentView)
            let money = UILabel()
            method.creatLabel(lab: money, x: app_width - 170, y: 0, wid: 150, hei: 35, textString: "¥\(payMoney)", textcolor: MyMoneyColor(), textFont: 14, superView: cell.contentView)
            money.textAlignment = .right
        }else{
            cell.accessoryType = .disclosureIndicator
            if indexPath.row==0{
                method.drawLine(startX: 0, startY: 0, wid: app_width, hei: 0.6, add: cell.contentView)
            }
            
            let img = UIImageView()
            method.creatImage(img: img, x: 15, y: 10, wid: 40, hei: 40, imgName: imgArr[indexPath.row], imgMode: .scaleAspectFit, superView: cell.contentView)
            
            let title = UILabel()
            method.creatLabel(lab: title, x: img.rightPosition() + 10, y: 10, wid: 200, hei: 20, textString: titleArr[indexPath.row], textcolor: UIColor.black, textFont: 14, superView: cell.contentView)
            
            let detail = UILabel()
            method.creatLabel(lab: detail, x: img.rightPosition() + 10, y: 30, wid: 200, hei: 20, textString: "使用\(titleArr[indexPath.row])安全支付", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 1 else {
            return
        }
        
        if indexPath.row == 0{
            //alipay
            self.payWay = "A"
        }else{
            //wechapay
            self.payWay = "W"
        }
        payOrder(payType: self.payWay)
    }
    func payOrder(payType:String){
        HttpTool.shareHttpTool.Http_ToPayOrder(payType: payType, orderNo: orderNo) { (data) in
            print(data)
            
            if payType == "A"{
                let paystr = data["pay_map"].stringValue
                AliPay().gotoAliPay(payStr: paystr)
            }else{
                //wechatpay
                wechatPayment().wechatPay(value:data["pay_map"])
            }
        }
    }
    
}
