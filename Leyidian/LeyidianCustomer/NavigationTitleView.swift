//
//  NavigationTitleView.swift
//  SourceOfFruit
//
//  Created by 马志敏 on 2016/12/29.
//  Copyright © 2016年 DEC.MA. All rights reserved.
//

import UIKit

class NavigationTitleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: app_width, height: 64)
    }
    var method = Methods()
    // 标题
    lazy var navi_title:UILabel={
        let navi_title = UILabel()
        return navi_title
    }()
    //  返回按钮
    lazy var back_btn:UIButton={
        let back_btn = UIButton()
        return back_btn
    }()
    func init_Titleview(title:String,canBack:Bool,vc:UIViewController){
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 63.4, width: app_width, height: 0.6)
        topBorder.backgroundColor = setMyColor(r: 204, g: 204, b: 204, a: 1).cgColor
        self.layer.addSublayer(topBorder)
        vc.navigationController?.navigationBar.isHidden = true
        self.backgroundColor = UIColor.white
        navi_title.textAlignment = .center
        method.creatLabel(lab: navi_title, x: app_width/4, y: 20, wid: app_width/2, hei: 44, textString: title, textcolor: setMyColor(r: 74, g: 74, b: 74, a: 1), textFont: 18, superView: self)
        
        if canBack{
            back_btn.setImage(UIImage(named:"fanhui"), for: .normal)
            back_btn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
            self.addSubview(back_btn)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
