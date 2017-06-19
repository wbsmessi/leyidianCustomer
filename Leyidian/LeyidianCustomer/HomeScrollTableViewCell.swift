//
//  HomeScrollTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/3.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol HomeScrollTableViewDelegate {
    func goodsChose(goodsId:String)
    func HomeScrollTableViewNormChose(goodsInfo:JSON)
}
class HomeScrollTableViewCell: UITableViewCell {

    var selfCurrentVC:UIViewController!
    var selfHeight = (app_width-20)/2
    var delegate:HomeScrollTableViewDelegate?
    var goodsArr:[JSON]!
    var goodsStatus:String = ""{
        didSet{
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var scrollView:UIScrollView!
    func initView(goodsInfo:[JSON]) {
        print("zheli")
        
        self.goodsArr = goodsInfo
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: app_width, height: selfHeight)
//        scrollView.backgroundColor = MyGlobalColor()
        scrollView.contentSize = CGSize(width: selfHeight * 3/4 * CGFloat(goodsInfo.count), height: selfHeight)
        if scrollView.contentSize.width > scrollView.frame.width{
            //需要一个更多的按钮
        }
        self.addSubview(scrollView)
        //如果存在先删除原来的
        for item in scrollView.subviews{
            item.removeFromSuperview()
        }
        for i in 0..<goodsInfo.count{
            
            creatItem(X: CGFloat(i) * (selfHeight * 3/4+5), index:i,goodsInfo:goodsInfo[i],add:scrollView)
        }
    }
    var method = Methods()
    
    func creatItem(X:CGFloat,index:Int,goodsInfo:JSON,add:UIView){
        
//        存储可能返回来的购物车id，方便减数量。因为默认是0的时候表示还没有购物车id，
        let cartid = goodsInfo["cartID"].intValue
        if cartid > 0{
            MyUserInfo.setValue("\(cartid)", forKey: userdefaultKey.nowShopCarId.rawValue)
        }
        let goodsImage = UIImageView()
        let goodsName = UILabel()
        let goodsDetail = UILabel()
        let nowPrice = UILabel()
        let oldPrice = UILabel()
        let addCar = UIButton()
        let bgView = UIView()
        
        bgView.tag=100+index//tag值+100
        bgView.frame = CGRect(x: X, y: 0, width: selfHeight * 3/4, height: selfHeight)
        bgView.backgroundColor = UIColor.white
        add.addSubview(bgView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(goodsChose(tap:)))
        bgView.addGestureRecognizer(tap)
        
        let line = CALayer()
        line.frame=CGRect(x: bgView.frame.width-0.6, y: 0, width: 0.6, height: bgView.frame.height)
        line.backgroundColor = setMyColor(r: 223, g: 224, b: 225, a: 1).cgColor
        bgView.layer.addSublayer(line)
        
        method.creatImage(img: goodsImage, x: 5, y: 5, wid: bgView.frame.width - 10, hei: bgView.frame.height - 80, imgName: "", imgMode: .scaleAspectFit, superView: bgView)
        goodsImage.contentMode = .scaleAspectFill
        method.loadImage(imgUrl: goodsInfo["cover"].stringValue, Img_View: goodsImage)
        
        if !(goodsInfo["status"].stringValue == "1"){
            //已售罄
            let image = UIImageView()
            image.frame = CGRect(x: 0, y: 0, width: goodsImage.frame.width, height: goodsImage.frame.height)
            image.image = UIImage(named: "yishouqing")
            image.backgroundColor = UIColor.black
            image.isUserInteractionEnabled = true
            image.alpha = 0.6
            goodsImage.addSubview(image)
        }
        
        method.creatLabel(lab: goodsName, x: 5, y: goodsImage.bottomPosition()+5, wid: bgView.frame.width - 10, hei: 15, textString: goodsInfo["commodityName"].stringValue, textcolor: myAppBlackColor(), textFont: 14, superView: bgView)
        
        method.creatLabel(lab: goodsDetail, x: 5, y: goodsName.bottomPosition()+3, wid: goodsName.frame.width, hei: 12, textString: goodsInfo["commodityRemark"].stringValue, textcolor: UIColor.gray, textFont: 10, superView: bgView)
        
        method.creatLabel(lab: oldPrice, x: 5, y: goodsDetail.bottomPosition()+3, wid: goodsName.frame.width, hei: 12, textString: "¥"+goodsInfo["retailPrice"].doubleValue.getMoney(), textcolor: UIColor.lightGray, textFont: 12, superView: bgView)
        
        let moneyIcon=UILabel()
        method.creatLabel(lab: moneyIcon, x: 5, y: oldPrice.bottomPosition() + 7, wid: 10, hei: 15, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: bgView)
    
//        var salePrice = goodsInfo["retailPrice"].doubleValue.getMoney()
//        if goodsInfo["commodityTypes"].stringValue != ""{
//            salePrice = goodsInfo["discountPrice"].doubleValue.getMoney()
//        }
        ///////////
        var salePrice = goodsInfo["retailPrice"].doubleValue.getMoney()
        
        if method.hasStringInArr(arrStr: goodsInfo["commodityTypes"].stringValue){
            salePrice = goodsInfo["discountPrice"].doubleValue.getMoney()
            oldPrice.isHidden = false
        }else{
            oldPrice.isHidden = true
        }
        ////////////
        method.creatLabel(lab: nowPrice, x: moneyIcon.rightPosition(), y: oldPrice.bottomPosition(), wid: bgView.frame.width-10, hei: 25, textString: salePrice, textcolor: MyMoneyColor(), textFont: 16, superView: bgView)
        if app_width >= 330{
            nowPrice.font = UIFont(name: "Helvetica-Bold", size: 16)
        }else{
            nowPrice.font = UIFont(name: "Helvetica-Bold", size: 14)
        }
        
        addCar.tag = index + 10
//        addCar.frame = CGRect(x: bgView.frame.width - 25, y: bgView.frame.height - 25, width: 20, height: 20)
        if app_width <= 330{
            //5s及以下
            addCar.frame = CGRect(x: bgView.frame.width - 20, y: bgView.frame.height - 20, width: 15, height: 15)
        }else{
            addCar.frame = CGRect(x: bgView.frame.width - 25, y: bgView.frame.height - 25, width: 20, height: 20)
        }
//        addCar.setBackgroundImage(UIImage(named:"jia"), for: .normal)
        addCar.setImage(UIImage(named:"jia"), for: .normal)
        addCar.addTarget(self, action: #selector(firstAddGoods(btn:)), for: .touchUpInside)
//        addCar
        bgView.addSubview(addCar)
//        var addAndCut:AddAndCutView!
        var addAndCut:AddAndCutView!
        //加一个5s屏幕的适配
        if app_width <= 330{
//            5s及以下
            addAndCut = AddAndCutView(frame: CGRect(x: bgView.frame.width - 55, y: bgView.frame.height - 20, width: 50, height: 15))
        }else{
            addAndCut = AddAndCutView(frame: CGRect(x: bgView.frame.width - 70, y: bgView.frame.height - 25, width: 65, height: 20))
        }
        addAndCut.tag = index + 1000//
        if goodsInfo["commodityNum"].intValue > 0{
            addAndCut.nowCount = goodsInfo["commodityNum"].intValue
            addCar.isHidden = true
            addAndCut.isHidden = false
        }else{
            addCar.isHidden = false
            addAndCut.isHidden = true
        }
        addAndCut.addBtn.addTarget(self, action: #selector(addGoodsToCar(btn:)), for: .touchUpInside)
        addAndCut.cutBtn.addTarget(self, action: #selector(cutGoodsFromCar(btn:)), for: .touchUpInside)
        bgView.addSubview(addAndCut)
        
        oldPrice.sizeToFit()
        let centerLine = CALayer()
        centerLine.frame=CGRect(x: 0, y: oldPrice.frame.height/2, width: oldPrice.frame.width, height: 0.6)
        centerLine.backgroundColor = UIColor.lightGray.cgColor
        oldPrice.layer.addSublayer(centerLine)
        
        method.drawLineWithColor(startX: 5, startY: selfHeight - 0.6, wid: selfHeight * 3/4 - 5, hei: 0.6, lineColor: setMyColor(r: 223, g: 224, b: 225, a: 1), add: bgView)
    }
    func goodsChose(tap:UIGestureRecognizer){
        //传goodsid
        let tag = tap.view!.tag
        let goodsid = goodsArr[tag-100]["commodityID"].stringValue
        delegate?.goodsChose(goodsId: goodsid)
    }
    //首次点击添加
    func firstAddGoods(btn:UIButton){
        if method.isLogin(){
            print(goodsArr)
            if goodsArr[btn.tag - 10]["normList"].arrayValue.count > 0{
                //去选择
                delegate?.HomeScrollTableViewNormChose(goodsInfo:goodsArr[btn.tag - 10])
            }else{
                method.addTocar(goodId: goodsArr[btn.tag - 10]["commodityID"].stringValue, norm: ""){ (isSuccess) in
                    if isSuccess{
                        DispatchQueue.main.async {
                            btn.isHidden = true
                            if let view = self.viewWithTag(btn.tag - 10 + 1000) as? AddAndCutView{
                                (view as AddAndCutView).isHidden = false
                                (view as AddAndCutView).nowCount = 1
                            }
                        }
                    }
                }
            }
        }else{
            needLoginApp(vc: selfCurrentVC)
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
//    增加商品数量
    func addGoodsToCar(btn:UIButton){
        if goodsArr[btn.superview!.tag - 1000]["normList"].arrayValue.count > 0{
            //去选择
            delegate?.HomeScrollTableViewNormChose(goodsInfo:goodsArr[btn.superview!.tag - 1000])
        }else{
            method.addTocar(goodId: goodsArr[btn.superview!.tag - 1000]["commodityID"].stringValue, norm: ""){ (isSuccess) in
                print(isSuccess)
                if isSuccess{
                    if let view = self.viewWithTag(btn.superview!.tag) as? AddAndCutView{
                        //                    (view as AddAndCutView).isHidden = false
                        (view as AddAndCutView).nowCount += 1
                    }
                }
            }
        }
        
    }
//    减少商品数量
    func cutGoodsFromCar(btn:UIButton){
        method.cutFromcar(goodsId: goodsArr[btn.superview!.tag - 1000]["commodityID"].stringValue){ (isSuccess) in
            if isSuccess{
                if let view = self.viewWithTag(btn.superview!.tag) as? AddAndCutView{
                    
                    (view as AddAndCutView).nowCount -= 1
                    if (view as AddAndCutView).nowCount <= 0{
                        DispatchQueue.main.async {
                            (view as AddAndCutView).isHidden = true
                            if let btn = self.viewWithTag(btn.superview!.tag - 1000 + 10) as? UIButton{
                                (btn as UIButton).isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
//    func reloadScroll(goodsInfo:[String]){
//        scrollView.removeFromSuperview()
//        initView(goodsInfo: goodsInfo)
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
