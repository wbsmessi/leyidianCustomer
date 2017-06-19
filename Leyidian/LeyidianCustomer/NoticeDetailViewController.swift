//
//  NoticeDetailViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/27.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeDetailViewController: UIViewController,UIWebViewDelegate {

    var noticeInfo:JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "公告详情", canBack: true)
        // Do any additional setup after loading the view.
        creatView()
    }
    let detaildWeb = UIWebView()
    func creatView(){
        let method = Methods()
        ////加title。，消息内容时间，下面在显示web内容
        let noticeTitle = UILabel()
        noticeTitle.lineBreakMode = .byCharWrapping
        noticeTitle.numberOfLines = 2
        method.creatLabel(lab: noticeTitle, x: 10, y: nav_height, wid: app_width - 20, hei: 40, textString: noticeInfo["title"].stringValue, textcolor: myAppBlackColor(), textFont: 15, superView: self.view)
        
        let timelab = UILabel()
        method.creatLabel(lab: timelab, x: 10, y: noticeTitle.bottomPosition(), wid: app_width - 20, hei: 40, textString: method.convertTime(time: noticeInfo["createDate"].doubleValue), textcolor: myAppGryaColor(), textFont: 12, superView: self.view)
        timelab.textAlignment = .right
        
        detaildWeb.frame = CGRect(x: 0, y: timelab.bottomPosition(), width: app_width, height: app_width - nav_height)
        //        goodsDetaildWeb.delegate = self
//        detaildWeb.delegate = self
        let htmlStr = noticeInfo["content"].stringValue.trimmingCharacters(in: CharacterSet(charactersIn: "\\"))
        print(htmlStr)
        detaildWeb.backgroundColor = MyGlobalColor()
        detaildWeb.loadHTMLString(htmlStr, baseURL: nil)
        self.view.addSubview(detaildWeb)
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
