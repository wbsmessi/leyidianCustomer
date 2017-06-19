//
//  StoreClosedView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/26.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class StoreClosedView: UIView {

    var method = Methods()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        creatView()
    }
    func creatView(){
        let bgview = UIView()
        let height = (app_width - 40) * 3/4
        bgview.frame = CGRect(x: 20, y: app_height/2 - height/2, width: app_width - 40, height: height)
        bgview.backgroundColor = UIColor.white
        bgview.layer.cornerRadius = 5
        self.addSubview(bgview)
        
        
        let image = UIImageView(image: UIImage(named:"close"))
        image.frame = CGRect(x: 0, y: 10, width: bgview.frame.width, height: bgview.frame.height/2 - 30)
        image.contentMode = .scaleAspectFit
        bgview.addSubview(image)
        
        let title = UILabel()
        method.creatLabel(lab: title, x: 0, y: image.bottomPosition() + 10, wid: bgview.frame.width, hei: bgview.frame.height/8, textString: "当前地标店铺已打烊", textcolor: myAppBlackColor(), textFont: 16, superView: bgview)
        title.textAlignment = .center
        
        let closeTime = UILabel()
        method.creatLabel(lab: closeTime, x: 0, y: title.bottomPosition(), wid: bgview.frame.width, hei: bgview.frame.height/8, textString: "店铺营业时间\(storeInfomation!.businessHours!)", textcolor: myAppBlackColor(), textFont: 16, superView: bgview)
        closeTime.textAlignment = .center
        
        let btnwidth = bgview.frame.width - 40
        let OBtn = UIButton()
        method.creatButton(btn: OBtn, x: 20, y: closeTime.bottomPosition() + 10, wid: btnwidth, hei: btnwidth/7.73, title: "哦", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: bgview)
        OBtn.setBackgroundImage(UIImage(named:"anniu"), for: .normal)
        OBtn.addTarget(self, action: #selector(OBtnClick), for: .touchUpInside)
        
    }
    func OBtnClick(){
        self.removeFromSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
