//
//  ForgetPwdViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/26.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class ForgetPwdViewController: UIViewController,UITextFieldDelegate {

    var method = Methods()
    var forceVC:LoginAppViewController!
    var isbuyCarCome:Bool = false
    var isAgree:Bool = false
    var second:Int=60{
        didSet{
            DispatchQueue.main.async {
                if self.second == 60{
                    self.get_vercode.setTitle("发送验证码", for: .normal)
                }else{
                    self.get_vercode.setTitle("\(self.second)s", for: .normal)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "找回密码", canBack: false)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        // Do any additional setup after loading the view.
    }
    let phoneNumber = UITextField()
    let ver_code = UITextField()
    let password = UITextField()
    let passwordAgain = UITextField()
    //获取验证吗按钮
    let get_vercode = UIButton()
    let submit = UIButton()//确认按钮
    var titleArr = ["验证手机","验证码","重置密码","确认密码"]
    
    func creatView(){
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
        backBtn.setImage(UIImage(named:"fanhui"), for: .normal)
        backBtn.addTarget(self, action: #selector(bactoForceView), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        creatItem(y: 20+nav_height, defaultTitle:"请输入有效手机号", title: titleArr[0], input: phoneNumber)
        phoneNumber.keyboardType = .phonePad
        
        creatItem(y: 70+nav_height, defaultTitle:"请输入验证码", title: titleArr[1], input: ver_code)
        ver_code.keyboardType = .numberPad
        
        method.creatButton(btn: get_vercode, x: app_width - 100, y: phoneNumber.frame.origin.y, wid: 100, hei: 50, title: "获取验证码", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        get_vercode.addTarget(self, action: #selector(getVercode), for: .touchUpInside)
        
        creatItem(y: 120+nav_height, defaultTitle:"请输入新的登录密码", title: titleArr[2], input: password)
        password.isSecureTextEntry = true
        
//        let pwdBtn = UIButton()
//        pwdBtn.frame = CGRect(x: app_width - 45, y: 10 + password.frame.origin.y, width: 30, height: 30)
//        pwdBtn.setImage(UIImage(named:"mima-bukejian"), for: .normal)
//        pwdBtn.addTarget(self, action: #selector(pwdChange(btn:)), for: .touchUpInside)
//        self.view.addSubview(pwdBtn)
        
        creatItem(y: 170+nav_height, defaultTitle:"请再次输入登录密码", title: titleArr[3], input: passwordAgain)
        passwordAgain.isSecureTextEntry = true
        
        method.creatButton(btn: submit, x: 15, y: passwordAgain.bottomPosition() + 80, wid: app_width - 30, hei: (app_width - 30)/7.73, title: "确认重置密码", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: self.view)
        submit.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        submit.addTarget(self, action: #selector(submitBtn), for: .touchUpInside)
        
        
//        let bottomView = UIImageView()
//        method.creatImage(img: bottomView, x: 0, y: app_height - 200, wid: app_width, hei: 200, imgName: "denglu_bg", imgMode: .scaleAspectFill, superView: self.view)
    }
    func creatItem(y:CGFloat,defaultTitle:String,title:String,input:UITextField){
        input.backgroundColor = UIColor.white
        input.frame = CGRect(x: 0, y: y, width: app_width, height: 50)
        input.leftView = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
        (input.leftView as! UILabel).text = "     " + title
        (input.leftView as! UILabel).textColor = myAppBlackColor()
        (input.leftView as! UILabel).font = UIFont.systemFont(ofSize: 13)
        input.leftViewMode = .always
        input.placeholder = defaultTitle
        input.font = UIFont.systemFont(ofSize: 13)
        input.returnKeyType = .done
        input.delegate = self
        method.drawLine(startX: 15, startY: 49, wid: app_width - 30, hei: 0.6, add: input)
        self.view.addSubview(input)
    }
    //获取验证码的方法
    var timer:Timer?
    func getVercode(){
        
        if phoneNumber.text != ""{
            self.timerStart()
            HttpTool.shareHttpTool.Http_SendSmsCode(phone: phoneNumber.text!) { (data) in
                print(data)
                if data["code"].stringValue == "SUCCESS"{
                    
                    //                    self.myNoticeSuccess(title: "发送验证码成功")
                }else{
                    self.timer?.invalidate()
                    self.timer = nil
                    self.second = 60
                    self.get_vercode.addTarget(self, action: #selector(self.getVercode), for: .touchUpInside)
                    self.myNoticeError(title: data["msg"].stringValue)
                }
            }
        }else{
            self.myNoticeError(title: "请输入手机号码")
        }
    }
    func timerStart(){
        self.get_vercode.removeTarget(self, action: #selector(self.getVercode), for: .touchUpInside)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    //查看用户协议的方法
    func customerDetail(){
        print("223r3f3efer")
    }
    func submitBtn(){
        
        guard phoneNumber.text != "" else {
            self.myNoticeError(title: "请填写电话号码")
            return
        }
        guard ver_code.text != "" else {
            self.myNoticeError(title: "请填写验证码")
            return
        }
        guard password.text != "" else {
            self.myNoticeError(title: "请填写密码")
            return
        }
        guard passwordAgain.text != "" else {
            self.myNoticeError(title: "请再次填写密码")
            return
        }
        guard password.text!.characters.count <= 20 else {
            self.myNoticeError(title: "密码长度不能大于20个字符")
            return
        }
        guard password.text!.characters.count >= 6 else {
            self.myNoticeError(title: "密码长度不能小于6个字符")
            return
        }
        guard password.text == passwordAgain.text else {
            self.myNoticeError(title: "两次输入密码不一致")
            return
        }
        
        HttpTool.shareHttpTool.Http_resetPwd(phone: phoneNumber.text!, validCode: ver_code.text!, password: password.text!) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "重置密码成功！")
                self.bactoForceView()
            }else{
                self.myNoticeError(title: data["msg"].stringValue)
            }
        }
    }
    
    func updateTime(){
        print(second)
        if second >= 1{
            second -= 1
        }else{
            timer?.invalidate()
            timer = nil
            second = 60
            get_vercode.addTarget(self, action: #selector(getVercode), for: .touchUpInside)
            
        }
    }
    func bactoForceView(){
        if isbuyCarCome{
            self.dismiss(animated: true, completion: {
            })
        }else{
            self.backPage()
        }
    }
//    func bactoMianView(){
//        if isbuyCarCome{
//            self.dismiss(animated: false, completion: {
//                self.forceVC.backtopage()
//            })
//        }else{
//            self.backToRootPage()
//        }
//    }
    //    点击切换是否同意协议
    func agreeCustomerProtocol(btn:UIButton){
        btn.isSelected = !btn.isSelected
        isAgree = btn.isSelected
        btn.setImage(btn.isSelected ? UIImage(named:"tongyi") : UIImage(named:"butongyi"), for: .normal)
    }
    //    密码可见的切换
    func pwdChange(btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.setImage(btn.isSelected ? UIImage(named:"mima-kejian") : UIImage(named:"mima-bukejian"), for: .normal)
        password.isSecureTextEntry = !btn.isSelected
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumber.resignFirstResponder()
        password.resignFirstResponder()
        ver_code.resignFirstResponder()
        passwordAgain.resignFirstResponder()
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
