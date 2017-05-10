//
//  AddressViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol AddressViewDelegate {
    func postAddressInfo(address:JSON)
}
class AddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var delegate:AddressViewDelegate?
    var isChoseAddress:Bool = false
    var addressList:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.addressTable.reloadData()
            }
        }
    }
    var isAddressChose:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "收货地址", canBack: true)
        creatView()
        
        // Do any additional setup after loading the view.
    }
    func reloadData(){
        HttpTool.shareHttpTool.Http_getAddressList { (data) in
            print(data)
            if data.arrayValue.count == 0{
                self.myNoticeNodata()
            }
            self.addressList = data.arrayValue
        }
    }
    let addressTable = UITableView()
    func creatView(){
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: app_width - 80, y: 24, wid: 80, hei: 40, title: "新增", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        rightBtn.addTarget(self, action: #selector(toAddNew), for: .touchUpInside)
        
        let topnotice = UILabel()
        method.creatLabel(lab: topnotice, x: 0, y: nav_height, wid: app_width, hei: 30, textString: "       最多可新增20个收获地址", textcolor: UIColor.gray, textFont: 10, superView: self.view)
        topnotice.backgroundColor = MyGlobalColor()
        
        
        addressTable.frame = CGRect(x: 0, y: topnotice.bottomPosition(), width: app_width, height: app_height - topnotice.bottomPosition())
        addressTable.delegate = self
        addressTable.dataSource = self
        addressTable.rowHeight = 60.0
        addressTable.tableFooterView = UIView()
        self.view.addSubview(addressTable)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return addressList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "addresscellid") as? AddressTableViewCell
        if cell == nil{
            cell = AddressTableViewCell()
        }
        cell!.addressRemark = addressList[indexPath.row]["addressType"].stringValue
        cell!.addressStr = addressList[indexPath.row]["address"].stringValue + addressList[indexPath.row]["addressInfo"].stringValue
        cell!.phoneAndNameStr = addressList[indexPath.row]["contactParson"].stringValue + "       " + addressList[indexPath.row]["phone"].stringValue
        cell!.deleteBtn.tag = indexPath.row
        cell!.deleteBtn.addTarget(self, action: #selector(deleteAddress(btn:)), for: .touchUpInside)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isChoseAddress{
            delegate?.postAddressInfo(address: addressList[indexPath.row])
            self.backPage()
        }else{
            let vc = AddNewAddressViewController()
            vc.isAddNew = false
            vc.addressInfo = addressList[indexPath.row]
            self.pushToNext(vc: vc)
        }
    }
    func toAddNew(){
        let vc = AddNewAddressViewController()
        vc.isAddNew = true
        self.pushToNext(vc: vc)
    }
    func deleteAddress(btn:UIButton){
        let alert = UIAlertController(title: "", message: "确定要删除该收货地址吗？", preferredStyle: .alert)
        let act1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let act2 = UIAlertAction(title: "确定", style: .default) { (data) in
            HttpTool.shareHttpTool.Http_deleteAddressById(addressId: self.addressList[btn.tag]["addressID"].stringValue) { (data) in
                print(data)
                self.myNoticeSuccess(title: data["msg"].stringValue)
                if data["code"].stringValue == "SUCCESS"{
                    self.reloadData()
                }
            }
        }
        alert.addAction(act1)
        alert.addAction(act2)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        //刷新数据
        reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
