//
//  HttpTool.swift
//  SourceOfFruit
//
//  Created by 马志敏 on 2016/12/27.
//  Copyright © 2016年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Just
//import AFNetworking

class HttpTool: NSObject {
    //单例
    static let shareHttpTool = HttpTool()
    var DESKeyPwd = "tZfcZjB="
//    正式密钥：tZfcZjB=
//    随机向量：iv = { 12, 22, 32, 43, 51, 64, 57, 98 }
    var UserId:String{
        let token = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as? String
        return token ?? ""
    }
//    地址
    
    func noticeError(title:String){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.error, text: title, autoClear: true, autoClearTime: 1)
            }
        }
        
        
    }
    func noticeSuccess(title:String){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.success, text: title, autoClear: true, autoClearTime: 1)
            }
        }
        
        
    }
    func cleaAllNotice(){
        DispatchQueue.main.async {
            SwiftNotice.clear()
        }
    }
    //    无数据或者网络不畅通的提示
    func noticeNoData(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                SwiftNotice.clear()
                SwiftNotice.showNoticeWithText(NoticeType.error, text: "暂无数据", autoClear: true, autoClearTime: 1)
            }
        }
    }
    func loadingStatus(){
        DispatchQueue.main.async {
            SwiftNotice.clear()
            SwiftNotice.wait()
//            SwiftNotice.showText("加载中...")
        }
    }
    //des加密
    func getDesKey(param:String)->String{
        //先转一次url，防止中文
        var keyStr = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //数据des加密
        keyStr = DES.encryptUse(keyStr, key: DESKeyPwd)
        //特殊字符转码
        keyStr = DES.encode(keyStr)
        return keyStr!
    }
    //des解密
    func desToData(desStr:String)->JSON?{
        var json:JSON?
//        print(desStr)
        if let keyStr = DES.decryptUse(desStr, key: DESKeyPwd){
            let data = (keyStr).data(using: .utf8)
            do{
                let jsonDic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                let dic = JSON(jsonDic)
                json = dic
            }catch{
                //
            }
        }
        
        return json
    }
    /**注册*/
//    phone	是	string	用户名
//    validCode	是	string	短信验证码
//    password	是	string	密码
//    inviteCode	是	string	邀请码
    func Http_Register(phone:String,validCode:String,password:String,inviteCode:String,succesce:@escaping (_ value:JSON)->(Void)) {
        Just.post(
            headerUrl + getDesKey(param: "/user/registeredUser?phone=\(phone)&validCode=\(validCode)&password=\(password.md5()!)&inviteCode=\(inviteCode)")
        ) { result in
            self.cleaAllNotice()
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            if let jsondata = self.desToData(desStr: json["resultData"].stringValue){
                json["resultData"] = jsondata
                self.cleaAllNotice()
                succesce(json)
            }
            
        }
    }
    /**登录*/
    func Http_Sign(phone:String,pwd:String,succesce:@escaping (_ value:JSON)->(Void)) {
        Just.post(
            headerUrl + getDesKey(param: "/user/userLogin.api?phone=\(phone)&password=\(pwd.md5()!)")
        ) { result in
            print(result)
            self.cleaAllNotice()
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
            self.cleaAllNotice()
            succesce(json)
        }
    }
    /**短信登录*/
//    user/smsUserLogin
//    phone
//    validCode
    func Http_smsSign(phone:String,validCode:String,succesce:@escaping (_ value:JSON)->(Void)) {
        Just.post(
            headerUrl + getDesKey(param: "/user/smsUserLogin?phone=\(phone)&validCode=\(validCode)")
        ) { result in
            print(result)
            self.cleaAllNotice()
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
            self.cleaAllNotice()
            succesce(json)
        }
    }
//    /user/resetPassword
//    phone	是	string	手机号
//    password	是	string	密码
//    validCode	是	string	验证码
    func Http_resetPwd(phone:String,validCode:String,password:String,succesce:@escaping (_ value:JSON)->(Void)) {
        Just.post(
            headerUrl + getDesKey(param: "/user/resetPassword?phone=\(phone)&validCode=\(validCode)&password=\(password.md5()!)")
        ) { result in
            print(result)
            self.cleaAllNotice()
            guard result.ok else{
                self.noticeNoData()
                return
            }
            print(result.json)
            let json = JSON(result.json!)
//            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
            self.cleaAllNotice()
            succesce(json)
        }
    }
    //重置密码
    ///userApp/hotWords
//    搜索热词
    func Http_getHotWords(succesce:@escaping (_ value:JSON)->(Void)) {
        //        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/user/hotWords")
        ) { result in
            //print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            let json = JSON(result.json!)
            guard json["code"].stringValue == "SUCCESS" else{
                self.noticeError(title: json["msg"].stringValue)
                return
            }
            if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                //                self.cleaAllNotice()
                succesce(jsonData)
            }else{
                //                self.noticeNoData()
            }
            
        }
    }
//    /user/authLogin
//    授权登录
//    nickName	是	string	昵称
//    openID	是	string	外部唯一标识
//    headUrl	是	string	头像
//    sex	是	string	性别
//    authType	是	string	授权类型（q qq W 微信）
    func Http_Sign(nickName:String,openID:String,headUrl:String,sex:String,authType:String,succesce:@escaping (_ value:JSON)->(Void)) {
        Just.post(
            headerUrl + getDesKey(param: "/user/authLogin?nickName=\(nickName)&openID=\(openID)&headUrl=\(headUrl)&sex=\(sex)&authType=\(authType)")
        ) { result in
            print(result)
            self.cleaAllNotice()
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
            self.cleaAllNotice()
            succesce(json)
        }
    }
//    /user/cityList
//    获取开通城市
    func Http_getCityList(succesce:@escaping (_ value:JSON)->(Void)) {
        Just.post(
            headerUrl + getDesKey(param: "/user/cityList")
        ) { result in
            print(result)
            self.cleaAllNotice()
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
            self.cleaAllNotice()
            succesce(json)
        }
    }
    //获取门店类型信息
    func Http_getShopType(succesce:@escaping (_ value:JSON)->(Void)) {
//        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/user/getStoreType")
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            let json = JSON(result.json!)
            guard json["code"].stringValue == "SUCCESS" else{
                self.noticeError(title: json["msg"].stringValue)
                return
            }
            if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                self.cleaAllNotice()
                succesce(jsonData)
            }else{
//                self.noticeNoData()
            }
        }
    }
//    /user/noticeNum
    //获取消息数量
//    externalID	是	int	外部ID
//    externalType	是	String	U 用户 S 店铺
    func Http_getNoticeNum(succesce:@escaping (_ value:JSON)->(Void)) {
        //        loadingStatus()
        if let userid = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as? String{
            Just.post(
                headerUrl + getDesKey(param: "/user/noticeNum?externalID=\(userid)&externalType=U")
            ) { result in
                guard result.ok else{
                    self.noticeNoData()
                    return
                }
//                print(result.json)
                if let value = result.json{
                    var json = JSON(value)
                    //                print(json)
                    guard json["code"].stringValue == "SUCCESS" else{
                        self.noticeError(title: json["msg"].stringValue)
                        return
                    }
                    
                    if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                        //                self.cleaAllNotice()
                        json["resultData"] = jsonData
                        succesce(json)
                    }else{
                        
                    }
                }
            }
        }
    }
    //    /user/noticeList
    //    平台公告列表
//    noticeType	是	string	类型（P 平台公告 S 系统消息）
//    externalID	是	int	外部ID（用户端就传userID 店铺就传storeID）
//    externalType	是	string	类型（U 用户端 S 店铺端）
//    startIndex	是	int	起始页
//    rows	是	int	行数
    func Http_getNoticeList(noticeType:String,startIndex:Int,succesce:@escaping (_ value:JSON)->(Void)) {
        //        loadingStatus()
        if let userid = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as? String{
            var url = "/user/noticeList?externalID=\(userid)&startIndex=\(startIndex)&noticeType=\(noticeType)&rows=20&externalType=U"
            if noticeType == "P"{
                url = "/user/noticeList?startIndex=\(startIndex)&noticeType=\(noticeType)&rows=20&"
            }
            Just.post(
                headerUrl + getDesKey(param: url)
            ) { result in
                print(result)
                guard result.ok else{
                    self.noticeNoData()
                    return
                }
                var json = JSON(result.json!)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    //                self.cleaAllNotice()
                    json["resultData"] = jsonData
                    succesce(json)
                }else{
                    
                }
            }
        }
    }
    //    /user/noticeList
    //    平台公告列表
//    func Http_getSystemNoticeList(succesce:@escaping (_ value:JSON)->(Void)) {
//        //        loadingStatus()
//        if let userid = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as? String{
//            Just.post(
//                headerUrl + getDesKey(param: "/user/noticeList")
//            ) { result in
//                guard result.ok else{
//                    self.noticeNoData()
//                    return
//                }
//                var json = JSON(result.json!)
//                guard json["code"].stringValue == "SUCCESS" else{
//                    self.noticeError(title: json["msg"].stringValue)
//                    return
//                }
//                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                    //                self.cleaAllNotice()
//                    json["resultData"] = jsonData
//                    succesce(json)
//                }else{
//                }
//                
//            }
//        }
//        
//    }
    //获取首页信息
//    lon	是	double	经度
//    lat	是	double	纬度
//    storeType	否	String	店铺类型
//    userID	否	int	用户ID
    func Http_getHomePageInfo(storeType:String,lon:String,lat:String,succesce:@escaping (_ value:JSON?)->(Void)) {
//        print(headerUrl + getDesKey(param: "/user/indexPage?lon=\(lon)&lat=\(lat)"))
//        loadingStatus()
        var url = "/user/indexPage?lon=\(lon)&lat=\(lat)&storeType=\(storeType)"
        if let userid = MyUserInfo.value(forKey: userInfoKey.userID.rawValue) as? String{
            url += "&userID=\(userid)"
        }
        print(url)
        Just.post(
            headerUrl + getDesKey(param: url)
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                print(json)
                if json["code"].stringValue == "SUCCESS"{
                    if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                        self.cleaAllNotice()
                        succesce(jsonData)
                    }else{
                        self.noticeNoData()
                    }
                }else{
//                    self.noticeError(title: json["msg"].stringValue)
                    succesce(json)
                }
                
            }else{
                succesce(nil)
//                let json = JSON(result.json)
            }
            
        }
    }
    //获取首页四大活动商品
//    storeID	是	string
//    userID	否	string
//    startIndex	是	int	起始页
//    classifyID
//    rows	是	int	行数
//    type	是	string	商品类型（（Y 优选精品 X 限时抢购 Z 折扣特价 R 掌柜推荐）

    func Http_ActiveGoods(startIndex:Int,type:String,classifyID:String,succesce:@escaping (_ value:JSON)->(Void)) {
        
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/user/getActivityCommodity?storeID=\(storeInfomation!.storeID!)&userID=\(UserId)&startIndex=\(startIndex)&rows=20&type=\(type)&classifyID=\(classifyID)")
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
    //获取分类
    func Http_GoodsCategory(succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/classifyapp/classifyList")
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
            
        }
    }
//    /appraiseApp/storeAppraise
//    获取商家评分
    func Http_StoreEnvlotion(succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        Just.post(
            headerUrl + getDesKey(param: "/appraiseApp/storeAppraise?storeID=\(storeInfomation!.storeID!)")
        ) { result in
            //            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
            
        }
    }
//    评论列表
//    /appraiseApp/appraiseList
    func Http_EnvlotionList(startIndex:Int,rows:Int,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        Just.post(
            headerUrl + getDesKey(param: "/appraiseApp/appraiseList?storeID=\(storeInfomation!.storeID!)&startIndex=\(startIndex)&rows=\(rows)")
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
            
        }
    }
//    商品搜索
//    /user/searchCommodity
//    searchText	是	string	搜索内容
//    storeID	是	int	店铺ID
//    startIndex	是	int	分页起始页 0开始
//    rows	是	int	行数
//    userID	否	int	用户ID
    func Http_goodsSearch(startIndex:Int,searchText:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        
        Just.post(
            headerUrl + getDesKey(param: "/user/searchCommodity?storeID=\(storeInfomation!.storeID!)&startIndex=\(startIndex)&rows=15&searchText=\(searchText)&userID=\(UserId)")
        ) { result in
            //            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
            
        }
    }
    
//    user/getClassifyCommodity
//    参数名	必选	类型	说明
//    classifyID	是	int	分类ID
//    storeID	是	int	店铺ID
//    userID	否	int	用户ID
//    startIndex	是	int	起始页
//    rows	是	int	行数
//    sortType	否	int	排序类型（A 价格最低 B价格最高 C销量）
//    获取分类下的所有商品
    func Http_GetGoodsByCategory(classifyID:String,startIndex:Int,sortType:String,succesce:@escaping (_ value:JSON)->(Void)) {
//        print(headerUrl + getDesKey(param: "user/getClassifyCommodity"))
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        loadingStatus()
        print("/user/getClassifyCommodity?classifyID=\(classifyID)&storeID=\(storeInfomation!.storeID!)&userID=\(UserId)&startIndex=\(startIndex)&rows=16&sortType=\(sortType)")
        Just.post(
            headerUrl + getDesKey(param: "/user/getClassifyCommodity?classifyID=\(classifyID)&storeID=\(storeInfomation!.storeID!)&userID=\(UserId)&startIndex=\(startIndex)&rows=16&sortType=\(sortType)")
        ) { result in
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
//    /classifyapp/commodityInfo
//    获取商品详情
    func Http_GetGoodsInfo(goodsId:String,succesce:@escaping (_ value:JSON)->(Void)) {
        //        print(headerUrl + getDesKey(param: "user/getClassifyCommodity"))
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/classifyapp/commodityInfo?commodityID=\(goodsId)&storeID=\(storeInfomation!.storeID!)")
        ) { result in
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
//    /shopcar/getUserShopCart
//    查询购物车商品列表
    
    func Http_GetCarGoods(succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        Just.post(
            headerUrl + getDesKey(param: "/shopcar/getUserShopCart?userID=\(UserId)&storeID=\(storeInfomation!.storeID!)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            self.cleaAllNotice()
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
//                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                print(json)
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                    self.cleaAllNotice()
                    succesce(jsonData)
                }
            }
        }
    }

//    添加商品道购物车
//    userID	是	int	用户ID
//    storeID	是	int	店铺ID
//    commodityID	是	int	商品ID
//    num	是	int	添加数量（不能为0）
//    norm	否	String	商品规格
    func Http_AddGoodsToCar(goodsId:String,count:Int,norm:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        Just.post(
            headerUrl + getDesKey(param: "/shopcar/addCart?userID=\(UserId)&storeID=\(storeInfomation!.storeID!)&norm=\(norm)&commodityID=\(goodsId)&num=\(count)")
        ) { result in
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    MyUserInfo.setValue(jsonData["cartID"].stringValue, forKey: userdefaultKey.nowShopCarId.rawValue)
                    MyUserInfo.synchronize()
                    print(jsonData)
                }
                succesce(json)
                self.cleaAllNotice()
//                self.noticeSuccess(title: "添加成功")
                
            }
        }
    }
    //    从购物车删除商品
    func Http_DeleteGoodsFromCar(detailsID:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.get(
            headerUrl + getDesKey(param: "/shopcar/deleteCart?detailsIDs=\(detailsID)")
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                //删除成功后，更新下商品总数量
//                self.Http_GetCarGoods(succesce: { (data) in
////                    暂时不处理
//                })
                
                succesce(json)
                self.cleaAllNotice()
//                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                    self.cleaAllNotice()
//                    succesce(jsonData)
//                }else{
//                    self.noticeNoData()
//                }
            }
        }
    }
    //减少购物车商品数量
    func Http_CutGoodsFromCar(goodsId:String,detailsID:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        let carId = (MyUserInfo.value(forKey: userdefaultKey.nowShopCarId.rawValue) as? String) ?? ""
        var url = "/shopcar/removeCart?cartID=\(carId)&commodityID=\(goodsId)"
        if detailsID != ""{
            url = "/shopcar/removeCart?detailsID=\(detailsID)"
        }
        Just.get(
            headerUrl + getDesKey(param: url)
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                
                succesce(json)
                self.cleaAllNotice()
//                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                    self.cleaAllNotice()
//                    succesce(jsonData)
//                }else{
//                    self.noticeNoData()
//                }
            }
        }
    }
    
//    /orderApp/createOrder
//    detailsIDs	是	array	商品明细ID
//    userID	是	int	用户ID
//    storeID	是	int	店铺ID
//    ticketID	否	int	优惠券ID
//    addressID	是	int	收货地址ID
//    remark	否	String	订单备注
    
//    @param detailsIDs       commodityID 商品ID num 商品数量 norm 商品规格
//    * @param cartID                        购物车ID
//    * @param userID                        用户ID
//    * @param storeID                       店铺ID
//    * @param ticketID                      优惠券ID
//    * @param addressID                   收货地址ID
//    * @param remark
    
    func Http_CreateOrder(detailsIDs:[Int],addressID:String,cartID:String,ticketID:String,remark:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        Just.post(
            headerUrl + getDesKey(param: "/orderApp/createOrder?userID=\(UserId)&storeID=\(storeInfomation!.storeID!)&detailsIDs=\(detailsIDs)&addressID=\(addressID)&cartID=\(cartID)&ticketID=\(ticketID)&remark=\(remark)")
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                var json = JSON(data)
//                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    json["resultData"] = jsonData
                    succesce(json)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
    //    /orderApp/orderInfo
    //    订单详情
    func Http_OrderDetail(orderID:String,succesce:@escaping (_ value:JSON)->(Void)) {
        //        loadingStatus()
        
        let url = "/orderApp/orderInfo?orderID=\(orderID)"
        Just.get(
            headerUrl + getDesKey(param: url)
        ) { result in
            //            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
//    支付订单
//    /order/payOrder
//    参数名	必选	类型	说明
//    payType	是	string	支付方式（A 支付宝 W 微信）
//    userID	是	int	用户ID
//    orderID	是	int	订单ID
//    ticketID	否	int	优惠券ID
//    remark	否	string	订单备注
    
    func Http_ToPayOrder(payType:String,orderNo:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/orderApp/pay_param?payType=\(payType)&orderNo=\(orderNo)")
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                var json = JSON(data)
//                print(json)
                guard json["result_code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: "获取支付信息失败，请重试")
                    return
                }
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }

//    /orderApp/cancelOrder
//    取消订单
//    orderNo	是	string	订单号
//    remark	是	string	取消原因
//    cancelType   U  P
    func Http_CancelOrder(remark:String,orderNo:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/orderApp/cancelOrder?remark=\(remark)&orderNo=\(orderNo)&cancelType=U")
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                var json = JSON(data)
                //                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    签收订单
//    /orderApp/receipt
    func Http_Receipt(orderID:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/orderApp/receipt?orderID=\(orderID)")
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                var json = JSON(data)
                //                print(json)
//                guard json["code"].stringValue == "SUCCESS" else{
//                    self.noticeError(title: "")
//                    return
//                }
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    /orderApp/deleteOrder
//    删除订单
//    userType = U 用户取消
    func Http_DeleteOrder(orderID:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/orderApp/deleteOrder?orderID=\(orderID)&userType=U")
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    /orderApp/appraise
//    orderID	是	int	订单ID
//    userID	是	int	用户ID
//    serviceAppr	是	double	服务评分
//    productAppr	是	double	商品评分
//    distributionAppr	是	double	配送评分
//    content	是	String	评
    func Http_OrderAppraise(orderID:String,serviceAppr:String,productAppr:String,distributionAppr:String,content:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        print("/orderApp/appraise?orderID=\(orderID)&userID=\(UserId)&serviceAppr=\(serviceAppr)&productAppr=\(productAppr)&distributionAppr=\(distributionAppr)&content=\(content)")
        Just.post(
            headerUrl + getDesKey(param: "/orderApp/appraise?orderID=\(orderID)&userID=\(UserId)&serviceAppr=\(serviceAppr)&productAppr=\(productAppr)&distributionAppr=\(distributionAppr)&content=\(content)")
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                var json = JSON(data)
                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: "")
                    return
                }
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
    /*************************************************************************************************
     *********************************个人中心********************************
     ******************************************************************************************/
//    /orderApp/orderList
//    userID	是	integer	用户ID
//    status	是	string	订单状态
//    startIndex	是	int	起始页
//    rows	是	int	行数
    func Http_GetOrderList(status:String,startIndex:Int,succesce:@escaping (_ value:JSON)->(Void)) {
//        loadingStatus()
        
        var url = "/orderApp/orderList?userID=\(UserId)&startIndex=\(startIndex)&rows=10"
        if status != ""{
            url += "&status=\(status)"
        }
        
        Just.get(
            headerUrl + getDesKey(param: url)
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
    
    
//    /user/updUser
//    userID	是	int	用户ID
//    nickName	是	String	用户昵称
//    headUrl	是	String	用户头像
//    sex	是	String	用户性别（0 男 1 女）
//    signature	是	String	个性签名
    func Http_EditInfomation(nickName:String,headUrl:String,sex:String,signature:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.get(
            headerUrl + getDesKey(param: "/user/updUser?userID=\(UserId)&nickName=\(nickName)&headUrl=\(headUrl)&sex=\(sex)&signature=\(signature)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                print(json)
                succesce(json)
//                guard json["code"].stringValue == "SUCCESS" else{
//                    self.noticeError(title: json["msg"].stringValue)
//                    return
//                }
//                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                    self.cleaAllNotice()
//                    succesce(jsonData)
//                }else{
//                    self.noticeNoData()
//                }
            }
        }
    }
//    积分列表
//    /user/myIntegral
    func Http_GetIntegralList(startIndex:Int,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.get(
            headerUrl + getDesKey(param: "/user/myIntegral?userID=\(UserId)&startIndex=\(startIndex)&rows=20")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
//                    if startIndex > 0 && jsonData["integralList"].arrayValue.count == 0{
//                        self.noticeNomore()
//                    }
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
    func noticeNomore(){
        DispatchQueue.main.async {
            SwiftNotice.clear()
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "没有更多了", autoClear: true, autoClearTime: 1)
        }
    }
    //    收货地址列表
//    storeID
    func Http_getAddressList(storeID:String,succesce:@escaping (_ value:JSON)->(Void)) {
//        loadingStatus()
        Just.get(
            headerUrl + getDesKey(param: "/user/addressList?userID=\(UserId)&storeID=\(storeID)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
//                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
//    个人中心优惠券列表
//    userID	是	int	用户id
//    status	是	string	优惠券状态 (N 未使用 Y 已使用 O 过期）
//    startIndex	是	int	起始页
//    rows	是	int	行数
    func Http_ticketList(status:String,startIndex:Int,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.get(
            headerUrl + getDesKey(param: "/user/ticketList?userID=\(UserId)&status=\(status)&startIndex=\(startIndex)&rows=20")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
//
//    订单是可选择的优惠券列表
//    userID	是	int	用户id
//    storeType	是	string	店铺类型
//    amount	是	double	订单金额
    func Http_canChoseCoupon(amount:Double,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        guard storeInfomation != nil else {
            self.noticeNoData()
            return
        }
        print("/user/notUseTicket?userID=\(UserId)&amount=\(amount)&storeType=\(storeInfomation!.storeType)&rows=20")
        Just.get(
            headerUrl + getDesKey(param: "/user/notUseTicket?userID=\(UserId)&amount=\(amount)&storeType=\(storeInfomation!.storeType!)&rows=20")
        ) { result in
            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            
            
            if let data = result.json{
                let json = JSON(data)
                print(json)
                guard json["code"].stringValue == "SUCCESS" else{
                    self.noticeError(title: json["msg"].stringValue)
                    return
                }
                if let jsonData = self.desToData(desStr: json["resultData"].stringValue){
                    self.cleaAllNotice()
                    succesce(jsonData)
                }else{
                    self.noticeNoData()
                }
            }
        }
    }
//    /user/editAddress
//    userID	是	int	用户ID
//    address	是	string	收货地址
//    addressInfo	是	string	详细地址
//    contactParson	是	string	联系人
//    phone	是	string	联系电话
//    lon	是	double	经度
//    lat	是	double	纬度
//    addressType	否	String	(C 公司 H 家)
//    addressID	否	int	地址ID
    func Http_EditOrAddAddress(address:String,addressInfo:String,contactParson:String,phone:String,lon:Double,lat:Double,addressType:String,addressID:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        let url = "/user/editAddress?userID=\(UserId)&address=\(address)&addressInfo=\(addressInfo)&contactParson=\(contactParson)&phone=\(phone)&lon=\(lon)&lat=\(lat)&addressID=\(addressID)&addressType=\(addressType)"
        print(url)
        Just.post(
            headerUrl + getDesKey(param: url)
        ) { result in
//            print(result)
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
//                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    删除收货地址
    func Http_deleteAddressById(addressId:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/user/delAddress?addressID=\(addressId)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    反馈
//    /user/feedBack
//    feedbackType	是	string	反馈类型(1服务投诉、2功能建议、3界面建议、4操作建议)
//    content	是	string	反馈内容
//    phone	是	string	联系电话
//    imgs	是	string	[{‘imgUrl’:11}]
    func Http_Http_FeedBackd(feedbackType:String,content:String,phone:String,imgs:[String],succesce:@escaping (_ value:JSON)->(Void)) {
//        loadingStatus()
        var imgStr:String = "["
        for i in 0..<imgs.count{
            if i == 0{
                imgStr += "{'imgUrl':'\(imgs[i])'}"
            }else{
                imgStr += ",{'imgUrl':'\(imgs[i])'}"
            }
        }
        imgStr += "]"
        print(imgStr)
        Just.post(
            headerUrl + getDesKey(param: "/user/feedBack?feedbackType=\(feedbackType)&content=\(content)&phone=\(phone)&imgs=\(imgStr)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //print(json)
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
    //申请合作
//    /user/applyStore
//    person	是	string	联系人
//    phone	是	string	联系电话
//    storeName	是	string	店铺名称
//    storeType	是	string	店铺类型
//    businessHours	是	string	营业时间
//    site	是	string	所在地
//    address	是	string	详细地址
//    delivery	是	string	是否提供送货上门（Y 是，N 否）
//    businessLicense	是	string	是否有营业执照
//    permit	是	string	是否有食物流通许可证
    func Http_applyStore(person:String,phone:String,storeName:String,storeType:String,businessHours:String,site:String,address:String,delivery:String,businessLicense:String,permit:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        print(storeType)
        
        Just.post(
            headerUrl + getDesKey(param: "/user/applyStore?person=\(person)&phone=\(phone)&storeName=\(storeName)&storeType=\(storeType)&businessHours=\(businessHours)&site=\(site)&address=\(address)&delivery=\(delivery)&businessLicense=\(businessLicense)&permit=\(permit)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
    
    //   发送验证码
    //  /user/sendSmsCode
    func Http_SendSmsCode(phone:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        
        Just.post(
            headerUrl + getDesKey(param: "/user/sendSmsCode?phone=\(phone)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    绑定手机号
//    /user/bindPhone
//    userID	是	int	用户ID
//    oldPhone	是	string	原手机号
//    newPhone	是	string	新手机号
//    validCode	是	string	验证码
    func Http_BindPhone(oldPhone:String,newPhone:String,validCode:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        
        Just.post(
            headerUrl + getDesKey(param: "/user/bindPhone?userID=\(UserId)&oldPhone=\(oldPhone)&newPhone=\(newPhone)&validCode=\(validCode)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
//                print(json)
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    /user/getAccountInfo
//    账户安全
    func Http_GetAccountInfo(succesce:@escaping (_ value:JSON)->(Void)) {
//        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/user/getAccountInfo?userID=\(UserId)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
//            self.cleaAllNotice()
            succesce(json)
        }
    }
//    /user/sitePhone
//    userID	是	int	用户ID
//    phone	是	string	手机号
//    validCode	是	string
//    设置手机号
    func Http_SitePhone(phone:String,validCode:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/user/sitePhone?userID=\(UserId)&phone=\(phone)&validCode=\(validCode)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
            self.cleaAllNotice()
            succesce(json)
        }
    }
//    /user/sitePassword
//    设置密码
    func Http_SitePassword(password:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        Just.post(
            headerUrl + getDesKey(param: "/user/sitePassword?userID=\(UserId)&password=\(password)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            var json = JSON(result.json!)
            json["resultData"] = self.desToData(desStr: json["resultData"].stringValue)!
            self.cleaAllNotice()
            succesce(json)
        }
    }
//    /user/updPassword  修改密码
//    userID	是	int	用户ID
//    oldPassword	是	string	原密码
//    newPassword	是	string	新密码
    func Http_UpdatePassword(oldPassword:String,newPassword:String,succesce:@escaping (_ value:JSON)->(Void)) {
        loadingStatus()
        print("/user/updPassword?userID=\(UserId)&oldPassword=\(oldPassword.md5()!)&newPassword=\(newPassword.md5()!)")
        Just.post(
            headerUrl + getDesKey(param: "/user/updPassword?userID=\(UserId)&oldPassword=\(oldPassword.md5()!)&newPassword=\(newPassword.md5()!)")
        ) { result in
            
            guard result.ok else{
                self.noticeNoData()
                return
            }
            if let data = result.json{
                let json = JSON(data)
                //print(json)
                self.cleaAllNotice()
                succesce(json)
            }
        }
    }
//    mallApp/mallUrl?userID=1
    func getDuibaUrl()->String {
        return headerUrlShot + "key=" + getDesKey(param: "/mallApp/mallUrl?userID=\(UserId)")
    }
}
