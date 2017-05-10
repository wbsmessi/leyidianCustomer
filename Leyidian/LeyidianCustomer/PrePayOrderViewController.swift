//
//  PrePayOrderViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class PrePayOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    var method = Methods()
    var orderInfo:JSON!
    //是否含有收获地址
    var addressInfo:JSON!
    var couponInfo:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "订单确认", canBack: true)
        creatView()
        // Do any additional setup after loading the view.
    }
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
        method.creatLabel(lab: payMoney, x: shifujine.rightPosition(), y: 0, wid: app_width - shifujine.rightPosition() - 100, hei: 40, textString: "¥"+orderInfo["settleFee"].doubleValue.getMoney(), textcolor: MyMoneyColor(), textFont: 14, superView: bottomView)
        
        let toPayBtn = UIButton()
        method.creatButton(btn: toPayBtn, x: app_width - 100, y: 0, wid: 100, hei: 40, title: "确认支付", titlecolor: UIColor.white, titleFont: 14, bgColor: MyAppColor(), superView: bottomView)
        toPayBtn.addTarget(self, action: #selector(toPayBtnClick), for: .touchUpInside)
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
                return 120
            case 2:
                return indexPath.row == 0 ? 100:35
            default:
                return 100
        }
    }
    var titleArr = ["收货人","手机号码","收货地址","详细地址","预计送达时间"]
//    可使用的优惠券数量
    let canUserCouponCount = UILabel()
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
                
                let timeStr = method.convertTime(time: orderInfo["predictTime"].doubleValue)
                
                let titleTime = UILabel()
                titleTime.textAlignment = .right
                method.creatLabel(lab: titleTime, x: app_width - 200, y: 0, wid: app_width - 180, hei: 35, textString: timeStr, textcolor: UIColor.black, textFont: 12, superView: cell.contentView)
                return cell
            }
        case 1:
            let cell = OrderDetailGoodsInfoTableViewCell()
            cell.creatViewWithGoods(Goods: orderInfo["detailsList"].arrayValue)
            return cell
        case 2:
            let cell = UITableViewCell()
            if indexPath.row == 0{
                let itemView1 = ItemInfoView(frame: CGRect(x: 15, y: 5, width: app_width - 30, height: 30), title: "商品原价", info: "¥"+orderInfo["totalFee"].doubleValue.getMoney(), infoColor: UIColor.gray)
                cell.contentView.addSubview(itemView1)
                
                let cutMoney = (orderInfo["totalFee"].doubleValue - orderInfo["settleFee"].doubleValue).getMoney()
                let itemView2 = ItemInfoView(frame: CGRect(x: 15, y: itemView1.bottomPosition(), width: app_width - 30, height: itemView1.frame.height), title: "商品已优惠", info: "-¥" + cutMoney, infoColor: MyMoneyColor())
                cell.contentView.addSubview(itemView2)
                let itemView3 = ItemInfoView(frame: CGRect(x: 15, y: itemView2.bottomPosition(), width: app_width - 30, height: itemView1.frame.height), title: "配送费", info: "¥" + orderInfo["courierFee"].doubleValue.getMoney(), infoColor: UIColor.gray)
                cell.contentView.addSubview(itemView3)
            }else{
                
                cell.accessoryType = .disclosureIndicator
                let title = UILabel()
                method.creatLabel(lab: title, x: 15, y: 0, wid: 60, hei: 35, textString: "优惠券", textcolor: UIColor.black, textFont: 14, superView: cell.contentView)
                
                
                method.creatLabel(lab: canUserCouponCount, x: title.rightPosition(), y: 0, wid: 100, hei: 35, textString: "(0张可用)", textcolor: MyAppColor(), textFont: 12, superView: cell.contentView)
                
                let conponStatus = UILabel()
                conponStatus.textAlignment = .right
                method.creatLabel(lab: conponStatus, x: app_width - 150, y: 0, wid: 120, hei: 35, textString: "未使用", textcolor: UIColor.gray, textFont: 10, superView: cell.contentView)
            }
            return cell
        default:
            let cell = UITableViewCell()
            
            let title = UILabel()
            method.creatLabel(lab: title, x: 15, y: 5, wid: 100, hei: 15, textString: "给商家留言：", textcolor: UIColor.gray, textFont: 11, superView: cell.contentView)
            let messageText = UITextView()
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
            vc.goodsInfo = orderInfo["detailsList"].arrayValue
            self.pushToNext(vc: vc)
        }
        
        if indexPath == IndexPath(row: 1, section: 2) {
            if self.couponInfo.count != 0{
                //
                let vc = CouponViewController()
                vc.initChoseView(couponData: self.couponInfo)
                self.pushToNext(vc: vc)
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
    func toPayBtnClick(){
        let vc = PayWayChoseViewController()
        vc.payMoney = orderInfo["settleFee"].doubleValue.getMoney()
        vc.orderNo = orderInfo["orderNo"].stringValue
        self.pushToNext(vc: vc)
    }
    override func viewWillAppear(_ animated: Bool) {
        HttpTool.shareHttpTool.Http_canChoseCoupon(amount: orderInfo["settleFee"].doubleValue) { (data) in
            print(data)
            DispatchQueue.main.async {
                self.canUserCouponCount.text = "\(data.arrayValue.count)张可用"
            }
            self.couponInfo = data.arrayValue
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
