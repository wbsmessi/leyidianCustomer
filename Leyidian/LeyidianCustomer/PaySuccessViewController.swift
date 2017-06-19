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
        textview.frame = CGRect(x: 20, y: lab.bottomPosition() + 10, width: app_width - 40, height: 120)
        textview.font = UIFont.systemFont(ofSize: 13)
        textview.isScrollEnabled = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 12),NSParagraphStyleAttributeName:paragraphStyle]
        textview.attributedText = NSAttributedString(string: "   感谢您使用乐易点！我们将在预计时间内准时将商品送达你手中，如有任何疑问欢迎致电乐易点官方客服400-888-8008，乐易点竭诚为你提供最优质的便利购物体验", attributes: attributes)
        
        
        textview.textColor = UIColor.gray
        self.view.addSubview(textview)
        
        let leftBtn = UIButton()
        method.creatButton(btn: leftBtn, x: (app_width - 160)/3, y: textview.bottomPosition() + 30, wid: 80, hei: 40, title: "回到首页", titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.white, superView: self.view)
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        leftBtn.layer.cornerRadius = 5
        leftBtn.layer.borderColor = UIColor.gray.cgColor
        leftBtn.layer.borderWidth = 0.6
        
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: leftBtn.rightPosition() + (app_width - 160)/3, y: textview.bottomPosition() + 30, wid: 80, hei: 40, title: "查看订单", titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.white, superView: self.view)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        rightBtn.layer.cornerRadius = 5
        rightBtn.layer.borderColor = UIColor.gray.cgColor
        rightBtn.layer.borderWidth = 0.6
        
    }
    
    func leftBtnClick(){
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex=0
        }
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
