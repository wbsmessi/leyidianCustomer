//
//  ConfigFile.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/16.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import Foundation

let app_width = UIScreen.main.bounds.width
let app_height = UIScreen.main.bounds.height
let nav_height:CGFloat = 64.0
let tab_height:CGFloat = 49.0
//m.loedo.net:8080/lydShop

//////外网
let headerUrl = "http://m.loedo.net:8080/lydShop/app/server.api?key="

//兑吧
let headerUrlShot = "http://m.loedo.net:8080/lydShop/app/server?"
//分享地址用
let shareHeaderUrl = "http://m.loedo.net:8080/lydShop"

//////内网
//let headerUrl = "http://192.168.3.155:8080/lydShop/app/server.api?key="
////兑吧
//let headerUrlShot = "http://192.168.3.155:8080/lydShop/app/server?"
////分享地址用
//let shareHeaderUrl = "http://192.168.3.155:8080/lydShop"
//数据存储
let MyUserInfo = UserDefaults.standard
//当前店铺信息，每次首页加载都会更新成最新
var storeInfomation:ShopModel?
//微信开发者appid
let wechatAppid:String = "wx18ca01864cf5c69a"

//高德地图appkey
let gaodeMapAppkey:String = "c5f684f9f0bf9d2052958fac5905a9d5"
//aliyun oss
let aliyunOssBuckName = "leyidian"
let aliyunOssKeyID = "ht8L1fbbPdlMGkbT"
let aliyunOssKeySecret = "QE9dutDJlVKPGKoQkxTewCCgM8WCfV"
//友盟推送
let umengPushAppKey = "58f9b147f29d982644001810"
let umengPushAppSecret = "zwapebgorftibk0txobf5rcmmzpi7tgk"


let umengKey = "58f9a3a4f5ade43971000949"


/////////////////分享平台各key/////////////////////////
let wechatShareKey = "wxfe304c0cc3d4469b"
let wechatShareAppSecret = "98bd21560e34d8902b3e1fe62510350f"

let tencentKey = "1106110338"


let weiboAppKey = "313151502"
let weiboAppSecket = "570232e280a30674f81506ce5d358387"
