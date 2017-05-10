//
//  wechatPayment.swift
//  JKHapp
//
//  Created by 马志敏 on 15/11/2.
//  Copyright © 2015年 DEC.MA. All rights reserved.
//

import UIKit
//import Alamofire
import SwiftyJSON

class wechatPayment: NSObject {
    
    func wechatPay(payStr:String){
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showText("正在支付...")
            }
            let data = payStr.data(using: .utf8)
            print(data!)
            do{
                let jsonDic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                let value = JSON(jsonDic)
                print(value)
//                let timeStr = sign.genTimeStamp()
                let req = PayReq()
                req.partnerId = value["partnerid"].stringValue
                req.prepayId = value["prepayid"].stringValue
                req.nonceStr = value["nonce_str"].stringValue
                req.timeStamp = UInt32(value["timestamp"].int32Value)
                req.package = "Sign=sign"
                
                let newsign = value["nonce_str"].stringValue
                req.sign = newsign
                SwiftNotice.clear()
                WXApi.send(req)
                
            }catch{
                
            }
        SwiftNotice.clear()
    }
    func wechatPay(value:JSON){
        DispatchQueue.main.async {
            SwiftNotice.clear()
            SwiftNotice.showText("正在支付...")
        }
        
        print(value)
        //                let timeStr = sign.genTimeStamp()
        let req = PayReq()
        req.partnerId = value["partnerid"].stringValue
        req.prepayId = value["prepayid"].stringValue
        req.nonceStr = value["noncestr"].stringValue
        req.timeStamp = UInt32(value["timestamp"].int32Value)
        req.package = value["package"].stringValue
        
        let newsign = value["sign"].stringValue
        req.sign = newsign
        SwiftNotice.clear()
        WXApi.send(req)
        SwiftNotice.clear()
    }
    func noticeNoNet(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.error, text: "网络连接失败", autoClear: true, autoClearTime: 1)
            }
        }
    }
    func noticeNoData(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.error, text: "暂无数据", autoClear: true, autoClearTime: 1)
            }
        }
    }
}
