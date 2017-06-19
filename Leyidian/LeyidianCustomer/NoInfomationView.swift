//
//  NoInfomationView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/26.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class NoInfomationView: UIView {
    var method = Methods()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = MyGlobalColor()
        creatView()
    }
    
    let feedbackBtn = UIButton()
    func creatView(){
        let bgview = UIImageView()
        bgview.frame = CGRect(x: self.frame.width/3, y: self.frame.height/4 - 20, width: self.frame.width/3, height: self.frame.width/3)
        bgview.image = UIImage(named:"wufuwu")
        bgview.contentMode = .scaleAspectFit
        self.addSubview(bgview)
        
        let title = UILabel()
        method.creatLabel(lab: title, x: self.frame.width/3, y: bgview.bottomPosition() + 10, wid: self.frame.width/3, hei: 40, textString: "很抱歉，你所在的位置暂无可服务商家", textcolor: myAppGryaColor(), textFont: 12, superView: self)
        title.textAlignment = .center
        title.numberOfLines = 2
        title.lineBreakMode = .byCharWrapping
        
        
        method.creatButton(btn: feedbackBtn, x: title.frame.origin.x - 10, y: title.bottomPosition() + 20, wid: title.frame.width + 20, hei: title.frame.width/3, title: "给我们意见反馈", titlecolor: UIColor.white, titleFont: 13, bgColor: setMyColor(r: 255, g: 186, b: 1, a: 1), superView: self)
        feedbackBtn.layer.cornerRadius = feedbackBtn.frame.height/2
    }
    func btnClick(){
//        self.removeFromSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
