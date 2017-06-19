//
//  Methods.swift
//  SourceOfFruit
//
//  Created by 马志敏 on 2016/12/27.
//  Copyright © 2016年 DEC.MA. All rights reserved.
//

import UIKit
import SDWebImage
import AliyunOSSiOS
//import b

class Methods: NSObject {
    var locationManager : AMapLocationManager?
    func getAddressInfoBy(succesce:@escaping (_ value:(String,CLLocation)?)->(Void)){
//        AMapLocations
//        AMapServices.shared().apiKey = gaodeMapAppkey
        locationManager = AMapLocationManager()
        locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager!.locationTimeout = 2
        locationManager!.reGeocodeTimeout = 2
        locationManager!.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            guard error == nil else{
                print(error!)
                succesce(nil)
                return
            }
            
            guard regeocode != nil else{
                succesce(nil)
                return
            }
            
            guard location != nil else{
                succesce(nil)
                //self.myNoticeError(title: "定位失败")
                return
            }
            
            //            街道信息
            if let address = regeocode?.district,let street = regeocode?.street,let loca = location{
                
//                streetInfo = (address + street,loca)
                succesce((address + street,loca))
            }
            
        }
    }
    //造lab
    func creatLabel(lab:UILabel,x:CGFloat,y:CGFloat,wid:CGFloat,hei:CGFloat,textString:String,textcolor:UIColor,textFont:CGFloat,superView:UIView) {
        lab.frame = CGRect(x: x, y: y, width: wid, height: hei)
        lab.text = textString
        lab.textColor = textcolor
        lab.font = UIFont.systemFont(ofSize: textFont)
        superView.addSubview(lab)
    }
    func isLogin()->Bool{
        if let _=MyUserInfo.value(forKey: userInfoKey.userID.rawValue){
            return true
        }else{
            
            return false
        }
    }
    func uploadImage(imgData:Data)->String{
//        OSS外网域名: leyidian.oss-cn-shanghai.aliyuncs.com
//        OSS内网域名: leyidian.oss-cn-shanghai-internal.aliyuncs.com
        let credential = OSSPlainTextAKSKPairCredentialProvider(plainTextAccessKey: aliyunOssKeyID, secretKey: aliyunOssKeySecret)
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 30
        conf.timeoutIntervalForResource = 36000
        
        let client = OSSClient(endpoint: "http://oss-cn-shanghai.aliyuncs.com", credentialProvider: credential, clientConfiguration: conf)
        let put = OSSPutObjectRequest()
        put.bucketName = aliyunOssBuckName
        let userid = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as! String
        
        put.objectKey = (aliyunOssBuckName + userid + getNowTime()).md5() + "\(arc4random())"

//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let filepath = (paths[0] as NSString).appendingPathComponent("headImg.png")
//        put.uploadingFileURL = URL(fileURLWithPath: filepath)
        put.uploadingData = imgData
        put.contentType = "png"
        let putTask = client!.putObject(put)
        //等待完成
//        putTask!.waitUntilFinished()
        print("http://leyidian.oss-cn-shanghai.aliyuncs.com/"+put.objectKey)
        if putTask!.error != nil{
            print("loadimagefield")
            return ""
        }else{
            print("loadimgsuccess")
            return "http://leyidian.oss-cn-shanghai.aliyuncs.com/"+put.objectKey
        }
        
//        putTask!.continue({ (task:OSSTask) -> Any? in
//            if task.error != nil{
//                print("loadimagefield")
//            }else{
//                print("loadimgsuccess")
//            }
//            return nil
//        })
    }
    //造btn
    func creatButton(btn:UIButton,x:CGFloat,y:CGFloat,wid:CGFloat,hei:CGFloat,title:String,titlecolor:UIColor,titleFont:CGFloat,bgColor:UIColor,superView:UIView) {
        btn.frame = CGRect(x: x, y: y, width: wid, height: hei)
        btn.setTitle(title, for: UIControlState.normal)
        btn.setTitleColor(titlecolor, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
        btn.backgroundColor = bgColor
        superView.addSubview(btn)
    }
    
    //img
    func creatImage(img:UIImageView,x:CGFloat,y:CGFloat,wid:CGFloat,hei:CGFloat,imgName:String,imgMode:UIViewContentMode,superView:UIView) {
        img.frame = CGRect(x: x, y: y, width: wid, height: hei)
        img.contentMode = imgMode
        img.image = UIImage(named: imgName)
        superView.addSubview(img)
    }
    func loadImage(imgUrl:String,Img_View:UIImageView){
        if let url = URL(string: imgUrl){
            Img_View.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImg"))
        }else{
            Img_View.image = UIImage(named: "defaultImg")
        }
//        Img_View.contentMode = .scaleAspectFill
        Img_View.clipsToBounds = true
    }
    func loadImageWithDefault(imgUrl:String,Img_View:UIImageView,defaultImage:String){
        if let url = URL(string: imgUrl){
            Img_View.sd_setImage(with: url, placeholderImage: UIImage(named: defaultImage))
        }else{
            Img_View.image = UIImage(named: defaultImage)
        }
        //        Img_View.contentMode = .scaleAspectFill
        Img_View.clipsToBounds = true
    }
    func drawLine(startX:CGFloat,startY:CGFloat,wid:CGFloat,hei:CGFloat,add:UIView){
        let leftLine = CALayer()
        leftLine.frame = CGRect(x: startX, y: startY, width: wid, height: hei)
        leftLine.backgroundColor = setMyColor(r: 239, g: 240, b: 241, a: 1).cgColor
        add.layer.addSublayer(leftLine)
    }
    func drawLineWithColor(startX:CGFloat,startY:CGFloat,wid:CGFloat,hei:CGFloat,lineColor:UIColor,add:UIView){
        let leftLine = CALayer()
        leftLine.frame = CGRect(x: startX, y: startY, width: wid, height: hei)
        leftLine.backgroundColor = lineColor.cgColor
        add.layer.addSublayer(leftLine)
    }
//    检测某个数组里是否存在某个元素
    func isItemInArray(item:String,arr:[String]) -> Bool {
        for i in arr{
            if i == item{//存在则返回true
                return true
            }
        }
        return false
    }
    //判断商品是否为限时活着折扣
    func hasStringInArr(arrStr:String)->Bool{
        if arrStr == ""{
            return false
        }
        let arr = arrStr.components(separatedBy: ",")
        if isItemInArray(item: "X", arr: arr) || isItemInArray(item: "Z", arr: arr){
            return true
        }else{
            return false
        }
        
    }
    func removeItemFromArr(item:String,arr:[String])->[String] {
        var newArr = arr
        for i in 0..<arr.count{
            if arr[i] == item{
                newArr.remove(at: i)
                break
            }
        }
        return newArr
    }
    //添加商品到购物车
    func addTocar(goodId:String,norm:String,isSuccesce:@escaping (_ value:Bool)->(Void)){
        if !isLogin(){
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    SwiftNotice.clear()
                    SwiftNotice.showNoticeWithText(NoticeType.error, text: "当前未登录", autoClear: true, autoClearTime: 1)
                }
            }
        }else{
            HttpTool.shareHttpTool.Http_AddGoodsToCar(goodsId: goodId, count:1, norm: norm) { (data) in
                print(data)
                if data["code"].stringValue == "SUCCESS"{
                    isSuccesce(true)
                }else{
                    isSuccesce(false)
                }
            }
        }
        
    }
    //非购物车页面，减少商品数量到购物车
    func cutFromcar(goodsId:String,isSuccesce:@escaping (_ value:Bool)->(Void)){
        if !isLogin(){
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    SwiftNotice.clear()
                    SwiftNotice.showNoticeWithText(NoticeType.error, text: "当前未登录", autoClear: true, autoClearTime: 1)
                }
            }
        }else{
            HttpTool.shareHttpTool.Http_CutGoodsFromCar(goodsId: goodsId,detailsID:"") { (data) in
                print(data)
                if data["code"].stringValue == "SUCCESS"{
                    isSuccesce(true)
                }else{
                    isSuccesce(false)
                }
            }
        }
    }
    func getRemarkStr(addressType:String)->String{
        var str = ""
        if addressType == "H"{
            str = "家"
        }else if addressType == "C"{
            str = "公司"
        }
        return str
    }
    func callTelphone(phoneNo:String){//打电话
        let url = NSURL(string: "tel://\(phoneNo)")
        UIApplication.shared.openURL(url as! URL)
        
    }
    func getStatusName(type:orderTypeEnum)->String{
//        case waitPay        = "0"//待付款
//        case paid           = "1"//待收货
//        case send           = "2"//待发货
//        case waitEnv        = "3"//待评价 已签收
//        case finish         = "4"//已完成
//        case cancle         = "5"//已取消
//        case refund         = "9"//退款中
//        case refunded       = "7"//已退款
//        case refundFaild    = "10"//退款失败
//        case allOrder       = "100"//
        switch type {
        case orderTypeEnum.waitPay:
            return "待付款"
        case orderTypeEnum.paid:
            return "待配送"
        case orderTypeEnum.send:
            return "待签收"
        case orderTypeEnum.waitEnv:
            return "待评价"
        case orderTypeEnum.finish:
            return "已完成"
        case orderTypeEnum.cancle:
            return "已取消"
        case orderTypeEnum.refund:
            return "退款中"
        case orderTypeEnum.arrived:
            return "待签收"
        case orderTypeEnum.refunded:
            return "已退款"
        case orderTypeEnum.refundFaild:
            return "退款失败"
        default:
            return "状态未知"
        }
    }
    //0待付款 1 已付款 2 已发货 3 已签收 4 已完成 5 取消 6 申请退款 7 已退款）
    //        case waitPay        = "0"//待付款
    //        case paid           = "1"//待收货
    //        case send           = "2"//待发货
    //        case waitEnv        = "3"//待评价 已签收
    //        case finish         = "4"//已完成
    //        case cancle         = "5"//已取消
    //        case refund         = "9"//退款中
    //        case refunded       = "7"//已退款
    //        case refundFaild    = "10"//退款失败
    //        case allOrder       = "100"//
    func statusConvert(status:String)->orderTypeEnum{
        switch status {
        case "0":
            return orderTypeEnum.waitPay
        case "1":
            return orderTypeEnum.paid
        case "2":
            return orderTypeEnum.send
        case "3":
            return orderTypeEnum.waitEnv
        case "4":
            return orderTypeEnum.finish
        case "5":
            return orderTypeEnum.cancle
        case "6":
            return orderTypeEnum.arrived
        case "9":
            return orderTypeEnum.refund
        case "7":
            return orderTypeEnum.refunded
        case "10":
            return orderTypeEnum.refundFaild
        default:
            return orderTypeEnum.allOrder
        }
    }
    //计算两点之间的距离
//    func distanceBetweenOrderBy(lat1:Double,lng1:Double,lat2:Double,lng2:Double) -> Double {
////                      BMKOpenTransitRouteOptionalloc
////        let bmkopen = BMKOpenTransitRouteOption()
//        let curlocation = CLLocation(latitude: lat1, longitude: lng1)
//        let anotherlocation = CLLocation(latitude: lat2, longitude: lng2)
//        let distance = curlocation.distance(from: anotherlocation)
//        return distance
//    }
    //获取当前时间的时分并转化
    func getNowTime()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = NSDate()
        let nowStr = formatter.string(from: now as Date)
        return nowStr
    }
    func convertTime(time:Double)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: time/1000)
        let timeStr = formatter.string(from: date as Date)
        return timeStr
    }
    func convertTimeYMD(time:Double)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let date = NSDate(timeIntervalSince1970: time/1000)
        let timeStr = formatter.string(from: date as Date)
        return timeStr
    }
    func getNowTimeStamp()->Int{
        let now = NSDate()
        print(now)
//        NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
        let timestamp = now.timeIntervalSince1970
//        print(Int(timestamp))
        return Int(timestamp)
        
    }
    func getGoodsActiveType(types:String)->String{
        let arr = types.components(separatedBy: ",")
        print(arr)
        if isItemInArray(item: ActivitieGoods.Timelimit.rawValue, arr: arr) || isItemInArray(item: ActivitieGoods.BargainPrice.rawValue, arr: arr){
            return ActivitieGoods.BargainPrice.rawValue
        }else if isItemInArray(item: ActivitieGoods.PreferredGoods.rawValue, arr: arr){
            return ActivitieGoods.PreferredGoods.rawValue
        }else  if isItemInArray(item: ActivitieGoods.Recommend.rawValue, arr: arr){
            return ActivitieGoods.Recommend.rawValue
        }else{
            return ""
        }
    }
    func isLoginApp()->Bool{
        if let _ = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as? String{
            return true
        }else{
            return false
        }
    }
}

