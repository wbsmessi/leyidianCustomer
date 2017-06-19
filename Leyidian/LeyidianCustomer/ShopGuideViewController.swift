//
//  ShopGuideViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class ShopGuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setTitleView(title: "购物指南", canBack: true)
        let vc = LYDWebViewController()
        vc.nav_title = "购物指南"
        vc.loadUrl = shareHeaderUrl + "/appmanager/getUserShop"
        self.view.addSubview(vc.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
