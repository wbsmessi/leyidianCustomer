//
//  SettingViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SDWebImage

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var phoneNum = "4006060640"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "设置", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        // Do any additional setup after loading the view.
    }
    func creatView(){
//        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        infoArr[0] = phoneNum
        infoArr[2] = "v" + (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        let table = UITableView()
        table.frame = CGRect(x: 0, y: nav_height + 10, width: app_width, height: 45 * 6 + 15)
        table.bounces = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 45
        table.separatorStyle = .none
        self.view.addSubview(table)
        
        let signOut = UIButton()
        method.creatButton(btn: signOut, x: 15, y: table.bottomPosition() + 30, wid: app_width - 30, hei: (app_width - 30)/7.73, title: "退出登录", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: self.view)
        signOut.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        signOut.addTarget(self, action: #selector(signOutClick), for: .touchUpInside)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    let imgArr = [["zhanghuanquan","yonghuxieyi","guanyuwomen-"],["kefu","huancun","banben"]]
    let titleArr = [["账户安全","用户协议","关于我们"],["联系客服","清除缓存","当前版本"]]
    
    var infoArr = ["","",""]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        
        let img = UIImageView()
        method.creatImage(img: img, x: 15, y: 15, wid: 15, hei: 15, imgName: imgArr[indexPath.section][indexPath.row], imgMode: .scaleAspectFit, superView: cell.contentView)
        
        let title = UILabel()
        method.creatLabel(lab: title, x: img.rightPosition() + 15, y: 0, wid: 150, hei: 45, textString: titleArr[indexPath.section][indexPath.row], textcolor: myAppBlackColor(), textFont: 13, superView: cell.contentView)
        method.drawLine(startX: 0, startY: 44.04, wid: app_width, hei: 0.6, add: cell.contentView)
        
        if indexPath.section == 0{
            cell.accessoryType = .disclosureIndicator
        }else{
            let infoLab = UILabel()
            method.creatLabel(lab: infoLab, x: title.rightPosition(), y: 0, wid: app_width - title.rightPosition() - 15, hei: 45, textString: infoArr[indexPath.row], textcolor: UIColor.black, textFont: 10, superView: cell.contentView)
            infoLab.textAlignment = .right
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 15 : 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                self.pushToNext(vc: SafeSettingViewController())
            case 1:
//                用户协议
                let vc = LYDWebViewController()
                vc.loadUrl = shareHeaderUrl + "/appmanager/getPlatform?type=1"
                vc.nav_title = "用户协议"
                self.pushToNext(vc: vc)
            default:
//                关于我们
                let vc = LYDWebViewController()
                vc.loadUrl = shareHeaderUrl + "/appmanager/getAbout?type=1"
                vc.nav_title = "关于我们"
                self.pushToNext(vc: vc)
            }
        }else{
            switch indexPath.row {
            case 0:
                //拨打电话
                method.callTelphone(phoneNo: phoneNum)
            case 1:
                //清楚缓存
                clearCache()
            default:
                _=""
            }
        }
        
    }
    func clearCache(){
        SDImageCache.shared().clearDisk()
        SDImageCache.shared().clearMemory()
        SDWebImageManager.shared().imageCache.clearDisk()
        SDWebImageManager.shared().imageCache.clearMemory()
//        cache.text = "0.0M"
        self.myNoticeSuccess(title: "清除成功")
        //            print(totalSize)
        
    }
    func signOutClick(){
        let alert = UIAlertController(title: "", message: "确定要退出登录？", preferredStyle: .alert)
        let act1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let act2 = UIAlertAction(title: "确定", style: .default) { (finish) in
            //
            MyUserInfo.removeObject(forKey: userInfoKey.headUrl.rawValue)
            MyUserInfo.removeObject(forKey: userInfoKey.integral.rawValue)
            MyUserInfo.removeObject(forKey: userInfoKey.nickName.rawValue)
            MyUserInfo.removeObject(forKey: userInfoKey.phone.rawValue)
            MyUserInfo.removeObject(forKey: userInfoKey.sex.rawValue)
            MyUserInfo.removeObject(forKey: userInfoKey.userID.rawValue)
            MyUserInfo.removeObject(forKey: userInfoKey.signature.rawValue)
            MyUserInfo.synchronize()
            self.backToRootPage()
        }
        alert.addAction(act1)
        alert.addAction(act2)
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
