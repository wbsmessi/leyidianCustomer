//
//  AppDelegate.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/2/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,WXApiDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        WXApi.registerApp(wechatAppid, withDescription: "demo 2.0")
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        // Override point for customization after application launch.
        //高德地图
        AMapServices.shared().apiKey = gaodeMapAppkey
//        友盟分享
        UMSocialManager.default().umSocialAppkey = umengKey
        configUSharePlatforms()
        
        if let userid = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as? String{
            //        友盟推送
            UMessage.removeAlias(userid, type: "iOS", response: nil)
            UMessage.addAlias(userid, type: "iOS", response: nil)
        }
        
        UMessage.start(withAppkey: umengPushAppKey, launchOptions: launchOptions)
        UMessage.registerForRemoteNotifications()
        //iOS10必须加下面这段代码。
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                if (granted) {
                    print("注册通知成功") //点击允许
                } else {
                    print("注册通知失败") //点击不允许
                }
            })
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func configUSharePlatforms(){
        //微信好友
        UMSocialManager.default().setPlaform(.wechatSession, appKey: wechatShareKey, appSecret: wechatShareAppSecret, redirectURL: "http://mobile.umeng.com/social")
         //微信朋友圈
        UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: wechatShareKey, appSecret: wechatShareAppSecret, redirectURL: "http://mobile.umeng.com/social")
        //微信收藏
        UMSocialManager.default().setPlaform(.wechatFavorite, appKey: wechatShareKey, appSecret: wechatShareAppSecret, redirectURL: "http://mobile.umeng.com/social")
         //qq
        UMSocialManager.default().setPlaform(.QQ, appKey: tencentKey, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
         //qq空间
        UMSocialManager.default().setPlaform(.qzone, appKey: tencentKey, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
         //微博
        UMSocialManager.default().setPlaform(.sina, appKey: weiboAppKey, appSecret: weiboAppSecket, redirectURL: "http://mobile.umeng.com/social")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let device_ns = NSData.init(data: deviceToken)
        
        var token:String = device_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>" ))
        print(token)
        //        print("-------------")
        token = token.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"));
        print(token)
        token = token.replacingOccurrences(of: " ", with: "")
        // [ GTSdk ]：向个推服务器注册deviceToken
        print(token)
        print(token)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//        if (!result) {
//            // 其他如支付等SDK的回调
//        }
//        return result;
        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        if !result{
            //跳转进行支付，处理支付结果
            let urlStr = ("\(url)" as NSString).substring(to: 2)
            if urlStr == "wx"{
                return WXApi.handleOpen(url as URL!, delegate: self)
            }
            
            if url.host == "safepay"{
                AlipaySDK.defaultService().processOrder(withPaymentResult: url as URL!, standbyCallback: { (resultDic) -> Void in
                    //                发送相同的通知
                    let resultStatus = resultDic?["resultStatus"] as? String
                    if resultStatus == "9000"{
                        //支付成功
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payResult"), object: nil, userInfo: ["result":true])
                    }else{
                        //支付失败
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payResult"), object: nil, userInfo: ["result":false])
                    }
                })
            }
            return true
        }
        return result
    }
    func onResp(_ resp: BaseResp!){
        print("微信支付回调")
        print(resp)
        if resp.isKind(of: PayResp.classForCoder()){
            
            //支付返回结果，实际支付结果需要去微信服务器端查询
            switch resp.errCode{
            case 0://支付成功提醒（
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payResult"), object: nil, userInfo: ["result":true])
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payResult"), object: nil, userInfo: ["result":false])
            }
        }
    }
}

