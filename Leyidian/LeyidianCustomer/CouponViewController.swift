//
//  CouponViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON


class CouponViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TypeChoseDelegate {

    var couponData:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.conponTable.reloadData()
            }
        }
    }
    var couponType:couponTypeEnum = couponTypeEnum.unuse
    var method = Methods()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "我的优惠券", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        
        // Do any additional setup after loading the view.
    }
    func initChoseView(couponData:[JSON]){
        creatView(iscouponChose:true)
        self.couponData = couponData
    }
    func initListView(){
        creatView(iscouponChose:false)
        loadCouponList(type: couponTypeEnum.unuse.rawValue)
    }
    let conponTable = UITableView()
    func creatView(iscouponChose:Bool){
        let conponTypeView = TypeChoseView(frame: CGRect(x: 0, y: nav_height, width: app_width, height: iscouponChose ? 0 : 50))
        conponTypeView.typeChoseDelegate = self
        conponTypeView.item_width = app_width/3
        conponTypeView.reloadWithArray(array: ["未使用","已使用","已过期"])
        self.view.addSubview(conponTypeView)
        
        conponTable.frame = CGRect(x: 0, y: conponTypeView.bottomPosition() + 10, width: app_width, height: app_height - conponTypeView.bottomPosition() - 10)
        conponTable.delegate = self
        conponTable.dataSource = self
        conponTable.tableFooterView = UIView()
        conponTable.allowsSelection = false
        conponTable.rowHeight = 120
        conponTable.showsVerticalScrollIndicator = false
        conponTable.separatorStyle = .none
        conponTable.backgroundColor = setMyColor(r: 248, g: 248, b: 248, a: 1)
        self.view.addSubview(conponTable)
    }
    
    func TypeChoseClick(index:Int){
        switch index {
        case 0:
            //未使用
            couponType = couponTypeEnum.unuse
//            loadCouponList(type: couponTypeEnum.unuse.rawValue)
        case 1:
            //已使用
            couponType = couponTypeEnum.used
//            loadCouponList(type: couponTypeEnum.used.rawValue)
        default:
            //已过期couponTypeEnum.unuse.rawValue
            couponType = couponTypeEnum.expired
        }
        loadCouponList(type: couponType.rawValue)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return couponData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "conponcellid") as? ConponTableViewCell
        if cell == nil{
            cell = ConponTableViewCell()
        }
//        couponData[indexPath.row]["ticketInstName"].stringValue
        let requireStr = "限购[\(couponData[indexPath.row]["useStoreType"].stringValue == "B" ? "便利店":"连锁超市")]店铺商品"
        cell!.setValue(money: couponData[indexPath.row]["worth"].stringValue, remark: couponData[indexPath.row]["consumeLimit"].stringValue, require: requireStr, fireTime: couponData[indexPath.row]["createDate"].doubleValue, couponType:self.couponType)
        
        
        return cell!
    }
    func loadCouponList(type:String){
        HttpTool.shareHttpTool.Http_ticketList(status: type, startIndex: 0) { (data) in
            print(data)
            self.couponData = data.arrayValue
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
