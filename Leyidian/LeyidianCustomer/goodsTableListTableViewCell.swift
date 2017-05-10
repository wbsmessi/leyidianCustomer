//
//  goodsTableListTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/8.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class goodsTableListTableViewCell: UITableViewCell {

    //height 100
    var cell_width:CGFloat!
    var method = Methods()
    var goodsInfo:JSON!
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
        goodsImage.backgroundColor = UIColor.red
        method.creatLabel(lab: goodsName, x: goodsImage.rightPosition() + 10, y: 10, wid: self.frame.width - (goodsImage.rightPosition() + 20) , hei: 25, textString: "农夫山泉", textcolor: UIColor.black, textFont: 16, superView: self)
        
        method.creatLabel(lab: goodsDetail, x: goodsName.frame.origin.x, y: goodsName.bottomPosition(), wid: goodsName.frame.width, hei: 25, textString: "400ml大瓶装*10", textcolor: UIColor.gray, textFont: 14, superView: self)
        
        
        method.creatLabel(lab: goodsOldPrice, x: goodsName.frame.origin.x, y: goodsDetail.bottomPosition(), wid: 100, hei: 15, textString: "", textcolor: UIColor.gray, textFont: 12, superView: self)
        
        
        let icon = UILabel()
        method.creatLabel(lab: icon, x: goodsName.frame.origin.x, y: goodsOldPrice.bottomPosition() + 7, wid: 10, hei: 15, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: self)
        
        method.creatLabel(lab: goodsPrice, x: icon.rightPosition(), y: goodsOldPrice.bottomPosition(), wid: 100, hei: 25, textString: "303.00", textcolor: MyMoneyColor(), textFont: 16, superView: self)
        goodsPrice.sizeThatFits(CGSize(width: 60, height: 20))
//        goodsPrice.backgroundColor = UIColor.red
        
        
        addCar.frame = CGRect(x: cell_width - 30, y: 70, width: 25, height: 25)
        addCar.setBackgroundImage(UIImage(named:"jia"), for: .normal)
        addCar.addTarget(self, action: #selector(addGoodsToCar(btn:)), for: .touchUpInside)
        self.addSubview(addCar)
//        -100-80
        addAndCut = AddAndCutView(frame: CGRect(x: cell_width - 80, y: 70, width: 75, height: 25))
        addAndCut.addBtn.addTarget(self, action: #selector(addGoodsCount), for: .touchUpInside)
        addAndCut.cutBtn.addTarget(self, action: #selector(cutGoodsCount), for: .touchUpInside)
        addAndCut.isHidden = true
        self.addSubview(addAndCut)
    }
    func addGoodsToCar(btn:UIButton){
        
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
