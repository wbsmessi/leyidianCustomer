//
//  NoStoreView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/14.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

//自定义无商家提示view
class NoStoreView: UIView {
    var method = Methods()
    var superVC:UIViewController?
    override init(frame:CGRect) {
        super.init(frame:frame)
        creatView()
    }
    func creatView() {
        let bgview = UIView()
        bgview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        bgview.backgroundColor = MyGlobalColor()
        self.addSubview(bgview)
        
        let image = UIImageView()
        image.frame = CGRect(x: self.frame.width/3, y: self.frame.height/5, width: self.frame.width/3, height: self.frame.width/3)
        image.image = UIImage(named: "fen-weikait")
        image.contentMode = .scaleAspectFit
        self.addSubview(image)
        
        let lab = UILabel()
        lab.numberOfLines = 2
        lab.lineBreakMode = .byCharWrapping
        lab.textAlignment = .center
        method.creatLabel(lab: lab, x: self.frame.width/4, y: image.bottomPosition(), wid: self.frame.width/2, hei: 50, textString: "很抱歉，你的位置暂无可服务商家！", textcolor: UIColor.gray, textFont: 13, superView: self)
        
        let tofeedback = UIButton()
        method.creatButton(btn: tofeedback, x: self.frame.width/4, y: lab.bottomPosition(), wid: self.frame.width/2, hei: 40, title: "给我们意见反馈", titlecolor: UIColor.white, titleFont: 13, bgColor: setMyColor(r: 254, g: 184, b: 0, a: 1), superView: self)
        tofeedback.layer.cornerRadius = tofeedback.frame.height/2
        tofeedback.addTarget(superVC, action: #selector(tofeedbackClick), for: .touchUpInside)
    }
    func tofeedbackClick(){
//        print("1111")
        superVC?.pushToNext(vc: FeedBackViewController())
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
