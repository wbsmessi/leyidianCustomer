//
//  ConvertScoreViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class ConvertScoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setTitleView(title: "积分兑换", canBack: true)
        // Do any additional setup after loading the view.
        let vc = LYDWebViewController()
        vc.nav_title = "积分兑换"
        vc.loadUrl = "http://www.baidu.com"
        self.view.addSubview(vc.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
