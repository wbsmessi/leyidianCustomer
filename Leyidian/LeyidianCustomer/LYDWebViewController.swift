//
//  LYDWebViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/27.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class LYDWebViewController: UIViewController {

    var nav_title:String = ""
    var loadUrl:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: nav_title, canBack: true)
        creatView()
        // Do any additional setup after loading the view.
    }
    func creatView(){
        let web = UIWebView()
        web.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height)
        self.view.addSubview(web)
        if let url = URL(string: loadUrl){
            let request = URLRequest(url: url)
            web.loadRequest(request)
        }
        
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
