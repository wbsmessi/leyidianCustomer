//
//  orderInfoView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/24.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class orderInfoView: UIView {
    //订单详情的订单信息那个部分
    var method = Methods()
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    func creatView(){
        let dingdanxinxi = UILabel()
        method.creatLabel(lab: dingdanxinxi, x: 15, y: 0, wid: 150, hei: 30, textString: "订单信息", textcolor: UIColor.gray, textFont: 12, superView: self)
        method.drawLine(startX: 0, startY: 30, wid: self.frame.width, hei: 0.6, add: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
