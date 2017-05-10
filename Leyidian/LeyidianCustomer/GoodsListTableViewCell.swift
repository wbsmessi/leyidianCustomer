//
//  GoodsListTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/2.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsListTableViewCell: UITableViewCell {

    //height 100
    var method = Methods()
    var goodsInfo:JSON!
    var imageUrl = ""{
        didSet{
            method.loadImage(imgUrl: imageUrl, Img_View: goodsImage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        creatView()
    }
    
    let goodsImage = UIImageView()
    let goodsName = UILabel()
    let goodsDetail = UILabel()
    let goodsPrice = UILabel()
    let goodsCount = UILabel()
    func creatView(){
        method.creatImage(img: goodsImage, x: 15, y: 10, wid: 80, hei: 80, imgName: "", imgMode: .scaleAspectFit, superView: self)
        
        method.creatLabel(lab: goodsName, x: goodsImage.rightPosition() + 10, y: 10, wid: self.frame.width - (goodsImage.rightPosition() + 20) , hei: 25, textString: "农夫山泉", textcolor: UIColor.black, textFont: 16, superView: self)
        
        method.creatLabel(lab: goodsDetail, x: goodsName.frame.origin.x, y: goodsName.bottomPosition(), wid: goodsName.frame.width, hei: 25, textString: "400ml大瓶装*10", textcolor: UIColor.gray, textFont: 14, superView: self)
        
        
        let icon = UILabel()
        method.creatLabel(lab: icon, x: goodsName.frame.origin.x, y: goodsDetail.bottomPosition() + 14, wid: 10, hei: 15, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: self)
        
        
        method.creatLabel(lab: goodsPrice, x: icon.rightPosition(), y: goodsDetail.bottomPosition() + 10, wid: 100, hei: 20, textString: "303.00", textcolor: MyMoneyColor(), textFont: 16, superView: self)
        goodsPrice.sizeThatFits(CGSize(width: 60, height: 20))
        //        goodsPrice.backgroundColor = UIColor.red
        
        
//        addCar.frame = CGRect(x: app_width - 100 - 30, y: 70, width: 25, height: 25)
        goodsCount.textAlignment = .right
        method.creatLabel(lab: goodsCount, x: app_width - 120, y: goodsDetail.bottomPosition() + 10, wid: 100, hei: 25, textString: "", textcolor: UIColor.gray, textFont: 14, superView: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
