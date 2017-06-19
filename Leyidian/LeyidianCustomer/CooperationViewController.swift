//
//  CooperationViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class CooperationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DECChoseAlertViewDelegate,SingleChoseDelegate,PSCityPickerViewDelegate {

    var method = Methods()
    
    var row_height:CGFloat = 40
    override func viewDidLoad() {
        super.viewDidLoad()
        print(app_height)
        if app_height < 600.0{
            row_height = 35
        }
        self.setTitleView(title: "申请合作", canBack: true)
        creatView()
        loadShopType()
        // Do any additional setup after loading the view.
    }
    var titleArr = [["真实姓名","联系电话","店铺名称","店铺类型","营业时间","所在地","详细地址"],["是否提供送货上门服务","是否有营业执照","是否有食物流通许可证"]]
    
    
    var alertView:DECChoseAlertView!
    func creatView(){
        self.view.backgroundColor = MyGlobalColor()
        
        let title = UILabel()
        title.backgroundColor = MyGlobalColor()
        method.creatLabel(lab: title, x: 15, y: nav_height, wid: app_width - 15, hei: 30, textString: "请完整填写申请资料，以便我们了解你的情况", textcolor: UIColor.gray, textFont: 10, superView: self.view)
        
        let infoTable = UITableView()
        infoTable.frame = CGRect(x: 0, y: title.bottomPosition(), width: app_width, height: 10 * row_height + 10)
        infoTable.dataSource = self
        infoTable.delegate = self
        infoTable.rowHeight = row_height
        infoTable.bounces = false
//        infoTable.allowsSelection = false
        infoTable.showsVerticalScrollIndicator = false
//        infoTable.tableFooterView = UIView()
        self.view.addSubview(infoTable)
        
        let submit = UIButton()
        method.creatButton(btn: submit, x: 15, y: infoTable.bottomPosition() + 20, wid: app_width - 30, hei: (app_width - 30)/7.73, title: "提交申请", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: self.view)
        submit.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        submit.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        
        alertView = DECChoseAlertView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height), arr: [])
        alertView.delegate = self
        self.view.addSubview(alertView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr[section].count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10:0
    }
    
    lazy var username:UITextField={
        var text = UITextField()
        text.frame = CGRect(x: 90, y: 0, width: app_width - 100, height: self.row_height)
        text.delegate = self
        text.placeholder = "请输入你的姓名"
        text.font = UIFont.systemFont(ofSize: 12)
        text.returnKeyType = .done
        return text
    }()
    lazy var userphone:UITextField={
        var text = UITextField()
        text.frame = CGRect(x: 90, y: 0, width: app_width - 100, height: self.row_height)
        text.delegate = self
        text.placeholder = "请输入你的联系电话"
        text.font = UIFont.systemFont(ofSize: 12)
        text.keyboardType = .phonePad
        text.returnKeyType = .done
        return text
    }()
    lazy var storeName:UITextField={
        var text = UITextField()
        text.frame = CGRect(x: 90, y: 0, width: app_width - 100, height: self.row_height)
        text.delegate = self
        text.placeholder = "请输入你的店铺名称"
        text.font = UIFont.systemFont(ofSize: 12)
        text.returnKeyType = .done
        return text
    }()
    lazy var storeType:UITextField={
        var text = UITextField()
        text.frame = CGRect(x: 90, y: 0, width: app_width - 120, height: self.row_height)
        text.delegate = self
        text.placeholder = "请选择你的店铺类型"
        text.font = UIFont.systemFont(ofSize: 12)
        text.returnKeyType = .done
        text.isUserInteractionEnabled = false
        return text
    }()
    lazy var openTime:UITextField={
        var text = UITextField()
        text.frame = CGRect(x: 90, y: 0, width: app_width - 120, height: self.row_height)
        text.delegate = self
        text.placeholder = "请选择营业时间"
        text.font = UIFont.systemFont(ofSize: 12)
        text.isUserInteractionEnabled = false
        text.returnKeyType = .done
        return text
    }()
    lazy var cityPick:PSCityPickerView={
        let pick = PSCityPickerView()
        pick.cityPickerDelegate = self
        return pick
    }()
    lazy var City:UITextField={
        var text = UITextField()
        text.frame = CGRect(x: 90, y: 0, width: app_width - 120, height: self.row_height)
        text.delegate = self
//        text.isUserInteractionEnabled = false
        text.placeholder = "所在地"
        text.font = UIFont.systemFont(ofSize: 12)
        text.returnKeyType = .done
        return text
    }()
    func cityPickerView(_ picker: PSCityPickerView, finishPickProvince province: String, city: String, district: String) {
        City.text = province + city + district
    }
    lazy var address:UITextField={
        var text = UITextField()
        text.frame = CGRect(x: 90, y: 0, width: app_width - 100, height: 40)
        text.delegate = self
        text.placeholder = "请输入详细地址"
        text.font = UIFont.systemFont(ofSize: 12)
        text.returnKeyType = .done
        return text
    }()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let title = UILabel()
        method.creatLabel(lab: title, x: 15, y: 0, wid: 65, hei: 40, textString: titleArr[indexPath.section][indexPath.row], textcolor: UIColor.black, textFont: 11, superView: cell.contentView)
        
        if indexPath.section == 1{
            title.frame = CGRect(x: 15, y: 0, width: app_width/2 - 15, height: row_height)
            let single = SingleChose(frame: CGRect(x: app_width - 150, y: 0, width: 130, height: 35))
            single.delegate = self
            single.tag = indexPath.row
            cell.contentView.addSubview(single)
        }else{
            switch indexPath.row {
            case 0:
                cell.contentView.addSubview(username)
            case 1:
                cell.contentView.addSubview(userphone)
            case 2:
                cell.contentView.addSubview(storeName)
            case 3:
                
                cell.contentView.addSubview(storeType)
                let img = UIImageView()
                method.creatImage(img: img, x: app_width - 30, y: 0, wid: 30, hei: row_height, imgName: "jiantou-up", imgMode: .center, superView: cell.contentView)
            case 4:
                cell.contentView.addSubview(openTime)
                let img = UIImageView()
                method.creatImage(img: img, x: app_width - 30, y: 0, wid: 30, hei: row_height, imgName: "jiantou-up", imgMode: .center, superView: cell.contentView)
            case 5:
                cell.contentView.addSubview(City)
                City.inputView = cityPick
                let img = UIImageView()
                method.creatImage(img: img, x: app_width - 30, y: 0, wid: 30, hei: row_height, imgName: "jiantou-up", imgMode: .center, superView: cell.contentView)
            case 6:
                cell.contentView.addSubview(address)
            default:
                _=""
            }
        }
        return cell
    }
    var selectedIndexPath:IndexPath!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        closeKeybord()
        if indexPath.section == 0{
            switch indexPath.row {
            case 3:
                //店铺类型
                selectedIndexPath = indexPath
                self.alertView.titleArr = [shoptypeTitleArr]
                alertView.animationHideOrNot(hide: false)
                
            case 4:
                //营业时间
                selectedIndexPath = indexPath
                alertView.titleArr = [["0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"],["0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]]
                alertView.animationHideOrNot(hide: false)
//            case 5:
                //所在地
//                selectedIndexPath = indexPath
//                alertView.titleArr = [["成都","重庆"]]
//                alertView.animationHideOrNot(hide: false)
            default:
                _=""
            }
        }
    }
    func DECChoseAlert(title:String){
        print(title)
        switch selectedIndexPath.row {
        case 3:
            self.storeType.text = title
        case 4:
            self.openTime.text = title
//        case 5:
//            self.City.text = title
        default:
            _=""
        }
    }
    //是否提供送货服务
    var canDelivery:String = "N"
    //是否有营业执照
    var hasBusinesslicense:String = "N"
    //是否有食品流通许可证
    var hasFoodLicence:String = "N"
    func itemClick(singleView:SingleChose,chosed:Bool){
        print(singleView.tag)
        switch  singleView.tag {
        case 0:
            canDelivery = chosed ? "Y":"N"
        case 1:
            hasBusinesslicense = chosed ? "Y":"N"
        case 2:
            hasFoodLicence = chosed ? "Y":"N"
        default:
            _=""
        }
    }
    func submitClick(){
        
        guard username.text != "" else {
            self.myNoticeError(title: "姓名不能为空")
            return
        }
        guard userphone.text != "" else {
            self.myNoticeError(title: "电话不能为空")
            return
        }
        guard userphone.text!.characters.count == 11 else {
            self.myNoticeError(title: "请输入11位手机号码")
            return
        }
        guard storeName.text != "" else {
            self.myNoticeError(title: "店铺名称不能为空")
            return
        }
        guard storeType.text != "" else {
            self.myNoticeError(title: "店铺类型不能为空")
            return
        }
        guard openTime.text != "" else {
            self.myNoticeError(title: "营业时间不能为空")
            return
        }
        guard City.text != "" else {
            self.myNoticeError(title: "所在地不能为空")
            return
        }
        guard address.text != "" else {
            self.myNoticeError(title: "详细地址不能为空")
            return
        }
        var soretype:String = "B"
        for item in self.shoptypeArr{
            if item["storeName"].stringValue == storeType.text{
                soretype = item["storeType"].stringValue
            }
        }
        
        HttpTool.shareHttpTool.Http_applyStore(person: username.text!, phone: userphone.text!, storeName: storeName.text!, storeType: soretype, businessHours: openTime.text!, site: City.text!, address: address.text!, delivery: canDelivery, businessLicense: hasBusinesslicense, permit: hasFoodLicence) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "提交成功")
                self.backPage()
            }else{
                self.myNoticeError(title: data["msg"].stringValue)
            }
        }
    }
    func closeKeybord(){
        username.resignFirstResponder()
        userphone.resignFirstResponder()
        storeName.resignFirstResponder()
        storeType.resignFirstResponder()
        openTime.resignFirstResponder()
        City.resignFirstResponder()
        address.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == City{
            City.text = "北京市北京市东城区"
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeybord()
    }
    var shoptypeArr:[JSON] = []
    var shoptypeTitleArr:[String] = []
    func loadShopType(){
        //加载店铺类型数据
        HttpTool.shareHttpTool.Http_getShopType() { (data) in
            self.shoptypeArr = data.arrayValue
            print(data)
            var titleArr:[String] = []
            if data.arrayValue.count > 0{
                for item in data.arrayValue{
                    titleArr.append(item["storeName"].stringValue)
                }
            }
            self.shoptypeTitleArr = titleArr
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
