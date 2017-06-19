//
//  DECAlertView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/2.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

protocol DECAlertViewDelegate {
    func DECAlertViewClick(leftClick:Bool)
}
//自定义弹窗
class DECAlertView: UIView {

    var delegate:DECAlertViewDelegate?
    var method = Methods()
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    init(frame:CGRect,title:String,message:String,leftBtnTitle:String,rightBtnTitle:String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        let bgview = UIView()
        bgview.frame = CGRect(x: 50, y: app_height/2 - (app_width - 100) * 9/32, width: app_width - 100, height: (app_width - 100) * 9/16)
        bgview.backgroundColor = MyGlobalColor()
        self.addSubview(bgview)
        
        let titleLab = UILabel()
        titleLab.textAlignment = .center
        method.creatLabel(lab: titleLab, x: 0, y: 0, wid: bgview.frame.width, hei: bgview.frame.height/3, textString: title, textcolor: UIColor.black, textFont: 18, superView: bgview)
        
        let messageLab = UILabel()
        method.creatLabel(lab: messageLab, x: 40, y: titleLab.bottomPosition(), wid: bgview.frame.width - 80, hei: bgview.frame.height/3, textString: message, textcolor: UIColor.gray, textFont: 14, superView: bgview)
        messageLab.numberOfLines = 2
        messageLab.lineBreakMode = .byCharWrapping
        messageLab.textAlignment = .center
        
        let leftBtn = UIButton()
        leftBtn.tag = 100
        method.creatButton(btn: leftBtn, x: 0, y: bgview.frame.height * 3/4, wid: bgview.frame.width/2, hei: bgview.frame.height/4, title: leftBtnTitle, titlecolor: UIColor.white, titleFont: 14, bgColor: MyAppColor(), superView: bgview)
        leftBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        let rightBtn = UIButton()
        rightBtn.tag = 200
        method.creatButton(btn: rightBtn, x: bgview.frame.width/2, y: bgview.frame.height * 3/4, wid: bgview.frame.width/2, hei: bgview.frame.height/4, title: rightBtnTitle, titlecolor: myAppBlackColor(), titleFont: 14, bgColor: UIColor.white, superView: bgview)
        rightBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
    }
    func btnClick(btn:UIButton){
        if btn.tag == 100{
//            left
            delegate?.DECAlertViewClick(leftClick: true)
        }else{
//            right
            delegate?.DECAlertViewClick(leftClick: false)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
