//
//  GoodsCollectionViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/2.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol GoodsCollectionViewCellDelegate {
    func alertNormChose()
}
class GoodsCollectionViewCell: UICollectionViewCell {
    var delegate:GoodsCollectionViewCellDelegate?
    var method = Methods()
    var goodsInfo:JSON!{
        didSet{
            
//  存储可能返回来的购物车id，方便减数量。因为默认是0的时候表示还没有购物车id，
            let cartid = goodsInfo["cartID"].intValue
            if cartid > 0{
                MyUserInfo.setValue("\(cartid)", forKey: userdefaultKey.nowShopCarId.rawValue)
            }
        }
    }
    var indexRow:Int!{
        didSet{
            let isLeftLine:Bool = (indexRow%2 != 0)
            method.drawLineWithColor(startX: isLeftLine ? 0:self.frame.width - 0.6, startY: 0, wid: 0.6, hei: self.frame.height, lineColor: setMyColor(r: 223, g: 224, b: 225, a: 1), add: self)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.white
        initView()
    }
    //加载商品图片
    var imageUrl = ""{
        didSet{
            method.loadImage(imgUrl: imageUrl, Img_View: goodsImage)
        }
    }
    var oldPrice = ""{
        didSet{
            goodsOldPrice.text = oldPrice
            goodsOldPrice.sizeToFit()
            let line = CALayer()
            line.frame=CGRect(x: 0, y: goodsOldPrice.frame.height/2, width: goodsOldPrice.frame.width, height: 0.6)
            line.backgroundColor = UIColor.gray.cgColor
            goodsOldPrice.layer.addSublayer(line)
        }
    }
    var goodsNameStr = ""{
        didSet{
            goodsName.text = goodsNameStr
        }
    }
    var goodsNumInCar:Int = 0{
        didSet{
//            print("and thoere??")
            if goodsNumInCar <= 0 {
                DispatchQueue.main.async {
                    self.addCar.isHidden = false
                    self.addAndCut.isHidden = true
                }
            }
            addAndCut.nowCount = goodsNumInCar
        }
    }
    var goodsActiveType:String = ""{
        didSet{
            
//            case PreferredGoods   =    "Y"//优选精品
//            case Timelimit        =    "X"//限时抢购
//            case BargainPrice     =    "Z"//折扣特价
//            case Recommend        =    "R"//掌柜推荐
//            tejia tuijian jingpin
            switch goodsActiveType {
            case ActivitieGoods.PreferredGoods.rawValue:
                goodsActiveTypeImg.isHidden = false
                goodsActiveTypeImg.image = UIImage(named:"jingpin")
//            case .Timelimit:
//                goodsActiveTypeImg.isHidden = false
//                goodsActiveTypeImg.image = UIImage(named:"")
            case ActivitieGoods.BargainPrice.rawValue:
                goodsActiveTypeImg.isHidden = false
                goodsActiveTypeImg.image = UIImage(named:"tejia")
            case ActivitieGoods.Recommend.rawValue:
                goodsActiveTypeImg.isHidden = false
                goodsActiveTypeImg.image = UIImage(named:"tuijian")
            default:
                goodsActiveTypeImg.isHidden = true
            }
        }
    }
    lazy var goodsImage = UIImageView()
    lazy var goodsName = UILabel()
    lazy var goodsDetail = UILabel()
    lazy var nowPrice = UILabel()
    lazy var goodsOldPrice = UILabel()
    lazy var addCar = UIButton()
    //那个小标志，特价，精品什么的
    let goodsActiveTypeImg = UIImageView()
    var addAndCut:AddAndCutView!
    func initView(){
        method.creatImage(img: goodsImage, x: 0, y: 0, wid: self.frame.width, hei: self.frame.height - 80, imgName: "", imgMode: .scaleAspectFill, superView: self)
        goodsImage.contentMode = .scaleAspectFill
//        goodsImage.backgroundColor=UIColor.green
        
        goodsActiveTypeImg.isHidden = true
        method.creatImage(img: goodsActiveTypeImg, x: 0, y: 0, wid: 30, hei: 10, imgName: "tejia", imgMode: .scaleAspectFill, superView: self)
        
        method.creatLabel(lab: goodsName, x: 5, y: goodsImage.bottomPosition(), wid: self.frame.width - 10, hei: 20, textString: "矿泉水 怡宝", textcolor: UIColor.black, textFont: 16, superView: self)
//        goodsName.backgroundColor=UIColor.red
        
        method.creatLabel(lab: goodsDetail, x: 5, y: goodsName.bottomPosition(), wid: goodsName.frame.width, hei: 15, textString: "450ml*20瓶", textcolor: UIColor.gray, textFont: 12, superView: self)
//        goodsDetail.backgroundColor=UIColor.orange
        
        method.creatLabel(lab: goodsOldPrice, x: nowPrice.rightPosition() + 5, y: goodsDetail.bottomPosition() + 5, wid: goodsName.frame.width, hei: 15, textString: "¥45", textcolor: UIColor.lightGray, textFont: 12, superView: self)
        
        let moneyIcon=UILabel()
        method.creatLabel(lab: moneyIcon, x: 5, y: goodsOldPrice.bottomPosition()+7, wid: 10, hei: 15, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: self)
        
        method.creatLabel(lab: nowPrice, x: moneyIcon.rightPosition(), y: self.frame.height - 25, wid: self.frame.width-10, hei: 25, textString: "300.00", textcolor: MyMoneyColor(), textFont: 18, superView: self)
//        nowPrice.sizeToFit()
        
        
        addCar.frame = CGRect(x: self.frame.width - 30, y: self.frame.height - 30, width: 25, height: 25)
        addCar.setBackgroundImage(UIImage(named:"jia"), for: .normal)
        addCar.addTarget(self, action: #selector(addGoodsToCar(btn:)), for: .touchUpInside)
        self.addSubview(addCar)
        
        addAndCut = AddAndCutView(frame: CGRect(x: self.frame.width - 80, y: self.frame.height - 30, width: 75, height: 25))
        addAndCut.addBtn.addTarget(self, action: #selector(addGoodsCount), for: .touchUpInside)
        addAndCut.cutBtn.addTarget(self, action: #selector(cutGoodsCount), for: .touchUpInside)
        addAndCut.isHidden = true
        self.addSubview(addAndCut)
        
        method.drawLineWithColor(startX: 0, startY: self.frame.height - 0.6, wid: self.frame.width, hei: 0.6, lineColor: setMyColor(r: 223, g: 224, b: 225, a: 1), add: self)
    }
    func addGoodsToCar(btn:UIButton){
        print(goodsInfo)
        if goodsInfo["normList"].arrayValue.count > 1{
            //去选择
            delegate?.alertNormChose()
        }else{
            let norm = goodsInfo["normList"].arrayValue.count == 1 ? goodsInfo["normList"][0]["norm"].stringValue : ""
            method.addTocar(goodId: goodsInfo["commodityID"].stringValue, norm: norm){ (isSuccess) in
                if isSuccess{
                    DispatchQueue.main.async {
                        btn.isHidden = true
                        self.addAndCut.isHidden = false
                        self.goodsNumInCar += 1
                    }
                    //                self.addAndCut.isHidden = false
                }
            }
        }
    }
    //
    func addGoodsCount(){
        let norm = goodsInfo["normList"].arrayValue.count == 1 ? goodsInfo["normList"][0]["norm"].stringValue : ""
        method.addTocar(goodId: goodsInfo["commodityID"].stringValue, norm: norm){ (isSuccess) in
            print(isSuccess)
            if isSuccess{
                self.goodsNumInCar += 1
            }
        }
    }
    func cutGoodsCount(){
        method.cutFromcar(goodsId: goodsInfo["commodityID"].stringValue){ (isSuccess) in
            if isSuccess{
                self.goodsNumInCar -= 1
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
