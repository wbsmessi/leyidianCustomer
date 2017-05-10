//
//  ItemInfo.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/30.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class ItemInfoView: UIView {

    var method = Methods()
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect,title:String,info:String,infoColor:UIColor) {
        super.init(frame: frame)
        let leftLab = UILabel()
        method.creatLabel(lab: leftLab, x: 0, y: 0, wid: self.frame.width/2, hei: self.frame.height, textString: title, textcolor: UIColor.gray, textFont: 12, superView: self)
        
        let rightLab = UILabel()
        method.creatLabel(lab: rightLab, x: leftLab.rightPosition(), y: 0, wid: self.frame.width/2, hei: self.frame.height, textString: info, textcolor: infoColor, textFont: 12, superView: self)
        rightLab.textAlignment = .right
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
