//
//  ChangePhoneViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class ChangePhoneViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var method = Methods()
    var hasOldPhone:Bool = true
    var  second:Int = 60{
        didSet{
            DispatchQueue.main.async {
                self.getVerCodeBtn.setTitle("\(self.second)s", for: .normal)
            }
        }
    }
    var timer:Timer?
    var titleArr = ["原手机号","绑定手机号","验证码"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        if !hasOldPhone{
//            //假如没有原手机号码
//            titleArr.remove(at: 0)
//        }
        self.setTitleView(title: "绑定手机", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        // Do any additional setup after loading the view.
    }
    lazy var oldPhone:UITextField={
        let text = UITextField()
        text.frame = CGRect(x: 100, y: 0, width: app_width - 150, height: 40)
        text.font = UIFont.systemFont(ofSize: 12)
        text.placeholder = "请输入原来绑定手机号"
        text.returnKeyType = .done
        text.keyboardType = .phonePad
        text.delegate = self
        return text
    }()
    lazy var newPhone:UITextField={
        let text = UITextField()
        text.frame = CGRect(x: 100, y: 0, width: app_width - 150, height: 40)
        text.font = UIFont.systemFont(ofSize: 12)
        text.placeholder = "请输入现在要绑定的手机号"
//        text.isSecureTextEntry = true
        text.returnKeyType = .done
        text.keyboardType = .phonePad
        text.delegate = self
        return text
    }()
    
    lazy var ver_code:UITextField={
        let text = UITextField()
        text.frame = CGRect(x: 100, y: 0, width: app_width - 150, height: 40)
        text.font = UIFont.systemFont(ofSize: 12)
        text.placeholder = "请输入验证码"
//        text.isSecureTextEntry = true
        text.keyboardType = .phonePad
        text.returnKeyType = .done
        text.delegate = self
        return text
    }()
    
    let getVerCodeBtn = UIButton()//发送验证码
    func creatView(){
        let table = UITableView()
        table.frame = CGRect(x: 0, y: nav_height, width: app_width, height: hasOldPhone ? 120:80)
        table.bounces = false
        table.delegate = self
        table.dataSource = self
//        table.rowHeight = 40
        self.view.addSubview(table)
        
        let submitBtn = UIButton()
        method.creatButton(btn: submitBtn, x: 15, y: table.bottomPosition() + 60, wid: app_width - 30, hei: 40, title: "确定", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: self.view)
        submitBtn.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && !hasOldPhone{
            return 0
        }else{
            return 40
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let title = UILabel()
        method.creatLabel(lab: title, x: 15, y: 0, wid: 85, hei: 40, textString: titleArr[indexPath.row], textcolor: UIColor.black, textFont: 12, superView: cell.contentView)
        if indexPath.row == 0{
            cell.contentView.addSubview(oldPhone)
        }else if indexPath.row == 1{
            cell.contentView.addSubview(newPhone)
            method.creatButton(btn: getVerCodeBtn, x: app_width - 80, y: 0, wid: 80, hei: 40, title: "获取验证码", titlecolor: MyAppColor(), titleFont: 13, bgColor: UIColor.clear, superView: cell.contentView)
            getVerCodeBtn.addTarget(self, action: #selector(getVerCodeBtnClick), for: .touchUpInside)
        }else{
            cell.contentView.addSubview(ver_code)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getVerCodeBtnClick(){
        if newPhone.text != "" && newPhone.text!.characters.count == 11{
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatetime), userInfo: nil, repeats: true)
            self.getVerCodeBtn.removeTarget(self, action: #selector(getVerCodeBtnClick), for: .touchUpInside)
            
            HttpTool.shareHttpTool.Http_SendSmsCode(phone: newPhone.text!) { (data) -> (Void) in
                if data["code"].stringValue == "SUCCESS"{
                    self.myNoticeSuccess(title: "发送成功")
                }else{
                    self.timer?.invalidate()
                    self.timer = nil
                    self.second = 60
                    self.getVerCodeBtn.setTitle("获取验证码", for: .normal)
                    self.getVerCodeBtn.addTarget(self, action: #selector(self.getVerCodeBtnClick), for: .touchUpInside)
                }
            }
        }else{
            self.myNoticeError(title: "请输入正确的手机号码")
        }
//        btn.isSelected = !btn.isSelected
    }
    func updatetime(){
        if second >= 1{
            second -= 1
        }else{
            timer?.invalidate()
            timer = nil
            second = 60
            DispatchQueue.main.async {
                self.getVerCodeBtn.setTitle("获取验证码", for: .normal)
            }
            getVerCodeBtn.addTarget(self, action: #selector(getVerCodeBtnClick), for: .touchUpInside)
            
        }
    }
    func submitBtnClick(){
        
        guard newPhone.text!.characters.count == 11 else {
            self.myNoticeError(title: "请填写正确的绑定手机号码")
            return
        }
        
        guard ver_code.text != "" else {
            self.myNoticeError(title: "请输入验证码")
            return
        }
        if hasOldPhone{
            guard oldPhone.text!.characters.count == 11 else {
                self.myNoticeError(title: "请填写正确的原手机号码")
                return
            }
            HttpTool.shareHttpTool.Http_BindPhone(oldPhone: oldPhone.text!, newPhone: newPhone.text!, validCode: ver_code.text!) { (data) in
                print(data)
                if data["code"].stringValue == "SUCCESS"{
                    self.myNoticeSuccess(title: "更改成功")
//                    MyUserInfo.value(forKey: userInfoKey.phone.rawValue)
                    MyUserInfo.setValue(self.newPhone.text!, forKey: userInfoKey.phone.rawValue)
                    self.backPage()
                }else{
                    self.myNoticeSuccess(title: data["msg"].stringValue)
                }
            }
        }else{
            HttpTool.shareHttpTool.Http_SitePhone(phone: newPhone.text!, validCode: ver_code.text!, succesce: { (data) in
                print(data)
                if data["code"].stringValue == "SUCCESS"{
                    MyUserInfo.setValue(self.newPhone.text!, forKey: userInfoKey.phone.rawValue)
                    self.myNoticeSuccess(title: "设置成功")
                    self.backPage()
                }else{
                    self.myNoticeSuccess(title: data["msg"].stringValue)
                }
            })
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        oldPhone.resignFirstResponder()
        newPhone.resignFirstResponder()
        ver_code.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
