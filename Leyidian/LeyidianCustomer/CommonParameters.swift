//
//  CommonParameters.swift
//  SourceOfFruit
//
//  Created by 马志敏 on 2016/12/26.
//  Copyright © 2016年 DEC.MA. All rights reserved.
//

import UIKit




extension UIViewController{
//    navigation设置
    func setTitleView(title:String,canBack:Bool){
        self.view.backgroundColor = UIColor.white
//        if !canBack{
//            self.tabBarController?.tabBar.tintColor = MyAppColor()
//        }
        let titleView = NavigationTitleView()
        titleView.init_Titleview(title: title,canBack:canBack,vc:self)
        titleView.back_btn.addTarget(self, action: #selector(self.backPage), for: .touchUpInside)
        self.view.addSubview(titleView)
    }
    func backPage(){
        
        DispatchQueue.main.async {
            self.clearAllNotice()
            _=self.navigationController?.popViewController(animated: true)
        }
    }
    func backToRootPage(){
        DispatchQueue.main.async {
            self.clearAllNotice()
            _=self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    //页面zhuan场
    func pushToNext(vc:UIViewController){
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func myNoticeSuccess(title:String){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.success, text: title, autoClear: true, autoClearTime: 1)
            }
        }
    }
    func myNoticeError(title:String){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.error, text: title, autoClear: true, autoClearTime: 1)
            }
        }
    }
    func myNoticeNodata(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.info, text: "暂无数据", autoClear: true, autoClearTime: 1)
            }
        }
    }
}


public enum CouponType:Int {//优惠券类型
    case Canuser     = 1   //可以使用
    case Used        = 2   //已经使用
    case Expired     = 3   //已过期
}
public enum VercodeType:String {//优惠券类型
    case Register       = "register/vcode"   //注册
    case Resetpwd       = "resetpwd/vcode"  //忘记密码
    case Forget         = "nopwdlogin/vcode"  //修改密码
}
/// RGBA的颜色设置
func setMyColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
/// app主色调
func MyAppColor() -> UIColor {
    return setMyColor(r: 255, g: 173, b: 1, a: 1)
}
/// 背景灰色
func MyGlobalColor() -> UIColor {
    return setMyColor(r: 247, g: 248, b: 249, a: 1)
}

/// 按钮高亮色
func MyBtnCanSelectColor() -> UIColor {
    return setMyColor(r: 78, g: 176, b: 23, a: 1)
}

/// 价格色
func MyMoneyColor() -> UIColor {
    return setMyColor(r: 255, g: 109, b: 2, a: 1)
}

//MD5加密算法   桥文件加此string扩展
extension String{
    func md5() ->String!{
//        let str = self.cString(using: <#T##String.Encoding#>)
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
            //println(hash)
        }
        result.deinitialize()
        return String(format: hash as String)
    }
}
extension UIView{
    //获取view的bottom-Y
    func bottomPosition()->CGFloat{
        return self.frame.origin.y + self.frame.height
    }
    //获取view的right-x
    func rightPosition()->CGFloat{
        return self.frame.origin.x + self.frame.width
    }
}
extension Double{
    func getMoney()->String{
        let money = NSString(format: "%.2f", self) as String
        return money
    }
}
extension Double{
    func getSixLocation()->String{
        let flo = NSString(format: "%.6f", self) as String
        return flo
    }
}
extension Float{
    func getOneDecimal()->Float{
        let valueStr = NSString(format: "%.1f", self) as String
        let valueFloat = Float(valueStr) ?? 0.0
        return valueFloat
    }
}

