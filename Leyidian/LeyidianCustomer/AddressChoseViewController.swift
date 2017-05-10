//
//  AddressChoseViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/9.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
//import MapKit

protocol AddressChoseDelegate {
    func addressChose(coordinate:CLLocationCoordinate2D,addressInfo:String)
}
class AddressChoseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AMapSearchDelegate,MAMapViewDelegate {

    var method = Methods()
    var showMyAddress:Bool = true
    var locationManager:AMapLocationManager!
    var delegate:AddressChoseDelegate?
    var nowLocation:CLLocationCoordinate2D!
    var nowDataArr:[AddressModel] = []
    var streetInfo:String = ""
//    搜索
    
    var cityName:String = ""{
        didSet{
            DispatchQueue.main.async {
                self.cityNameLab.text = self.cityName
            }
        }
    }
    var isMyAddress:Bool = false{
        didSet{
            DispatchQueue.main.async {
                self.addressTable.reloadData()
            }
        }
    }
    var addressList:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "", canBack: true)
        creatView()
        // Do any additional setup after loading the view.
        reloadData()
    }
    func reloadData(){
        HttpTool.shareHttpTool.Http_getAddressList { (data) in
            print(data)
            self.addressList = data.arrayValue
        }
    }
//    顶部城市名字
    let cityNameLab = UILabel()
    //我的地址
    let myAddressBtn = UIButton()
    //定位当前地址
    let nowAddressBtn = UIButton()
    
    let addressTable = UITableView()
    
    lazy var searchMap:AMapSearchAPI={
        let search = AMapSearchAPI()
        search!.delegate = self
        return search!
    }()
    func creatView(){
        
        cityNameLab.textAlignment = .center
        method.creatLabel(lab: cityNameLab, x: app_width/3, y: 30, wid: app_width/3, hei: 30, textString: "", textcolor: UIColor.black, textFont: 18, superView: self.view)
//        self.requestLocation()
        
        let mapView = MAMapView(frame: CGRect(x: 0, y: 64, width: app_width, height: app_height/2-nav_height))
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 17
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        
        
        locationManager = AMapLocationManager()
        locationManager.locationTimeout = 3
        self.locationManager.reGeocodeTimeout = 2
        
        
        let request = AMapReGeocodeSearchRequest()
//        request.location = AMapGeoPoint.location(withLatitude: <#T##CGFloat#>, longitude: <#T##CGFloat#>)
//        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
        
        
        method.creatButton(btn: myAddressBtn, x: 0, y: mapView.bottomPosition(), wid: app_width/2, hei: showMyAddress ? 40:0, title: "我的地址", titlecolor: UIColor.black, titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        myAddressBtn.setImage(UIImage(named:"dizhi_1"), for: .normal)
        myAddressBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myAddressBtn.titleLabel!.frame.width-10)
        myAddressBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: myAddressBtn.imageView!.frame.width-10, bottom: 0, right: 0)
        myAddressBtn.addTarget(self, action: #selector(myAddressBtnClick), for: .touchUpInside)
        
        method.creatButton(btn: nowAddressBtn, x: app_width/2, y: mapView.bottomPosition(), wid: app_width/2, hei: showMyAddress ? 40:0, title: "定位当前地址", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        nowAddressBtn.setImage(UIImage(named:"dingwei"), for: .normal)
        nowAddressBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: nowAddressBtn.titleLabel!.frame.width - 10)
        nowAddressBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: nowAddressBtn.imageView!.frame.width - 10, bottom: 0, right: 0)
        nowAddressBtn.addTarget(self, action: #selector(nowAddressBtnClick), for: .touchUpInside)
        
        method.drawLine(startX: 0, startY: nowAddressBtn.bottomPosition(), wid: app_width, hei: 0.6, add: self.view)
        method.drawLine(startX: app_width/2, startY: nowAddressBtn.frame.origin.y, wid: 0.6, hei: 40, add: self.view)
        
        
        addressTable.frame = CGRect(x: 0, y: myAddressBtn.bottomPosition()+1, width: app_width, height: app_height - myAddressBtn.bottomPosition())
        addressTable.delegate = self
        addressTable.rowHeight = 50
        addressTable.dataSource = self
        addressTable.tableFooterView = UIView()
        self.view.addSubview(addressTable)
        
        //搜索框
        let searchBar = UITextField()
        searchBar.frame = CGRect(x: 20, y: 80, width: app_width - 40, height: 30)
        searchBar.placeholder = "搜索附近的小区，写字楼，学校等"
        searchBar.leftView = UIImageView(frame: CGRect(x: 10, y: 5, width: 50, height: 20))
        searchBar.leftView?.contentMode = .center
        (searchBar.leftView as! UIImageView).image = UIImage(named: "sousuo_1")
        searchBar.leftViewMode = .always
        searchBar.backgroundColor = UIColor.white
        searchBar.font = UIFont.systemFont(ofSize: 14)
        searchBar.layer.cornerRadius = 15
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        self.view.addSubview(searchBar)
    }
    
    func myAddressBtnClick() {
        //还原
        nowAddressBtn.setTitleColor(UIColor.black, for: .normal)
        nowAddressBtn.setImage(UIImage(named:"dizhi"), for: .normal)
        
        //选中色
        myAddressBtn.setTitleColor(MyAppColor(), for: .normal)
        myAddressBtn.setImage(UIImage(named:"dizhi_1"), for: .normal)
        isMyAddress = true
    }
    func nowAddressBtnClick() {
        //还原
        myAddressBtn.setTitleColor(UIColor.black, for: .normal)
        myAddressBtn.setImage(UIImage(named:"dizhi_1"), for: .normal)
        
        //选中色
        nowAddressBtn.setTitleColor(MyAppColor(), for: .normal)
        nowAddressBtn.setImage(UIImage(named:"dingwei"), for: .normal)
        
        isMyAddress = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return isMyAddress ? addressList.count : nowDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let addressTitle = UILabel()
        method.creatLabel(lab: addressTitle, x: 20, y: 10, wid: app_width-40, hei: 15, textString: "", textcolor: UIColor.black, textFont: 14, superView: cell.contentView)
        
        let addressDetail = UILabel()
        method.creatLabel(lab: addressDetail, x: 20, y: addressTitle.bottomPosition(), wid: addressTitle.frame.width, hei: 15, textString: "", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
        
        if isMyAddress{
            addressTitle.text = addressList[indexPath.row]["address"].stringValue
            addressDetail.text = addressList[indexPath.row]["addressInfo"].stringValue
        }else{
            addressTitle.text = nowDataArr[indexPath.row].addressName!
            addressDetail.text = nowDataArr[indexPath.row].addressDetail!
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isMyAddress{
            let nowcor = CLLocationCoordinate2D(latitude: addressList[indexPath.row]["lat"].doubleValue, longitude: addressList[indexPath.row]["lon"].doubleValue)
            delegate?.addressChose(coordinate: nowcor, addressInfo: addressList[indexPath.row]["address"].stringValue)
        }else{
            delegate?.addressChose(coordinate: nowDataArr[indexPath.row].Coordinate2D!, addressInfo: nowDataArr[indexPath.row].addressName!)
        }
        self.backPage()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != ""{
            let searchMapRequest = AMapPOIKeywordsSearchRequest()
            searchMapRequest.keywords = textField.text!
            searchMapRequest.requireExtension = true
            if self.cityName == ""{
                searchMapRequest.city = "成都"
            }else{
                searchMapRequest.city = self.cityName
            }
            
            searchMapRequest.cityLimit = true
            searchMapRequest.requireSubPOIs = true
            searchMap.aMapPOIKeywordsSearch(searchMapRequest)
        }
        
        
        return true
    }
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.count == 0 {
            return
        }
        //清除之前的内容
        self.nowDataArr = []
        for item in response.pois{
            print(item.district)
            print(item.location)
            let addressmod = AddressModel()
            addressmod.addressDetail = item.city + item.district
            addressmod.addressName = item.address
            
            let nowcor = CLLocationCoordinate2D(latitude: Double(item.location.latitude), longitude: Double(item.location.longitude))
            
            addressmod.Coordinate2D = nowcor
            self.nowDataArr.append(addressmod)
        }
        self.addressTable.reloadData()
        
        //解析response获取POI信息，具体解析见 Demo
    }
    
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        
    }
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        //定位失败
        self.myNoticeError(title: "定位失败，请确认是否授权")
    }
    override func viewDidAppear(_ animated: Bool) {
        self.noticeOnlyText("定位中，请稍后...")
        self.locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            self.clearAllNotice()
            guard error == nil else{
                print(error!)
                return
            }
            
            guard regeocode != nil else{
                return
            }
            
            guard location != nil else{
                self.myNoticeError(title: "定位失败")
                return
            }
//            self.nowLocation = location!.coordinate
            print(location!.coordinate.latitude)
            print(location!.coordinate.longitude)
//            街道信息
            if let address = regeocode?.district{
                self.streetInfo = address
            }
            if let street = regeocode?.street{
                self.streetInfo += street
            }
            if let city = regeocode?.city{
                self.cityName = city
            }
            if let city = regeocode?.city, let neighborhood = regeocode!.neighborhood{
                let addressmod = AddressModel()
                addressmod.addressDetail = self.streetInfo
                addressmod.addressName = city + neighborhood
                addressmod.Coordinate2D = location!.coordinate
                self.nowDataArr.append(addressmod)
            }
            
            if let poiName = regeocode?.poiName{
                let addressmod = AddressModel()
                addressmod.addressDetail = self.streetInfo
                addressmod.addressName = poiName
                addressmod.Coordinate2D = location!.coordinate
                self.nowDataArr.append(addressmod)
            }
            
            if let aoiName = regeocode?.aoiName{
                let addressmod = AddressModel()
                addressmod.addressDetail = self.streetInfo
                addressmod.addressName = aoiName
                addressmod.Coordinate2D = location!.coordinate
                self.nowDataArr.append(addressmod)
            }
            
            if let street = regeocode?.street, let number = regeocode!.number{
//                self.nowDataArr.append(street + number)
                let addressmod = AddressModel()
                addressmod.addressDetail = self.streetInfo
                addressmod.addressName = street + number
                addressmod.Coordinate2D = location!.coordinate
                self.nowDataArr.append(addressmod)

            }
            
            self.addressTable.reloadData()
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
