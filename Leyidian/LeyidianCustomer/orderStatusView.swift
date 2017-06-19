//
//  orderStatusView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/24.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class orderStatusView: UIView,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var orderNo:String = ""
    var arriveTime:Double = 0.00
    var infoArr:[JSON] = []{
        didSet{
            print(infoArr)
            table.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatView()
    }
    let table = UITableView()
    func creatView(){
        self.backgroundColor = MyGlobalColor()
        table.delegate = self
        table.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        table.dataSource = self
        table.rowHeight = 60
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.backgroundColor = MyGlobalColor()
        self.addSubview(table)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return infoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        
        let icon = UIImageView()
        method.creatImage(img: icon, x: 25, y: 20, wid: 16, hei: 16, imgName: "shijian", imgMode: .scaleAspectFill, superView: cell.contentView)
        if indexPath.row == 0{
            icon.image = UIImage(named: "shijianzh")
        }
        
        if indexPath.row != infoArr.count{ //row = 2 表示最后一行
//            下面一根
            method.drawLine(startX: 33, startY: icon.bottomPosition(), wid: 0.6, hei: 24, add: cell.contentView)
        }
        if indexPath.row != 0{
            method.drawLine(startX: 33, startY: 0, wid: 0.6, hei: 20, add: cell.contentView)
        }
        
        let statusTitle = UILabel()
        method.creatLabel(lab: statusTitle, x: 50, y: 10, wid: app_width - 200, hei: 20, textString: getstatusName(status: infoArr[indexPath.row]["status"].stringValue), textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
        let statusTime = UILabel()
        
        method.creatLabel(lab: statusTime, x: app_width - 150, y: 10, wid: 135, hei: 20, textString: method.convertTime(time: infoArr[indexPath.row]["createDate"].doubleValue), textcolor: UIColor.gray, textFont: 10, superView: cell.contentView)
        statusTime.textAlignment = .right
        
        let statusRemark = UILabel()
        method.creatLabel(lab: statusRemark, x: 50, y: 30, wid: app_width - 65, hei: 30, textString: getStatusContext(status: infoArr[indexPath.row]["status"].stringValue), textcolor: UIColor.gray, textFont: 11, superView: cell.contentView)
        statusRemark.lineBreakMode = .byCharWrapping
        statusRemark.numberOfLines = 2
        method.drawLine(startX: 50, startY: 59, wid: app_width - 50, hei: 0.6, add: cell.contentView)
        return cell
    }
    func getStatusContext(status:String)->String{
        //0待付款 1 已付款 2 已发货   3 已签收 4 已完成 5 取消 6 已送达 7 已退款 8 已删除  9 退款中 10 退款失败
        switch status {
        case "0":
            return "提交成功,订单号:\(orderNo)。"//预计送达时间:\(method.convertTimeYMD(time: arriveTime)
        case "1":
            return "支付成功,订单号:\(orderNo)。"//预计送达时间:\(method.convertTimeYMD(time: arriveTime)
        case "2":
            return "你的订单正在派送中，请保持手机畅通"
        case "3":
            return "你的订单已签收"
        case "4":
            return "订单交易完成"
        case "5":
            return "你的订单已取消"
        case "6":
            return "你的订单已送到，请尽快签收"
        case "7":
            return "你的订单已退款"
        case "8":
            return ""
        case "9":
            return "退款受理中"
        case "10":
            return "退款失败"
        default:
            return ""
        }
    }
    func getstatusName(status:String)->String{
        //0待付款 1 已付款 2 已发货   3 已签收 4 已完成 5 取消 6 已送达 7 已退款 8 已删除  9 退款中 10 退款失败
        switch status {
        case "0":
            return "订单提交成功"
        case "1":
            return "支付成功"
        case "2":
            return "已发货"
        case "3":
            return "已签收"
        case "4":
            return "已完成"
        case "5":
            return "已取消"
        case "6":
            return "已送到"
        case "7":
            return "已退款"
        case "9":
            return "退款中"
        case "10":
            return "退款失败"
        default:
            return "未知"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
