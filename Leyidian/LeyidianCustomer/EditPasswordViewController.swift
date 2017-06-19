//
//  EditPasswordViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/27.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class EditPasswordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var method = Methods()
    var hasOldPwd:Bool = true
    var titleArr = ["原密码","新密码"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "登录密码", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        // Do any additional setup after loading the view.
    }
    lazy var oldPwd:UITextField={
        let text = UITextField()
        text.frame = CGRect(x: 100, y: 0, width: app_width - 150, height: 45)
        text.font = UIFont.systemFont(ofSize: 13)
        text.placeholder = "请输入原密码"
        text.returnKeyType = .done
        text.isSecureTextEntry = true
        text.delegate = self
        return text
    }()
    
    lazy var newPwd:UITextField={
        let text = UITextField()
        text.frame = CGRect(x: 100, y: 0, width: app_width - 150, height: 45)
        text.font = UIFont.systemFont(ofSize: 13)
        text.placeholder = "密码长度6-20位长度字母和数字"
        text.isSecureTextEntry = true
        text.returnKeyType = .done
        text.delegate = self
        return text
    }()
    func creatView(){
        let table = UITableView()
        table.frame = CGRect(x: 0, y: nav_height + 10, width: app_width, height: hasOldPwd ? 90:45)
        table.bounces = false
        table.delegate = self
        table.dataSource = self
//        table.rowHeight = 40
        self.view.addSubview(table)
        
        let forgetPwd = UIButton()
        method.creatButton(btn: forgetPwd, x: app_width - 80, y: table.bottomPosition()+10, wid: 80, hei: 20, title: "忘记密码？", titlecolor: myAppGryaColor(), titleFont: 12, bgColor: UIColor.clear, superView: self.view)
        
        forgetPwd.addTarget(self, action: #selector(forgetPwdClick), for: .touchUpInside)
        
        let submitBtn = UIButton()
        method.creatButton(btn: submitBtn, x: 15, y: table.bottomPosition() + 60, wid: app_width - 30, hei: (app_width - 30)/7.73, title: "确认修改", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: self.view)
        submitBtn.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
    }
    
    func forgetPwdClick(){
        self.pushToNext(vc: ForgetPwdViewController())
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !hasOldPwd && indexPath.row == 0{
            return 0
        }else{
            return 45
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let title = UILabel()
        method.creatLabel(lab: title, x: 15, y: 0, wid: 85, hei: 45, textString: "", textcolor: myAppBlackColor(), textFont: 13, superView: cell.contentView)
        if indexPath.row == 1{
//            切换密码可见按钮
            title.text = titleArr[indexPath.row]
            cell.contentView.addSubview(newPwd)
            let eyesBtn = UIButton()
            eyesBtn.frame = CGRect(x: app_width - 50, y: 0, width: 40, height: 45)
            eyesBtn.setImage(UIImage(named:"mima-bukejian"), for: .normal)
            eyesBtn.addTarget(self, action: #selector(eyesBtnClick(btn:)), for: .touchUpInside)
            cell.contentView.addSubview(eyesBtn)
        }else{
            if hasOldPwd{
                title.text = titleArr[indexPath.row]
                cell.contentView.addSubview(oldPwd)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func eyesBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.setImage(UIImage(named: btn.isSelected ? "mima-kejian" : "mima-bukejian"), for: .normal)
        newPwd.isSecureTextEntry = !btn.isSelected
    }
    func submitBtnClick(){
        if hasOldPwd{
            guard oldPwd.text != "" else {
                self.myNoticeError(title: "原密码不能为空")
                return
            }
        }
        
        
        guard newPwd.text != "" else {
            self.myNoticeError(title: "新密码不能为空")
            return
        }
        guard newPwd.text!.characters.count <= 20 else {
            self.myNoticeError(title: "密码长度不能大于20个字符")
            return
        }
        guard newPwd.text!.characters.count >= 6 else {
            self.myNoticeError(title: "密码长度不能小于6个字符")
            return
        }
        if hasOldPwd{
            HttpTool.shareHttpTool.Http_UpdatePassword(oldPassword: oldPwd.text!, newPassword: newPwd.text!, succesce: { (data) in
                print(data)
                if data["code"].stringValue == "SUCCESS"{
                    self.myNoticeSuccess(title: "修改成功")
                    self.backPage()
                }else{
                    self.myNoticeError(title: data["msg"].stringValue)
                }
            })
        }else{
            HttpTool.shareHttpTool.Http_SitePassword(password: newPwd.text!, succesce: { (data) in
                print(data)
                if data["code"].stringValue == "SUCCESS"{
                    self.myNoticeSuccess(title: "设置成功")
                    self.backPage()
                }else{
                    self.myNoticeError(title: data["msg"].stringValue)
                }
            })
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        newPwd.resignFirstResponder()
        oldPwd.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
