//
//  OrderDetailGoodsInfoTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/24.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailGoodsInfoTableViewCell: UITableViewCell {

    var method = Methods()
//    var orderType:orderTypeEnum!
//    var indexPath:IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = MyGlobalColor()
    }
    var item_height:CGFloat = 40 + 80.0
    func creatViewWithGoods(Goods:[JSON]) {
        let bgview = UIView()
        bgview.frame = CGRect(x: 0, y: 0, width: app_width, height: item_height)
        bgview.backgroundColor = UIColor.white
        self.addSubview(bgview)
        
        //40
        let storeImg = UIImageView()
        method.creatImage(img: storeImg, x: 15, y: 5, wid: 30, hei: 30, imgName: "", imgMode: .scaleAspectFill, superView: bgview)
        storeImg.clipsToBounds = true
        storeImg.layer.cornerRadius = storeImg.frame.width/2
        method.loadImage(imgUrl: storeInfomation?.storeImg ?? "1", Img_View: storeImg)
        
        let storeName = UILabel()
        method.creatLabel(lab: storeName, x: storeImg.rightPosition() + 20, y: 0, wid: app_width - 100 - storeImg.rightPosition(), hei: 40, textString: storeInfomation?.storeName ?? "", textcolor: UIColor.black, textFont: 12, superView: bgview)
        
        let goodsCount = UILabel()
        goodsCount.textAlignment = .right
        method.creatLabel(lab: goodsCount, x: app_width - 120, y: 0, wid: 100, hei: 40, textString: "(共\(Goods.count)件)", textcolor: UIColor.gray, textFont: 12, superView: self)
        
        method.drawLine(startX: 0, startY: storeName.bottomPosition(), wid: app_width, hei: 0.6, add: bgview)
        // 80
        if Goods.count == 1{
            //只有一件商品时的UI
            let goodsImg = UIImageView()
            goodsImg.frame = CGRect(x: 15, y: storeName.bottomPosition() + 10, width: 60, height: 60)
            goodsImg.contentMode = .scaleAspectFit
            method.loadImage(imgUrl: Goods[0]["commodityImg"].stringValue, Img_View: goodsImg)
            goodsImg.layer.borderColor = setMyColor(r: 240, g: 240, b: 240, a: 1).cgColor
            goodsImg.layer.borderWidth = 0.6
            bgview.addSubview(goodsImg)
            
            let goodsName = UILabel()
            method.creatLabel(lab: goodsName, x: goodsImg.rightPosition() + 10, y: goodsImg.frame.origin.y, wid: app_width - goodsImg.rightPosition() - 30, hei: 20, textString: Goods[0]["commodityName"].stringValue, textcolor: UIColor.black, textFont: 12, superView: bgview)
            
            let goodsDetail = UILabel()
            method.creatLabel(lab: goodsDetail, x: goodsName.frame.origin.x, y: goodsName.bottomPosition(), wid: goodsName.frame.width, hei: 20, textString: Goods[0]["norm"].stringValue, textcolor: UIColor.gray, textFont: 10, superView: bgview)
            
            let price = UILabel()
            method.creatLabel(lab: price, x: goodsName.frame.origin.x, y: goodsDetail.bottomPosition(), wid: 150, hei: 20, textString: "¥"+Goods[0]["price"].doubleValue.getMoney(), textcolor: MyMoneyColor(), textFont: 12, superView: bgview)
            
            let goodsCount = UILabel()
            method.creatLabel(lab: goodsCount, x: price.rightPosition(), y: goodsDetail.bottomPosition(), wid: app_width - price.rightPosition() - 15, hei: 20, textString: "x\(Goods[0]["num"].intValue)", textcolor: UIColor.gray, textFont: 11, superView: bgview)
            goodsCount.textAlignment = .right
        }else{
            //多件商品时的UI
            //            img尺寸为60
            let goodsScroll = UIScrollView()
            goodsScroll.frame = CGRect(x: 0, y: 40, width: app_width, height: 80)
            goodsScroll.showsHorizontalScrollIndicator = false
            //false的时候，点击scroll区域响应的是cell点击行，true的，可以滑动，但是不能点击，
            goodsScroll.isUserInteractionEnabled = false
            let scroll_width = CGFloat(Goods.count * 75) > app_width ? CGFloat(Goods.count * 75) : app_width
            print("keyidongjuli\(scroll_width)")
            goodsScroll.contentSize = CGSize(width: scroll_width, height: 80)
            bgview.addSubview(goodsScroll)
            
            for i in 0..<Goods.count{
                let orgin_x:CGFloat = CGFloat((15 + 60) * i) + 15
                
                creatGoodsItem(x: orgin_x, y: 10, goodsInfo: Goods[i], superView: goodsScroll)
            }
        }
        
    }
    func creatGoodsItem(x:CGFloat,y:CGFloat,goodsInfo:JSON,superView:UIView){
        let goodsImg = UIImageView()
        goodsImg.isUserInteractionEnabled = false
        goodsImg.frame = CGRect(x: x, y: y, width: 60, height: 60)
        method.loadImage(imgUrl: goodsInfo["commodityImg"].stringValue, Img_View: goodsImg)
        goodsImg.layer.borderColor = setMyColor(r: 240, g: 240, b: 240, a: 1).cgColor
        goodsImg.layer.borderWidth = 0.6
        goodsImg.contentMode = .scaleAspectFit
        superView.addSubview(goodsImg)
        
        let count = UILabel()
        method.creatLabel(lab: count, x: goodsImg.rightPosition() - 5, y: goodsImg.frame.origin.y - 5, wid: 10, hei: 10, textString: "\(goodsInfo["num"].intValue)", textcolor: MyAppColor(), textFont: 8, superView: superView)
        count.textAlignment = .center
        count.backgroundColor = MyGlobalColor()
        count.layer.cornerRadius = count.frame.width/2
        count.layer.borderColor = UIColor.lightGray.cgColor
        count.layer.borderWidth = 0.4
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }

}
