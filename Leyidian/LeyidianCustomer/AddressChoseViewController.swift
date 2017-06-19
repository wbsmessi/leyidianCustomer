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
class AddressChoseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DECChoseAlertViewDelegate,AMapSearchDelegate,MAMapViewDelegate {

    var method = Methods()
    var showMyAddress:Bool = true
    var locationManager:AMapLocationManager!
    var delegate:AddressChoseDelegate?
    var nowLocation:CLLocationCoordinate2D!
    var nowDataArr:[AddressModel] = []
    var streetInfo:String = ""
//    搜索
    //后台返回的城市数据。
    var cityArr:[String] = []
    //当前选择的城市显示
    var cityName:String = ""{
        didSet{
            DispatchQueue.main.async {
                self.cityNameTite.setTitle(self.cityName, for: .normal)
                self.cityNameTite.setImage(UIImage(named:"jiantou-up"), for: .normal)
                self.cityNameTite.titleEdgeInsets = UIEdgeInsets(top: 0, left: -self.cityNameTite.imageView!.frame.width, bottom: 0, right: self.cityNameTite.imageView!.frame.width)
                self.cityNameTite.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.cityNameTite.titleLabel!.frame.width, bottom: 0, right: -self.cityNameTite.titleLabel!.frame.width)
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
        HttpTool.shareHttpTool.Http_getAddressList(storeID: "") { (data) in
            print(data)
            self.addressList = data.arrayValue
        }
//        cityArr 
        HttpTool.shareHttpTool.Http_getCityList { (data) -> (Void) in
            print(data)
            for item in data["resultData"].arrayValue{
                self.cityArr.append(item["city"].stringValue)
            }
        }
    }
//    顶部城市名字
    let cityNameTite = UIButton()
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
    var mapView:MAMapView!
    
    var alertView:DECChoseAlertView!
    func creatView(){
        
//        cityNameLab.textAlignment = .center
//        method.creatLabel(lab: cityNameLab, x: app_width/3, y: 30, wid: app_width/3, hei: 30, textString: "", textcolor: UIColor.black, textFont: 18, superView: self.view)
        method.creatButton(btn: cityNameTite, x: app_width/3, y: 30, wid: app_width/3, hei: 30, title: "", titlecolor: myAppBlackColor(), titleFont: 18, bgColor: UIColor.clear, superView: self.view)
        cityNameTite.addTarget(self, action: #selector(cityChose), for: .touchUpInside)
//        self.requestLocation()
        
        mapView = MAMapView(frame: CGRect(x: 0, y: 64, width: app_width, height: app_height/2-nav_height))
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 15
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        let dingweiIcon = UIImageView(image: UIImage(named: "dingweichose"))
        dingweiIcon.frame = CGRect(x: app_width/2 - 20, y: mapView.frame.height/2 - 20, width: 40, height: 40)
        dingweiIcon.contentMode = .scaleAspectFill
        mapView.addSubview(dingweiIcon)
        
        locationManager = AMapLocationManager()
        locationManager.locationTimeout = 2
        self.locationManager.reGeocodeTimeout = 2
        
        
        let request = AMapReGeocodeSearchRequest()
//        request.location = AMapGeoPoint.location(withLatitude: <#T##CGFloat#>, longitude: <#T##CGFloat#>)
//        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
        
        
        method.creatButton(btn: myAddressBtn, x: 0, y: mapView.bottomPosition(), wid: app_width/2, hei: showMyAddress ? 40:0, title: showMyAddress ? "我的地址":"", titlecolor: UIColor.black, titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        myAddressBtn.setImage(UIImage(named:"dizhi_hui"), for: .normal)
        myAddressBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myAddressBtn.titleLabel!.frame.width)
        myAddressBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: myAddressBtn.imageView!.frame.width, bottom: 0, right: 0)
        myAddressBtn.addTarget(self, action: #selector(myAddressBtnClick), for: .touchUpInside)
        
        method.creatButton(btn: nowAddressBtn, x: app_width/2, y: mapView.bottomPosition(), wid: app_width/2, hei: showMyAddress ? 40:0, title: showMyAddress ? "定位当前地址":"", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        nowAddressBtn.setImage(UIImage(named:"dingwei_huang"), for: .normal)
        nowAddressBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: nowAddressBtn.titleLabel!.frame.width)
        nowAddressBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: nowAddressBtn.imageView!.frame.width, bottom: 0, right: 0)
        nowAddressBtn.addTarget(self, action: #selector(nowAddressBtnClick), for: .touchUpInside)
        nowAddressBtn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        
        method.drawLine(startX: 0, startY: nowAddressBtn.bottomPosition(), wid: app_width, hei: 0.6, add: self.view)
        method.drawLine(startX: app_width/2, startY: nowAddressBtn.frame.origin.y, wid: 0.6, hei: 40, add: self.view)
        
        
        addressTable.frame = CGRect(x: 0, y: myAddressBtn.bottomPosition()+1, width: app_width, height: app_height - myAddressBtn.bottomPosition())
        addressTable.delegate = self
        addressTable.rowHeight = 55
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
        
        alertView = DECChoseAlertView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height), arr: [])
        alertView.delegate = self
        self.view.addSubview(alertView)
    }
    
    func cityChose(){
        if cityArr.count > 0 {
            self.alertView.titleArr = [cityArr]
            alertView.animationHideOrNot(hide: false)
        }
        
    }
    func DECChoseAlert(title:String){
        self.cityName = title
        searchBykeywords(word: title)
    }
    func myAddressBtnClick() {
        //还原
        nowAddressBtn.setTitleColor(UIColor.black, for: .normal)
        nowAddressBtn.setImage(UIImage(named:"dingwei_hui"), for: .normal)
        nowAddressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //选中色
        myAddressBtn.setTitleColor(MyAppColor(), for: .normal)
        myAddressBtn.setImage(UIImage(named:"dizhi_huang"), for: .normal)
        myAddressBtn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        isMyAddress = true
    }
    func nowAddressBtnClick() {
        //还原
        myAddressBtn.setTitleColor(UIColor.black, for: .normal)
        myAddressBtn.setImage(UIImage(named:"dizhi_hui"), for: .normal)
        myAddressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //选中色
        nowAddressBtn.setTitleColor(MyAppColor(), for: .normal)
        nowAddressBtn.setImage(UIImage(named:"dingwei_huang"), for: .normal)
        nowAddressBtn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
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
        method.creatLabel(lab: addressDetail, x: 20, y: addressTitle.bottomPosition()+5, wid: addressTitle.frame.width, hei: 15, textString: "", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
        
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
    //关键字搜索查询
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.text != ""{
            searchBykeywords(word: textField.text!)
        }
        
        return true
    }
    func searchBykeywords(word:String){
        let searchMapRequest = AMapPOIKeywordsSearchRequest()
        searchMapRequest.keywords = word
        searchMapRequest.requireExtension = true
        if self.cityName == ""{
            searchMapRequest.city = ""
        }else{
            searchMapRequest.city = self.cityName
        }
        
        searchMapRequest.cityLimit = true
        searchMapRequest.requireSubPOIs = true
        searchMap.aMapPOIKeywordsSearch(searchMapRequest)
    }
//    关键字搜索查询结果
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.count == 0 {
            return
        }
//        AMapGeoPoint
        _=response.pois[0].location.latitude
        let center = CLLocationCoordinate2D(latitude: Double(response.pois[0].location.latitude), longitude: Double(response.pois[0].location.longitude))
        mapView.setCenter(center, animated: true)
        //清除之前的内容
//        self.nowDataArr = []
//        for item in response.pois{
//            print(item.district)
//            print(item.location)
//            let addressmod = AddressModel()
//            addressmod.addressDetail = item.city + item.district
//            addressmod.addressName = item.name
//            
//            let nowcor = CLLocationCoordinate2D(latitude: Double(item.location.latitude), longitude: Double(item.location.longitude))
//            
//            addressmod.Coordinate2D = nowcor
//            self.nowDataArr.append(addressmod)
//        }
//        self.addressTable.reloadData()
        
    }
    
//    经纬度搜索查询
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        print(mapView.region.center)
        
        let searchMapRequest = AMapReGeocodeSearchRequest()
        
        let point = AMapGeoPoint()
        point.latitude = CGFloat(mapView.region.center.latitude)
        point.longitude = CGFloat(mapView.region.center.longitude)
        searchMapRequest.location = point
        searchMapRequest.requireExtension = true
        searchMap.aMapReGoecodeSearch(searchMapRequest)
        
    }
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        
    }
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print(error)
        print(error.localizedDescription)
    }
//    reverseGeocodeLocation
    
//    经纬度搜索查询结果
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
//        print("经纬度搜索de 查询结果")
        //清除之前的内容
        self.nowDataArr = []
        
        if response.regeocode.addressComponent.city != ""{
            self.cityName = response.regeocode.addressComponent.city
        }
        for item in response.regeocode.pois{
//             print(item.formattedDescription() + "formar")
            let addressmod = AddressModel()
            addressmod.addressDetail = item.address
            addressmod.addressName = item.name
            
            let nowcor = CLLocationCoordinate2D(latitude: Double(item.location.latitude), longitude: Double(item.location.longitude))
            
            addressmod.Coordinate2D = nowcor
            self.nowDataArr.append(addressmod)
        }
        self.addressTable.reloadData()
    }
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        
    }
    
    
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        //定位失败
        self.myNoticeError(title: "定位失败，请确认是否授权")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        self.noticeOnlyText("定位中，请稍后...")
        /*self.locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            self.clearAllNotice()
            guard error == nil else{
                print(error!)
                return
            }
            
            guard regeocode != nil else{
                return
            }
            
            guard location != nil else{
//                self.myNoticeError(title: "定位失败")
                return
            }
            if let city = regeocode?.city{
                DispatchQueue.main.async {
                    self.cityName = city
                }
                
            }
            
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
 */
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
