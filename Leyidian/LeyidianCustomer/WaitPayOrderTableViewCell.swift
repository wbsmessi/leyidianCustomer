//
//  WaitPayOrderTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/22.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol OrderCellDelegate {
    func rightBtnClick(orderType:orderTypeEnum,indexpath:IndexPath)
    func leftBtnClick(orderType:orderTypeEnum,indexpath:IndexPath)
    func orderOverTime()
}
class WaitPayOrderTableViewCell: UITableViewCell {

    //订单过期时间（300s）
    var orderFireSeconds:Int = 10
    var method = Methods()
    var orderType:orderTypeEnum!
    var delegate:OrderCellDelegate!
    var indexPath:IndexPath!
    //倒计时显示
    let timerBtn = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = MyGlobalColor()
    }
    var item_height:CGFloat = 40 + 100.0 + 50
    
    func creatViewWithGoods(Goods:JSON) {
        if PAY_ORDER_TIME_OUT > 0{
            self.orderFireSeconds = PAY_ORDER_TIME_OUT * 60
        }
        
        let bgview = UIView()
        bgview.frame = CGRect(x: 0, y: 0, width: app_width, height: item_height)
        bgview.backgroundColor = UIColor.white
        self.addSubview(bgview)
        
        //40
        let storeImg = UIImageView()
        method.creatImage(img: storeImg, x: 15, y: 5, wid: 30, hei: 30, imgName: "", imgMode: .scaleAspectFill, superView: bgview)
        storeImg.clipsToBounds = true
        storeImg.layer.cornerRadius = storeImg.frame.width/2
        //需要去店铺图片。。。。
        method.loadImage(imgUrl: Goods["storeImg"].stringValue, Img_View: storeImg)
//        ["details"]
        let storeName = UILabel()
        method.creatLabel(lab: storeName, x: storeImg.rightPosition() + 20, y: 0, wid: app_width - 100 - storeImg.rightPosition(), hei: 40, textString: Goods["storeName"].stringValue, textcolor: UIColor.black, textFont: 12, superView: bgview)
        
        let orderStatus = UILabel()
        orderStatus.textAlignment = .center
        method.creatLabel(lab: orderStatus, x: app_width - 80, y: 0, wid: 80, hei: 40, textString: method.getStatusName(type: orderType), textcolor: MyAppColor(), textFont: 14, superView: self)
        
        method.drawLine(startX: 0, startY: storeName.bottomPosition(), wid: app_width, hei: 0.6, add: bgview)
        // 80
        if Goods["details"].arrayValue.count == 1{
            //只有一件商品时的UI
            let goodsImg = UIImageView()
            goodsImg.frame = CGRect(x: 15, y: storeName.bottomPosition() + 10, width: 80, height: 80)
            goodsImg.contentMode = .scaleAspectFit
            method.loadImage(imgUrl: Goods["details"][0]["commodityImg"].stringValue, Img_View: goodsImg)
            goodsImg.layer.borderColor = setMyColor(r: 240, g: 240, b: 240, a: 1).cgColor
            goodsImg.layer.borderWidth = 0.6
            bgview.addSubview(goodsImg)
            
            let goodsName = UILabel()
            method.creatLabel(lab: goodsName, x: goodsImg.rightPosition() + 10, y: goodsImg.frame.origin.y, wid: app_width - goodsImg.rightPosition() - 30, hei: 20, textString: Goods["details"][0]["commodityName"].stringValue, textcolor: UIColor.black, textFont: 14, superView: bgview)
            
            let goodsDetail = UILabel()
            method.creatLabel(lab: goodsDetail, x: goodsName.frame.origin.x, y: goodsName.bottomPosition(), wid: goodsName.frame.width, hei: 30, textString: Goods["details"][0]["norm"].stringValue, textcolor: UIColor.gray, textFont: 12, superView: bgview)
            
            let price = UILabel()
            method.creatLabel(lab: price, x: goodsName.frame.origin.x, y: goodsDetail.bottomPosition(), wid: 150, hei: 20, textString: "¥"+Goods["details"][0]["discountPrice"].stringValue, textcolor: MyMoneyColor(), textFont: 12, superView: bgview)
            
            let goodsCount = UILabel()
            method.creatLabel(lab: goodsCount, x: price.rightPosition(), y: goodsDetail.bottomPosition()+10, wid: app_width - price.rightPosition() - 15, hei: 20, textString: "x" + "\(Goods["details"][0]["num"].intValue)", textcolor: UIColor.gray, textFont: 11, superView: bgview)
            goodsCount.textAlignment = .right
        }else{
            //多件商品时的UI
//            img尺寸为60
            let goodsScroll = UIScrollView()
            goodsScroll.frame = CGRect(x: 0, y: 40, width: app_width, height: 100)
            goodsScroll.isUserInteractionEnabled = false
            let scroll_width = CGFloat(Goods.count * 90) > app_width ? CGFloat(Goods.count * 90) : app_width
            goodsScroll.contentSize = CGSize(width: scroll_width, height: 100)
            bgview.addSubview(goodsScroll)
            for i in 0..<Goods["details"].arrayValue.count{
                let orgin_x:CGFloat = CGFloat((10 + 80) * i) + 10
                
                creatGoodsItem(x: orgin_x, y: 10, goodsInfo: Goods["details"][i], superView: goodsScroll)
            }
        }
        
        method.drawLine(startX: 0, startY: 140, wid: app_width, hei: 0.6, add: bgview)
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: app_width - 80, y: 150, wid: 70, hei: 30, title: "", titlecolor: UIColor.black, titleFont: 12, bgColor: UIColor.white, superView: bgview)
        rightBtn.layer.borderWidth = 0.6
        rightBtn.layer.borderColor = UIColor.lightGray.cgColor
        rightBtn.layer.cornerRadius = 5
//        rightBtn.isHidden = true
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        let leftBtn = UIButton()
        method.creatButton(btn: leftBtn, x: app_width - 160, y: 150, wid: 70, hei: 30, title: "", titlecolor: UIColor.black, titleFont: 12, bgColor: UIColor.white, superView: bgview)
        leftBtn.layer.borderWidth = 0.6
        leftBtn.layer.borderColor = UIColor.lightGray.cgColor
        leftBtn.layer.cornerRadius = 5
        leftBtn.isHidden = true
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        //倒计时显示
        method.creatButton(btn: timerBtn, x: 20, y: rightBtn.frame.origin.y, wid: 80, hei: 30, title: "05:00后取消", titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.clear, superView: self)
        timerBtn.setImage(UIImage(named:"shalouh"), for: .normal)
//        timerBtn.titleLabel?.backgroundColor=UIColor.red
//        timerBtn.imageView?.backgroundColor=UIColor.blue
        timerBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -timerBtn.titleLabel!.frame.width, bottom: 0, right: 0)
        timerBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -timerBtn.imageView!.frame.width)
        
//        enum orderTypeEnum:String {
//            case waitPay        = "0"//待付款
//            case waitRecive     = "1"//待发货
//            case send           = "2"//待收货
//            case waitEnv        = "3"//待评价
//            case finish         = "4"//已完成
//            case cancle         = "5"//已取消
//            case refund         = "6"//退款中
//            case refunded       = "7"//已退款
//            case allOrder       = "10"//
        
        switch orderType.rawValue {
            case orderTypeEnum.waitPay.rawValue:
                timerBtn.isHidden = false
                startTimer(orderDate:Goods["createDate"].intValue)
                rightBtn.setTitle("立即支付", for: .normal)
                leftBtn.isHidden = false
                leftBtn.setTitle("取消订单", for: .normal)
            case orderTypeEnum.paid.rawValue:
                timerBtn.isHidden = true
                rightBtn.setTitle("取消订单", for: .normal)
            case orderTypeEnum.send.rawValue:
                timerBtn.isHidden = true
                rightBtn.setTitle("立即签收", for: .normal)
            case orderTypeEnum.arrived.rawValue:
                timerBtn.isHidden = true
                rightBtn.setTitle("立即签收", for: .normal)
            case orderTypeEnum.waitEnv.rawValue:
                timerBtn.isHidden = true
                rightBtn.setTitle("立即评价", for: .normal)
            case orderTypeEnum.refund.rawValue:
                timerBtn.isHidden = true
                rightBtn.setTitle("删除订单", for: .normal)
            default:
                timerBtn.isHidden = true
                rightBtn.setTitle("删除订单", for: .normal)
        }
        
    }
    //开始计时
    func startTimer(orderDate:Int) {
        //订单时间
        let orderDateSeconds = orderDate/1000
        print("orderDateSeconds\(orderDateSeconds)")
//        当前时间
        let nowDateSeconds = Int(NSDate().timeIntervalSince1970)
        
        let fireTime = (nowDateSeconds - orderDateSeconds)
        print("nowDateSeconds\(nowDateSeconds)")
        print("fireTime\(fireTime)")
//        时间间隔大于等于则已过期
        if fireTime < orderFireSeconds{
            runSeconds = orderFireSeconds - fireTime
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }else{
            
            
            self.timerBtn.setTitle("已过期", for: .normal)
        }
    }
    var timer:Timer?
    var runSeconds:Int = 0{
        didSet{
//            %02ld
//            String(format: "%.2f", f) //123.32
//            let min = runSeconds/60
//            let second = runSeconds%60
            
            let min = String(format: "%02ld", runSeconds/60)
            let sec = String(format: "%02ld", runSeconds%60)
            
            let str = "\(min):\(sec)后取消"
            self.timerBtn.setTitle(str, for: .normal)
        }
    }
    func updateTime(){
        if runSeconds > 0{
            runSeconds -= 1
        }else{
            timer?.invalidate()
            timer = nil
            //通知刷新
            delegate.orderOverTime()
            self.timerBtn.setTitle("已过期", for: .normal)
        }
        
    }
    func creatGoodsItem(x:CGFloat,y:CGFloat,goodsInfo:JSON,superView:UIView){
        let goodsImg = UIImageView()
        goodsImg.isUserInteractionEnabled = false
        goodsImg.frame = CGRect(x: x, y: y, width: 80, height: 80)
        method.loadImage(imgUrl: goodsInfo["commodityImg"].stringValue, Img_View: goodsImg)
        goodsImg.layer.borderColor = setMyColor(r: 240, g: 240, b: 240, a: 1).cgColor
        goodsImg.layer.borderWidth = 0.6
        goodsImg.contentMode = .scaleAspectFit
        superView.addSubview(goodsImg)
        
        
        let count = UILabel()
        method.creatLabel(lab: count, x: goodsImg.rightPosition() - 15, y: goodsImg.frame.origin.y - 5, wid: 20, hei: 20, textString: "\(goodsInfo["num"].intValue)", textcolor: MyAppColor(), textFont: 10, superView: superView)
        count.textAlignment = .center
        count.backgroundColor = MyGlobalColor()
        count.layer.cornerRadius = count.frame.width/2
        count.layer.borderColor = UIColor.lightGray.cgColor
        count.layer.borderWidth = 0.4
        count.clipsToBounds = true
        
    }
//    右边第一个按钮
    func rightBtnClick(){
        delegate.rightBtnClick(orderType:self.orderType,indexpath:self.indexPath)
    }
//    右边靠左的按钮
    func leftBtnClick(){
        delegate.leftBtnClick(orderType:self.orderType,indexpath:self.indexPath)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
