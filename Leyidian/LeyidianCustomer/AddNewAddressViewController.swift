//
//  AddNewAddressViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/21.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddNewAddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DECChoseAlertViewDelegate,AddressChoseDelegate {

    var method = Methods()
    var isAddNew:Bool = true
    var addressInfo:JSON?
    var nowLocation:CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: isAddNew ? "新增收货地址":"编辑收货地址", canBack: true)
        if !isAddNew{
            self.nowLocation = CLLocationCoordinate2D(latitude: addressInfo!["lat"].doubleValue, longitude: addressInfo!["lon"].doubleValue)
        }
        
        self.view.backgroundColor = MyGlobalColor()
        creatView()
//        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        // Do any additional setup after loading the view.
    }
    var titleArr: [String] = ["收货人","手机号","所在区域","详细地址","标签"]
    lazy var username:UITextField={
        let username = UITextField()
        username.frame = CGRect(x: 80, y: 0, width: app_width - 120, height: 40)
        username.delegate = self
        username.returnKeyType = .done
        username.font = UIFont.systemFont(ofSize: 12)
        if !self.isAddNew{
            username.text = self.addressInfo!["contactParson"].stringValue
        }else{
            username.placeholder = "请填写收货人姓名"
        }
        username.addTarget(self, action: #selector(textFieldValueDidChange(textField:)), for: .editingChanged)
        return username
    }()
    lazy var userphone:UITextField={
        let userphone = UITextField()
        userphone.frame = CGRect(x: 80, y: 0, width: app_width - 120, height: 40)
        userphone.delegate = self
        userphone.returnKeyType = .done
        userphone.font = UIFont.systemFont(ofSize: 12)
        userphone.keyboardType = .phonePad
//        userphone.placeholder = self.isAddNew ? "请填写收货人电话":self.addressInfo!["phone"].stringValue
        if !self.isAddNew{
            userphone.text = self.addressInfo!["phone"].stringValue
        }else{
            userphone.placeholder = "请填写收货人电话"
        }
        
        return userphone
    }()
    lazy var cityAddress:UITextField={
        let cityAddress = UITextField()
        cityAddress.isUserInteractionEnabled = false
        cityAddress.frame = CGRect(x: 80, y: 0, width: app_width - 120, height: 40)
        cityAddress.font = UIFont.systemFont(ofSize: 12)
        cityAddress.textColor = UIColor.lightGray
        if !self.isAddNew{
            cityAddress.text = self.addressInfo!["address"].stringValue
        }else{
            cityAddress.placeholder = "请设置收货地所在区域"
        }
        return cityAddress
    }()
    
    lazy var detailAddress:UITextField={
        let detailAddress = UITextField()
        detailAddress.frame = CGRect(x: 80, y: 0, width: app_width - 120, height: 40)
        detailAddress.delegate = self
        detailAddress.returnKeyType = .done
        detailAddress.font = UIFont.systemFont(ofSize: 12)
        if !self.isAddNew{
            detailAddress.text = self.addressInfo!["addressInfo"].stringValue
        }else{
            detailAddress.placeholder = "请填写详细的地址信息"
        }
        detailAddress.addTarget(self, action: #selector(textFieldValueDidChange(textField:)), for: .editingChanged)
        return detailAddress
    }()
    lazy var addressRemark:UITextField={
        let addressRemark = UITextField()
        addressRemark.isUserInteractionEnabled = false
        addressRemark.frame = CGRect(x: 80, y: 0, width: app_width - 120, height: 40)
        addressRemark.font = UIFont.systemFont(ofSize: 12)
        addressRemark.textColor = UIColor.lightGray
        if !self.isAddNew{
            addressRemark.text = self.addressInfo!["addressType"].stringValue
        }else{
            addressRemark.placeholder = "请选择标签地址"
        }
        return addressRemark
    }()
    
    var alertView:DECChoseAlertView!
    func creatView() {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 80, width: app_width, height: 40 * 5)
        table.rowHeight = 40
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        let submit = UIButton()
        method.creatButton(btn: submit, x: 15, y: table.bottomPosition() + 30, wid: app_width - 30, hei: 40, title: "保存", titlecolor: UIColor.white, titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        submit.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        submit.addTarget(self, action: #selector(editOrAdd), for: .touchUpInside)
        
        
        alertView = DECChoseAlertView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height), arr: [["无","家","公司"]])
        alertView.delegate = self
        self.view.addSubview(alertView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let title = UILabel()
        method.creatLabel(lab: title, x: 15, y: 0, wid: 50, hei: 40, textString: titleArr[indexPath.row], textcolor: UIColor.black, textFont: 12, superView: cell.contentView)
        
        switch indexPath.row {
        case 0:
            cell.contentView.addSubview(username)
        case 1:
            cell.contentView.addSubview(userphone)
        case 2:
            let img = UIImageView()
            method.creatImage(img: img, x: app_width - 30, y: 10, wid: 20, hei: 20, imgName: "dizhi", imgMode: .center, superView: cell.contentView)
//            cityAddress.text = "成都市高新区成汉南路"
            cell.contentView.addSubview(cityAddress)
        case 3:
            cell.contentView.addSubview(detailAddress)
        default:
            cell.accessoryType = .disclosureIndicator
            cell.contentView.addSubview(addressRemark)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        username.resignFirstResponder()
        userphone.resignFirstResponder()
        detailAddress.resignFirstResponder()
        if indexPath.row == 2{
            
            let vc = AddressChoseViewController()
            vc.delegate = self
            vc.showMyAddress = false
            self.pushToNext(vc: vc)
        }
        
        if indexPath.row == 4{
//            alertView.isHidden = false
            alertView.animationHideOrNot(hide: false)
//            let vc = AddressChoseViewController()
//            self.pushToNext(vc: vc)
        }
    }
    func editOrAdd(){
        guard cityAddress.text != "" else {
            self.myNoticeError(title: "收货地址不能为空")
            return
        }
        guard detailAddress.text != "" else {
            self.myNoticeError(title: "收货地址不能为空")
            return
        }
        guard username.text != "" else {
            self.myNoticeError(title: "收货人姓名不能为空")
            return
        }
        guard userphone.text != "" else {
            self.myNoticeError(title: "电话号码不能为空")
            return
        }
        guard userphone.text!.characters.count == 11 else {
            self.myNoticeError(title: "手机号码格式错误")
            return
        }
        
        HttpTool.shareHttpTool.Http_EditOrAddAddress(address: cityAddress.text!, addressInfo: detailAddress.text!, contactParson: username.text!, phone: userphone.text!, lon: nowLocation!.longitude, lat: nowLocation!.latitude, addressType: addressRemark.text!, addressID: isAddNew ? "" : addressInfo!["addressID"].stringValue) { (data) in
            //                print(data)
            guard data["code"].stringValue == "SUCCESS" else{
                self.myNoticeError(title: data["msg"].stringValue)
                return
            }
            self.myNoticeSuccess(title: "保存成功")
            self.backPage()
        }
//        if cityAddress.text != "" && detailAddress.text != "" && username.text != "" && userphone.text != "" && nowLocation != nil{
//            
//        }else{
//            self.myNoticeError(title: "信息不能为空")
//        }
        
    }
    func DECChoseAlert(title:String){
        if title == "无"{
        }else{
            addressRemark.text = title
        }
        
    }
    
    func textFieldValueDidChange(textField: UITextField){
//        print(textField.text)
        if textField == username{
            if textField.text!.characters.count >= 20{
                textField.text = (textField.text! as NSString).substring(to: 20)
            }
        }
        if textField == detailAddress{
            if textField.text!.characters.count >= 40{
                textField.text = (textField.text! as NSString).substring(to: 40)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func addressChose(coordinate:CLLocationCoordinate2D,addressInfo:String){
        self.nowLocation = coordinate
        cityAddress.text = addressInfo
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        userphone.resignFirstResponder()
        username.resignFirstResponder()
        detailAddress.resignFirstResponder()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
