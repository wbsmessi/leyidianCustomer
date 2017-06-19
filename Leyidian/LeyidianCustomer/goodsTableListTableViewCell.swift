//
//  goodsTableListTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/8.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol goodsTableListTableViewCellDelegate {
    func goodsTableListAlertNormChose(goods:JSON)
}
class goodsTableListTableViewCell: UITableViewCell {

    //height 100
    var cell_width:CGFloat!
    var method = Methods()
    var goodsInfo:JSON!
    var delegate:goodsTableListTableViewCellDelegate?
    //
    var currentVC:UIViewController!
    var goodsStatus:String = ""{
        didSet{
            if !(goodsStatus == "1"){
                //已售罄
                let image = UIImageView()
                image.frame = CGRect(x: 0, y: 0, width: goodsImage.frame.width, height: goodsImage.frame.height)
                image.image = UIImage(named: "yishouqing")
                image.backgroundColor = UIColor.black
                image.isUserInteractionEnabled = true
                image.alpha = 0.6
                goodsImage.addSubview(image)
            }
        }
    }
    var goodsNumInCar:Int = 0{
        didSet{
            if goodsNumInCar <= 0 {
                DispatchQueue.main.async {
                    self.addCar.isHidden = false
                    self.addAndCut.isHidden = true
                }
            }
            addAndCut.nowCount = goodsNumInCar
        }
    }
    var imageUrl = ""{
        didSet{
            method.loadImage(imgUrl: imageUrl, Img_View: goodsImage)
        }
    }
    var oldPrice = ""{
        didSet{
//            goodsOldPrice.backgroundColor = UIColor.red
            goodsOldPrice.text = oldPrice
            goodsOldPrice.sizeToFit()
            let line = CALayer()
            line.frame=CGRect(x: 0, y: goodsOldPrice.frame.height/2, width: goodsOldPrice.frame.width, height: 0.6)
            line.backgroundColor = UIColor.gray.cgColor
            goodsOldPrice.layer.addSublayer(line)
        }
    }
    //那个小标志，特价，精品什么的
    let goodsActiveTypeImg = UIImageView()
    
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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        creatView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print(self.contentView.frame)
//        print(self.frame)
        
    }
    let goodsImage = UIImageView()
    let goodsName = UILabel()
    let goodsDetail = UILabel()
    let goodsPrice = UILabel()
    let goodsOldPrice = UILabel()
    let addCar = UIButton()
    var addAndCut:AddAndCutView!
    
    func creatView(cell_wid:CGFloat){
        self.cell_width = cell_wid
        method.creatImage(img: goodsImage, x: 15, y: 10, wid: 80, hei: 80, imgName: "", imgMode: .scaleAspectFit, superView: self)
//        goodsImage.backgroundColor = UIColor.red
        
        method.creatImage(img: goodsActiveTypeImg, x: 0, y: 0, wid: 30, hei: 10, imgName: "tejia", imgMode: .scaleAspectFill, superView: goodsImage)
        goodsActiveTypeImg.isHidden = true
        
        
        method.creatLabel(lab: goodsName, x: goodsImage.rightPosition() + 10, y: 10, wid: self.frame.width - (goodsImage.rightPosition() + 20) , hei: 25, textString: "农夫山泉", textcolor: myAppBlackColor(), textFont: 16, superView: self)
        
        method.creatLabel(lab: goodsDetail, x: goodsName.frame.origin.x, y: goodsName.bottomPosition(), wid: goodsName.frame.width, hei: 25, textString: "400ml大瓶装*10", textcolor: UIColor.gray, textFont: 13, superView: self)
        
        
        method.creatLabel(lab: goodsOldPrice, x: goodsName.frame.origin.x, y: goodsDetail.bottomPosition(), wid: 100, hei: 15, textString: "", textcolor: UIColor.gray, textFont: 12, superView: self)
        
        
        let icon = UILabel()
        method.creatLabel(lab: icon, x: goodsName.frame.origin.x, y: goodsOldPrice.bottomPosition() + 7, wid: 10, hei: 15, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: self)
        
        method.creatLabel(lab: goodsPrice, x: icon.rightPosition(), y: goodsOldPrice.bottomPosition(), wid: 100, hei: 25, textString: "303.00", textcolor: MyMoneyColor(), textFont: 16, superView: self)
        if app_width >= 330{
            goodsPrice.font = UIFont(name: "Helvetica-Bold", size: 16)
        }else{
            goodsPrice.font = UIFont(name: "Helvetica-Bold", size: 14)
        }
        goodsPrice.sizeThatFits(CGSize(width: 60, height: 20))
//        goodsPrice.backgroundColor = UIColor.red
        
        let addcarBtn_width:CGFloat = (app_width > 330) ? 20:16
        addCar.frame = CGRect(x: cell_width - addcarBtn_width - 10, y: 100 - addcarBtn_width - 5, width: addcarBtn_width, height: addcarBtn_width)
        addCar.setBackgroundImage(UIImage(named:"jia"), for: .normal)
        addCar.addTarget(self, action: #selector(addGoodsToCar(btn:)), for: .touchUpInside)
        self.addSubview(addCar)
//        -100-80
        addAndCut = AddAndCutView(frame: CGRect(x: cell_width - addcarBtn_width * 13/5 - 10, y: 100 - addcarBtn_width - 5, width: addcarBtn_width * 13/5, height: addcarBtn_width))
        addAndCut.addBtn.addTarget(self, action: #selector(addGoodsCount), for: .touchUpInside)
        addAndCut.cutBtn.addTarget(self, action: #selector(cutGoodsCount), for: .touchUpInside)
        addAndCut.isHidden = true
        self.addSubview(addAndCut)
    }
    func addGoodsToCar(btn:UIButton){
        if method.isLogin(){
            print(goodsInfo)
            if goodsInfo["normList"].arrayValue.count > 0{
                //去选择
                delegate?.goodsTableListAlertNormChose(goods: goodsInfo)
            }else{
                method.addTocar(goodId: goodsInfo["commodityID"].stringValue, norm: ""){ (isSuccess) in
                    if isSuccess{
                        DispatchQueue.main.async {
                            btn.isHidden = true
                            self.addAndCut.isHidden = false
                            self.goodsNumInCar += 1
                        }
                    }
                }
            }
        }else{
            needLoginApp(vc: currentVC)
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
    func addGoodsCount(){
        method.addTocar(goodId: goodsInfo["commodityID"].stringValue, norm: ""){ (isSuccess) in
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
