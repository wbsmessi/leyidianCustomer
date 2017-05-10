//
//  CarViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/2/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class CarViewController: UIViewController {

    var json:JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "购物车", canBack: false)
        creatView()
        // Do any additional setup after loading the view.
    }
    func creatView() {
        let noview = NoStoreView(frame: CGRect(x: 0, y: nav_height, width: app_width, height: app_height - 113))
        self.view.addSubview(noview)
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
