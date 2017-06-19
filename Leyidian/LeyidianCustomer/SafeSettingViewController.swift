//
//  SafeSettingViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/27.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class SafeSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var titleArr = ["绑定手机","登录密码"]
    var resultData:JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "账户安全", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        
        // Do any additional setup after loading the view.
    }
    let table = UITableView()
    func creatView(){
        
        table.frame = CGRect(x: 0, y: nav_height + 10, width: app_width, height: 50 * 2)
        table.bounces = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        self.view.addSubview(table)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        let title = UILabel()
        method.creatLabel(lab: title, x: 15, y: 0, wid: 150, hei: 50, textString: titleArr[indexPath.row], textcolor: myAppBlackColor(), textFont: 13, superView: cell.contentView)
        if indexPath.row == 0{
            if let phoneNum = MyUserInfo.value(forKey: userInfoKey.phone.rawValue) as? String{
                if phoneNum.characters.count == 11{
                    let phoneStr = (phoneNum as NSString).substring(to: 3)
                    let phoneStrend = (phoneNum as NSString).substring(from: 7)
                    let phone = UILabel()
                    method.creatLabel(lab: phone, x: app_width - 150, y: 0, wid: 120, hei: 50, textString: phoneStr + "****" + phoneStrend, textcolor: UIColor.gray, textFont: 13, superView: cell.contentView)
                    phone.textAlignment = .right
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            let vc = ChangePhoneViewController()
            if self.resultData?["phone"].stringValue.characters.count == 11{
                vc.hasOldPhone = true
            }else{
                vc.hasOldPhone = false
            }
            self.pushToNext(vc: vc)
        }else{
            //有绑定手机号码
//            MyUserInfo.setValue(data["resultData"]["phone"].stringValue, forKey: userInfoKey.phone.rawValue)
            if self.resultData?["phone"].stringValue.characters.count == 11{
                let vc = EditPasswordViewController()
                if self.resultData?["password"].stringValue.characters.count == 0{
                    vc.hasOldPwd = false
                }else{
                     vc.hasOldPwd = true
                }
                self.pushToNext(vc: vc)
            }else{
                self.myNoticeError(title: "请先绑定手机号码")
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        checkPhone()
    }
    func checkPhone(){
        HttpTool.shareHttpTool.Http_GetAccountInfo { (data) -> (Void) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.resultData = data["resultData"]
                MyUserInfo.setValue(data["resultData"]["phone"].stringValue, forKey: userInfoKey.phone.rawValue)
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
