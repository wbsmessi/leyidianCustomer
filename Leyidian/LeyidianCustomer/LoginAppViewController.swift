//
//  LoginAppViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/3.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class LoginAppViewController: UIViewController,DECSegmentDelegate {

    var method = Methods()
    var buycarCome:Bool = false
    //登录方式  false  验证码，。true密码
    var ispwdLogin:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "欢迎来到乐易点", canBack: false)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
    }
//    13412345678
//    123456
    /****************************UI部分*******************************/
    lazy var UserName = UITextField()
    lazy var passWord = UITextField()
    lazy var getVer_code = UIButton()
    func backtopage(){
        if buycarCome{
            self.dismiss(animated: true, completion: {
//                print(self.tabBarController?.selectedIndex)
//                self.tabBarController?.selectedIndex=0
//                let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
//                let vc = sb.instantiateViewController(withIdentifier: "homePage") as! UITabBarController
//                vc.selectedIndex=0
            })
//            self.dismiss(animated: true, completion: nil)
        }else{
            _=self.navigationController?.popViewController(animated: true)
        }
    }
    func creatView() {
        let back_btn = UIButton()
        back_btn.setImage(UIImage(named:"fanhui"), for: .normal)
        back_btn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
        back_btn.addTarget(self, action: #selector(backtopage), for: .touchUpInside)
        self.view.addSubview(back_btn)
//        注册按钮
        let signIn = UIButton()
        method.creatButton(btn: signIn, x: app_width - 60, y: 35, wid: 60, hei: 25, title: "注册", titlecolor: UIColor.black, titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        signIn.addTarget(self, action: #selector(turnToSignIn), for: .touchUpInside)
        let segment = DECSegment(frame: CGRect(x: 0, y: 64, width: app_width, height: 50))
        segment.initView(items: ["手机快速登录","账号密码登录"])
        segment.delegate = self
        self.view.addSubview(segment)
        
        UserName.frame = CGRect(x: 0, y: segment.bottomPosition(), width: app_width, height: 60)
        UserName.leftView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 30))
        UserName.leftView?.contentMode = .center
        (UserName.leftView as! UIImageView).image = UIImage(named: "wotouxiang")
        UserName.leftViewMode = .always
        UserName.backgroundColor = UIColor.white
        UserName.placeholder = "手机号"
        UserName.font = UIFont.systemFont(ofSize: 14)
        
        let line = CALayer()
        line.frame = CGRect(x: 20, y: UserName.frame.height-1, width: app_width-20, height: 0.6)
        line.backgroundColor = UIColor.lightGray.cgColor
        UserName.layer.addSublayer(line)
        
        passWord.frame = CGRect(x: 0, y: UserName.bottomPosition(), width: app_width, height: 60)
        passWord.leftView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 30))
        passWord.leftView?.contentMode = .center
        (passWord.leftView as! UIImageView).image = UIImage(named: "yazhengma")
        passWord.leftViewMode = .always
        passWord.backgroundColor = UIColor.white
        passWord.placeholder = "验证码"
        passWord.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(UserName)
        self.view.addSubview(passWord)
        
        method.creatButton(btn: getVer_code, x: app_width-120, y: 0, wid: 120, hei: 60, title: "获取验证码", titlecolor: setMyColor(r:255, g:189, b:0, a:1), titleFont: 14, bgColor: UIColor.clear, superView: passWord)
        getVer_code.addTarget(self, action: #selector(getVerCode), for: .touchUpInside)
        
        let submit = UIButton()
        method.creatButton(btn: submit, x: 15, y: passWord.bottomPosition() + 60, wid: app_width - 30, hei: 40, title: "登  录", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: self.view)
        submit.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        submit.addTarget(self, action: #selector(toLoginApp), for: .touchUpInside)
        
        let bottomView = UIImageView()
        bottomView.isUserInteractionEnabled = true
        method.creatImage(img: bottomView, x: 0, y: submit.bottomPosition()+100, wid: app_width, hei: app_height - (submit.bottomPosition()+100), imgName: "denglu_bg", imgMode: .scaleAspectFill, superView: self.view)
        
        method.drawLine(startX: 0, startY: 50, wid: app_width/2-50, hei: 0.6, add: bottomView)
        method.drawLine(startX: app_width/2+50, startY: 50, wid: app_width/2-50, hei: 0.6, add: bottomView)
        let signTitle = UILabel()
        method.creatLabel(lab: signTitle, x: app_width/2-50, y: 40, wid: 100, hei: 20, textString: "第三方平台登陆", textcolor: UIColor.gray, textFont: 14, superView: bottomView)
        signTitle.textAlignment = .center
        
        
        let wechatSign = UIButton()
        wechatSign.frame = CGRect(x: app_width/2-70, y: signTitle.bottomPosition() + 20, width: 40, height: 40)
        wechatSign.setImage(UIImage(named:"weixin"), for: .normal)
        wechatSign.addTarget(self, action: #selector(wechatLogin), for: .touchUpInside)
        bottomView.addSubview(wechatSign)
        if !WXApi.isWXAppInstalled(){
            wechatSign.isHidden = true
        }
        
        let qqSign = UIButton()
        qqSign.frame = CGRect(x: app_width/2+30, y: signTitle.bottomPosition() + 20, width: 40, height: 40)
        qqSign.setImage(UIImage(named:"QQ"), for: .normal)
        qqSign.addTarget(self, action: #selector(QQLogin), for: .touchUpInside)
        bottomView.addSubview(qqSign)
    }
    func wechatLogin(){
        print("wechat")
        getUserInfoForPlatform(platformType: .wechatSession)
    }
    func QQLogin(){
        print("qq")
        getUserInfoForPlatform(platformType: .QQ)
    }
    /***************************事件处理********************************/
    func toLoginApp(){
        if UserName.text != "" && passWord.text != ""{
            HttpTool.shareHttpTool.Http_Sign(phone: UserName.text!, pwd: passWord.text!) { (data) in
                print(data)
                guard data["code"].stringValue == "SUCCESS" else{
                    self.myNoticeError(title: data["msg"].stringValue)
                    return
                }
                MyUserInfo.setValue(data["resultData"]["userID"].stringValue, forKey: userInfoKey.userID.rawValue)
                MyUserInfo.setValue(data["resultData"]["headUrl"].stringValue, forKey: userInfoKey.headUrl.rawValue)
                MyUserInfo.setValue(data["resultData"]["nickName"].stringValue, forKey: userInfoKey.nickName.rawValue)
                MyUserInfo.setValue(data["resultData"]["phone"].stringValue, forKey: userInfoKey.phone.rawValue)
                MyUserInfo.setValue(data["resultData"]["integral"].stringValue, forKey: userInfoKey.integral.rawValue)
                MyUserInfo.setValue(data["resultData"]["signature"].stringValue, forKey: userInfoKey.signature.rawValue)
                MyUserInfo.setValue(data["resultData"]["sex"].stringValue, forKey: userInfoKey.sex.rawValue)
                MyUserInfo.synchronize()
                self.myNoticeSuccess(title: "登录成功")
                DispatchQueue.main.async {
                    self.backtopage()
                }
            }
        }else{
            self.myNoticeError(title: "账号和密码不能为空")
        }
    }
    func getVerCode(){
        guard  UserName.text != "" else {
            self.myNoticeError(title: "手机号码不能为空")
            return
        }
        HttpTool.shareHttpTool.Http_SendSmsCode(phone: UserName.text!) { (data) -> (Void) in
            print(data)
        }
    }
    //
    func DECSegmentSelect(index: Int) {
//        print(index)
        passWord.text = ""
        if index == 0{
            self.ispwdLogin = false
            (passWord.leftView as! UIImageView).image = UIImage(named: "yazhengma")
            passWord.placeholder = "验证码"
            getVer_code.isHidden = false
        }else{
            self.ispwdLogin = true
            (passWord.leftView as! UIImageView).image = UIImage(named: "mima")
            passWord.placeholder = "请输入您的密码"
            getVer_code.isHidden = true
        }
    }
    func turnToSignIn(){
        self.pushToNext(vc: SignUpViewController())
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UserName.resignFirstResponder()
        passWord.resignFirstResponder()
    }
//    第三方登录
    func getUserInfoForPlatform(platformType:UMSocialPlatformType){
        
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: self) { (result, error) in
            if error == nil{
                print("liginsuccess")
                let res = (result as! UMSocialUserInfoResponse)
                print(res)
                var authType:String = "q"
//                性别（0 男 1 女）
//                let sex = res.gender ?? "0"
                let sex = "0"
                let nickName = res.name  ?? "0"
                let headImg = res.iconurl ?? "0"
                let openId = res.openid ?? "0"
//                let sex = res.gender
                switch platformType {
                case UMSocialPlatformType.wechatSession:
                    authType = "W"
                case UMSocialPlatformType.QQ:
                    authType = "q"
                default:
                    _=""
                }
                HttpTool.shareHttpTool.Http_Sign(nickName: nickName, openID: openId, headUrl: headImg, sex: sex, authType: authType, succesce: { (data) in
                    print(data)
                    if data["code"].stringValue == "SUCCESS"{
                        //存登录信息
                        MyUserInfo.setValue(data["resultData"]["userID"].stringValue, forKey: userInfoKey.userID.rawValue)
                        MyUserInfo.setValue(data["resultData"]["headUrl"].stringValue, forKey: userInfoKey.headUrl.rawValue)
                        MyUserInfo.setValue(data["resultData"]["nickName"].stringValue, forKey: userInfoKey.nickName.rawValue)
                        MyUserInfo.setValue(data["resultData"]["phone"].stringValue, forKey: userInfoKey.phone.rawValue)
                        MyUserInfo.setValue(data["resultData"]["integral"].stringValue, forKey: userInfoKey.integral.rawValue)
                        MyUserInfo.setValue(data["resultData"]["signature"].stringValue, forKey: userInfoKey.signature.rawValue)
                        MyUserInfo.setValue(data["resultData"]["sex"].stringValue, forKey: userInfoKey.sex.rawValue)
                        MyUserInfo.synchronize()
                        self.myNoticeSuccess(title: "登录成功")
                        DispatchQueue.main.async {
                            self.backPage()
                        }
                    }
                })
            }else{
                print("liginfaild")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
