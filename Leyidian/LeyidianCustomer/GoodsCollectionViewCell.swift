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
    func alertNormChose(goods:JSON)
}
class GoodsCollectionViewCell: UICollectionViewCell {
    var delegate:GoodsCollectionViewCellDelegate?
    var method = Methods()
    //当前所在的vc
    var selfViewController:UIViewController!
    var goodsInfo:JSON!{
        didSet{
            
//  存储可能返回来的购物车id，方便减数量。因为默认是0的时候表示还没有购物车id，
            let cartid = goodsInfo["cartID"].intValue
            if cartid > 0{
                MyUserInfo.setValue("\(cartid)", forKey: userdefaultKey.nowShopCarId.rawValue)
            }
        }
    }
    //侧边线条
    let leftLine = CALayer()
    let rightLine = CALayer()
    let bottomLine = CALayer()
    var indexRow:Int!{
        didSet{
            //true 左边cell，false右边cell
            let isLeftLine:Bool = (indexRow%2 == 0)
            leftLine.isHidden = isLeftLine
            rightLine.isHidden = !isLeftLine
            bottomLine.frame.origin.x = isLeftLine ? 5:0
        }
    }
    func drawItemLine(startX:CGFloat,line:CALayer){
//        let leftLine = CALayer()
        line.frame = CGRect(x: startX, y: 0, width: 0.6, height: self.frame.height)
        line.backgroundColor = setMyColor(r: 223, g: 224, b: 225, a: 1).cgColor
        self.layer.addSublayer(line)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.white
        initView()
    }
    var goodsStatus:String = ""{
        didSet{
            if !(goodsStatus == "1"){
                //已售罄
                sallerImage.isHidden = false
            }else{
                sallerImage.isHidden = true
            }
        }
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
            if goodsNumInCar <= 0 {
                DispatchQueue.main.async {
                    self.addCar.isHidden = false
                    self.addAndCut.isHidden = true
                }
            }else{
                self.addAndCut.isHidden = false
                addAndCut.nowCount = goodsNumInCar
            }
            
        }
    }
    var goodsActiveType:String = ""{
        didSet{
            let typeStr = method.getGoodsActiveType(types: goodsActiveType)
            switch typeStr {
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
    //已售罄图片
    lazy var sallerImage = UIImageView()
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
        method.creatImage(img: goodsImage, x: 5, y: 0, wid: self.frame.width - 10, hei: self.frame.height - 80, imgName: "", imgMode: .scaleAspectFill, superView: self)
        goodsImage.contentMode = .scaleAspectFill
//        goodsImage.backgroundColor=UIColor.green
        
        goodsActiveTypeImg.isHidden = true
        method.creatImage(img: goodsActiveTypeImg, x: 10, y: 0, wid: 30, hei: 10, imgName: "tejia", imgMode: .scaleAspectFill, superView: self)
        
        method.creatLabel(lab: goodsName, x: 10, y: goodsImage.bottomPosition()+5, wid: self.frame.width - 15, hei: 15, textString: "矿泉水 怡宝", textcolor: myAppBlackColor(), textFont: 14, superView: self)
//        goodsName.backgroundColor=UIColor.red
        
        method.creatLabel(lab: goodsDetail, x: 10, y: goodsName.bottomPosition()+5, wid: goodsName.frame.width, hei: 13, textString: "450ml*20瓶", textcolor: UIColor.gray, textFont: 11, superView: self)
//        goodsDetail.backgroundColor=UIColor.orange
        
        method.creatLabel(lab: goodsOldPrice, x: 10, y: goodsDetail.bottomPosition() + 3, wid: goodsName.frame.width, hei: 12, textString: "¥45", textcolor: UIColor.lightGray, textFont: 11, superView: self)
        
        let moneyIcon = UILabel()
        method.creatLabel(lab: moneyIcon, x: 10, y: goodsOldPrice.bottomPosition()+7, wid: 10, hei: 12, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: self)
        
        method.creatLabel(lab: nowPrice, x: moneyIcon.rightPosition(), y: goodsOldPrice.bottomPosition(), wid: self.frame.width-15, hei: 25, textString: "300.00", textcolor: MyMoneyColor(), textFont: 16, superView: self)
        if app_width >= 330{
            nowPrice.font = UIFont(name: "Helvetica-Bold", size: 16)
        }else{
            nowPrice.font = UIFont(name: "Helvetica-Bold", size: 14)
        }
        
        let addcarBtn_width:CGFloat = (self.frame.width > 140) ? 24:16
        addCar.frame = CGRect(x: self.frame.width - addcarBtn_width - 5, y: self.frame.height - addcarBtn_width - 7, width: addcarBtn_width, height: addcarBtn_width)
        
        addCar.setBackgroundImage(UIImage(named:"jia"), for: .normal)
        addCar.addTarget(self, action: #selector(addGoodsToCar(btn:)), for: .touchUpInside)
        self.addSubview(addCar)
        
        addAndCut = AddAndCutView(frame: CGRect(x: self.frame.width - addcarBtn_width * 13/5 - 5, y: self.frame.height - addcarBtn_width - 7, width: addcarBtn_width * 13/5, height: addcarBtn_width))
        addAndCut.addBtn.addTarget(self, action: #selector(addGoodsCount), for: .touchUpInside)
        addAndCut.cutBtn.addTarget(self, action: #selector(cutGoodsCount), for: .touchUpInside)
        addAndCut.isHidden = true
        self.addSubview(addAndCut)
        
        
        
        //cell底部的线条
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 0.6, width: self.frame.width - 5, height: 0.6)
        bottomLine.backgroundColor = setMyColor(r: 223, g: 224, b: 225, a: 1).cgColor
        self.layer.addSublayer(bottomLine)
//        method.drawLineWithColor(startX: 0, startY: self.frame.height - 0.6, wid: self.frame.width - 5, hei: 0.6, lineColor: setMyColor(r: 223, g: 224, b: 225, a: 1), add: self)
        //侧边线条
//        let leftLine = CALayer()
//        let rightLine = CALayer()
        self.drawItemLine(startX: 0, line: leftLine)
        self.drawItemLine(startX: self.frame.width - 0.6, line: rightLine)
        
        //已售罄图片
        sallerImage.frame = CGRect(x: 0, y: 0, width: goodsImage.frame.width, height: goodsImage.frame.height)
        sallerImage.image = UIImage(named: "yishouqing")
        sallerImage.backgroundColor = UIColor.black
        sallerImage.isHidden = true
        sallerImage.isUserInteractionEnabled = true
        sallerImage.alpha = 0.6
        goodsImage.addSubview(sallerImage)
    }
    func addGoodsToCar(btn:UIButton){
        if method.isLogin(){
            print(goodsInfo)
            if goodsInfo["normList"].arrayValue.count > 0{
                //去选择
                delegate?.alertNormChose(goods:goodsInfo)
            }else{
                //            let norm = goodsInfo["normList"].arrayValue.count == 1 ? goodsInfo["normList"][0]["norm"].stringValue : ""
                method.addTocar(goodId: goodsInfo["commodityID"].stringValue, norm: ""){ (isSuccess) in
                    if isSuccess{
                        DispatchQueue.main.async {
                            btn.isHidden = true
                            self.addAndCut.isHidden = false
                            self.goodsNumInCar += 1
                        }
                        //self.addAndCut.isHidden = false
                    }
                }
            }
        }else{
            self.needLoginApp(vc: selfViewController)
        }
        
    }
    func needLoginApp(vc:UIViewController){
        let alert = UIAlertController(title: nil, message: "需要登录才能加入购物车", preferredStyle: .alert)
        let act1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let act2 = UIAlertAction(title: "立即登录", style: .default, handler: { (alt) in
            vc.pushToNext(vc: LoginAppViewController())
        })
        alert.addAction(act1)
        alert.addAction(act2)
        vc.present(alert, animated: true, completion: nil)
    }
    //
    func addGoodsCount(){
        if goodsInfo["normList"].arrayValue.count > 0{
            //去选择
            delegate?.alertNormChose(goods:goodsInfo)
        }else{
            //            let norm = goodsInfo["normList"].arrayValue.count == 1 ? goodsInfo["normList"][0]["norm"].stringValue : ""
            method.addTocar(goodId: goodsInfo["commodityID"].stringValue, norm: ""){ (isSuccess) in
                print(isSuccess)
                if isSuccess{
                    self.goodsNumInCar += 1
                }
            }
        }
//        let norm = goodsInfo["normList"].arrayValue.count == 1 ? goodsInfo["normList"][0]["norm"].stringValue : ""
        
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
