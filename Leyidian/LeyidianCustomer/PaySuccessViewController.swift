//
//  PaySuccessViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/4/6.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class PaySuccessViewController: UIViewController {

    var method = Methods()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "支付成功", canBack: false)
        creatView()
        // Do any additional setup after loading the view.
    }
    func creatView(){
        let back_btn = UIButton()
        back_btn.setImage(UIImage(named:"fanhui"), for: .normal)
        //            back_btn.backgroundColor = UIColor.red
        back_btn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
        back_btn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        self.view.addSubview(back_btn)
        
        let successImg = UIImageView()
        method.creatImage(img: successImg, x: app_width * 0.43, y: 150, wid: app_width * 0.14, hei: app_width * 0.2, imgName: "zhifuchenggong", imgMode: .scaleAspectFit, superView: self.view)
        
        let lab = UILabel()
        method.creatLabel(lab: lab, x: 0, y: successImg.bottomPosition(), wid: app_width, hei: 40, textString: "支付成功", textcolor: MyAppColor(), textFont: 14, superView: self.view)
        lab.textAlignment = .center
        
        let textview = UITextView()
        textview.isEditable = false
        textview.frame = CGRect(x: 20, y: lab.bottomPosition() + 10, width: app_width - 40, height: 80)
        textview.font = UIFont.systemFont(ofSize: 13)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 12),NSParagraphStyleAttributeName:paragraphStyle]
        textview.attributedText = NSAttributedString(string: "   四级考试等级考试倒计时短裤时间快到家打开电视机啊叫啊健身卡手机壳抖擞精神啊就是大多数都颠三倒四的时尚大方方法改变颠三倒四的是对的是法国", attributes: attributes)
        
        
        textview.textColor = UIColor.gray
        self.view.addSubview(textview)
        
        let leftBtn = UIButton()
        method.creatButton(btn: leftBtn, x: app_width/4, y: textview.bottomPosition() + 30, wid: app_width/4 - 30, hei: (app_width/4 - 30) * 0.5, title: "回到首页", titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.white, superView: self.view)
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        leftBtn.layer.cornerRadius = 5
        leftBtn.layer.borderColor = UIColor.gray.cgColor
        leftBtn.layer.borderWidth = 0.6
        
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: app_width/2 + app_width/12, y: textview.bottomPosition() + 30, wid: app_width/4 - 30, hei: (app_width/4 - 30) * 0.5, title: "查看订单", titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.white, superView: self.view)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        rightBtn.layer.cornerRadius = 5
        rightBtn.layer.borderColor = UIColor.gray.cgColor
        rightBtn.layer.borderWidth = 0.6
        
    }
    
    func leftBtnClick(){
        self.backToRootPage()
    }
    
    func rightBtnClick(){
        let vc = OrderViewController()
        vc.orderType = orderTypeEnum.allOrder
        self.pushToNext(vc: vc)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
