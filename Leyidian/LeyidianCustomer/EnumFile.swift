//
//  EnumFile.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/13.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import Foundation

//首页活动商品类型
let HomePageImgArr = ["youxuanjingp","xianshiqianggou","zhekoutejia","zhangguituijian"]
let HomePageTitleArr = ["优选精品","限时抢购","折扣特价","掌柜推荐"]
//订单取消时间
var PAY_ORDER_TIME_OUT:Int = 0

//订单分享宋积分的限制金额
var TICKET_SHEAR_LIMIT:Double = 0.0

enum ActivitieGoods:String {
    case PreferredGoods   =    "Y"//优选精品
    case Timelimit        =    "X"//限时抢购
    case BargainPrice     =    "Z"//折扣特价
    case Recommend        =    "R"//掌柜推荐
}
enum goodsSortType:String {
//    sortType	否	int	排序类型（A 价格最低 B价格最高 C销量
    case highPrice      = "B"
    case lowPrice       = "A"
    case highSales      = "C"
    case defaultType    = ""
}
//用户信息key
enum userInfoKey:String {
    case headUrl        = "headUrl"
    case nickName       = "nickName"
    case userID         = "userID"
    case phone          = "phone"
    case integral       = "integral"
    case signature      = "signature"
    case sex            = "userSex"
    case firstEnter     = "firstEnter"
    case searchHistory  = "history"
    case locationLat    = "nowLocationLat"
    case locationLon    = "nowLocationLon"
    case locationString = "nowLocationString"
}
//购物车信息key
enum userdefaultKey:String {
    case nowShopCarId   = "shopCarId"
}
//订单类型
//0待付款 1 已付款 2 已发货   3 已签收 4 已完成 5 已取消 6 已送达 7 已退款 8 已删除  9 退款中 10 退款失败
enum orderTypeEnum:String {
    case waitPay        = "0"//待付款
    case paid           = "1"//待收货
    case send           = "2"//已发货
    case waitEnv        = "3"//待评价 已签收
    case finish         = "4"//已完成
    case cancle         = "5"//已取消
    case arrived        = "6"//已送达
    case refund         = "9"//退款中
    case refunded       = "7"//已退款
    case refundFaild    = "10"//退款失败
    case allOrder       = "100"//
}
//优惠券类型
enum couponTypeEnum:String {
    case unuse          = "N"
    case used           = "Y"
    case expired        = "O"
}
//反馈类型(1服务投诉、2功能建议、3界面建议、4操作建议)
enum feedBackTypeEnum:String {
    case serviceComplaints      = "1"
    case funcationAdvice        = "2"
    case uiAdvice               = "3"
    case useAdvice              = "4"
}
