//
//  ShopModel.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/13.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

//当前的店铺信息
//store	object	店铺
//store.storeID	int	店铺ID
//store.storeName	String	店铺名称
//store.storeType	String	店铺类型（B便利店 C 超市)
//store.status	String	状态（0 上班 1 下班）
//store.phone	String	店铺联系电话
//store.startLimit	String	满多少元配送
//store.freeLimit	double	满多少元免邮
//store.deliveryFee	double	配送费
//store.businessHours	String	营业时间

class ShopModel: NSObject {
    var freeLimit:Int!//满多少元免邮
    var phone:String!
    var status:String!
    var storeID:String!//	店铺ID
    var deliveryFee:String!//配送费
    var businessHours:String!//营业时间
    var storeType:String!//店铺类型（B便利店 C 超市)
    var storeName:String!
    var startLimit:String!//满多少元配送
    var storeImg:String!
    var storeNotice:String! //商家公告
    init(shopInfo:JSON) {
        self.freeLimit = shopInfo["freeLimit"].intValue
        self.phone = shopInfo["phone"].stringValue
        self.status = shopInfo["status"].stringValue
        self.storeID = shopInfo["storeID"].stringValue
        self.deliveryFee = shopInfo["deliveryFee"].stringValue
        self.businessHours = shopInfo["businessHours"].stringValue
        self.storeType = shopInfo["storeType"].stringValue
        self.storeName = shopInfo["storeName"].stringValue
        self.startLimit = shopInfo["startLimit"].doubleValue.getMoney()
        self.storeImg = shopInfo["storeImg"].stringValue
        self.storeNotice = shopInfo["notice"].stringValue
    }
}
