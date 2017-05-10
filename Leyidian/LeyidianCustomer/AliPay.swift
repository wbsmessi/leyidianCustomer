//
//  AliPay.swift
//  SocialityApp
//
//  Created by 马志敏 on 16/4/26.
//  Copyright © 2016年 blanche. All rights reserved.
//

import UIKit

class AliPay: NSObject {
    let parnter = "2088711474543943"
    let seller = "dongmeico@163.com"
    let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALsuE0gUb4mfAPmQWJF7LuAyM+Xkcbz6pAW1I4nWS54Vou0nFIvCVllo3s/BR7aCASrBK3ziI4XcWQyV5YqDNaX9+Y6KltJP0XIQlDRTUaxC5GR9DAnKN13ts393ZZWmWa/Nj1e10LkoMa0MDEaojG9YW3RbkrcBNOEfwK886vn/AgMBAAECgYBKnBwNcC/hcGLIF3RmUO6naPts2HlJtbJpoAFRcPzlP4SY+SnkZ4tZykZ+E3HNWtayPxthhRZZxjIspRdA9foMyLiZXJmcyEusoU474eqyByO1wgOTSBaBu58i0dnKGsNU+T3JiIdNyIu7WmIutqXTB586y4pH9areeXYNc0fDeQJBAN/Y2OvJZsmYDu0s60IwVd2E+QbMrx8XmEwNwGaAMg1taqsXytNUMZqzkjreyoIofMY5yylAStaAcfn+iT0I+yMCQQDWEO5UbBgylBXHZ4JL1cqagoEIsTwTqRupna/ExmwRmmU2qq2VYh2yYj6z64gJ7TJh+QbihYEC8F5J4pOqb7F1AkBOTx88BX43AkIeiPtYcW5oi49O6KZO+0MlQB5R/YEFH4UUi8NCAQ9FbpK2k6BGvoFAG5HOQZasycyVx40dVBn/AkBseM3b955XWtSiY6ARv3bXzpOGDRFNQR7kVyQvCQDP9rWc+uXU0ZAMyV3Om+YmaYxjOuYzOMVD8PtGY0rCTbDVAkEAiK/j5Y8Hxf6dOYoOX9qu2aouAGRpdaoTTveu1dna1bOqQ2iNuINPMknZcHjs6BoVogdx54rgVvtiDdGr/ZVOWQ=="
//    func gotoAliPay(money:String,orderNumber:String,goodsName:String){
    func gotoAliPay(payStr:String){
//        let myOrder = Order()
//        myOrder.partner = self.parnter
//        myOrder.seller = self.seller
//        myOrder.productName = goodsName
//        myOrder.productDescription = "great"
////        myOrder.amount = "\((money as NSString).floatValue.getMoney())"   //价钱。。。必须为两位小数
//        myOrder.amount = money   //价钱。。。必须为两位小数
////        myOrder.amount = "0.01"//测试金额 。。。。 1分钱
//        myOrder.tradeNO = orderNumber//订单号
//        myOrder.notifyURL = "http://www.dongmeiwang.com/alipay/notifyurlapp"//结果回调地址(不能为空)
//        myOrder.service = "mobile.securitypay.pay"
//        myOrder.paymentType = "1"
//        myOrder.inputCharset = "utf-8"
//        myOrder.itBPay = "30m"
//        myOrder.showUrl = "m.alipay.com"
        let appScheme = "leyidian.customer"
//        let orderSpec = myOrder.description
//        let signer = CreateRSADataSigner(privateKey)
//        let signedString = signer.signString(orderSpec)
//        if signedString != nil{
//            let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""
//            print("____________________________________")
//            print(orderString)  
//            print("____________________________________")DISPATCH_QUEUE_SERIAL
//            let queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT)
        let queue = DispatchQueue(label: "myQueue")
        queue.sync {
            AlipaySDK.defaultService().payOrder(payStr, fromScheme: appScheme, callback: { (resultDic) -> Void in
                let resultStatus = resultDic?["resultStatus"] as? String
                //                    print("______________________________ ______")
                //                    print(resultStatus)
                //                    print("____________________________________")
                if resultStatus == "9000"{
                    //支付成功
                    print("支付成功")
//                    self.alertFunc(title: "支付成功")
                }else{
                    //支付失败
                    print("支付失败")
//                    self.alertFunc(title: "支付失败")
                }
            })
        }
        
    }
//    func alertFunc(title:String){
//        let alert = UIAlertView(title: title, message: "", delegate: nil, cancelButtonTitle: "确定")
//        alert.show()
//    }
}
