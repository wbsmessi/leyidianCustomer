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
        vc.loadUrl = "http://www.baidu.com"
        self.view.addSubview(vc.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
