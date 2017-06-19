//
//  GuidePageViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/4/5.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

//自定义引导页
class GuidePageViewController: UIViewController,UIScrollViewDelegate {

    var imgCount = 4
    var superVC:HomeViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        creatView()
    }
    let btn = UIButton()
    func creatView(){
        self.automaticallyAdjustsScrollViewInsets = false
        let scroll = UIScrollView()
        scroll.delegate=self
        scroll.frame = self.view.frame
        scroll.bounces=false
        scroll.isPagingEnabled=true
        scroll.showsVerticalScrollIndicator=false
        scroll.showsHorizontalScrollIndicator=false
        scroll.contentSize = CGSize(width: app_width * CGFloat(imgCount), height: app_height)
        self.view.addSubview(scroll)
        
        Methods().creatButton(btn: btn, x: app_width * 0.35, y: app_height * 0.83, wid: app_width * 0.3, hei: app_height * 0.05, title: "", titlecolor: UIColor.white, titleFont: 16, bgColor: UIColor.clear, superView: self.view)
        btn.isHidden = true
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(turnToHome), for: .touchUpInside)
        var imgArr = ["boot-page1","boot-page2","boot-page3","boot-page4"]
        for i in 0..<imgCount{
            let img = UIImageView()
            img.frame = CGRect(x: app_width * CGFloat(i), y: 0, width: app_width, height: app_height)
            img.image = UIImage(named: imgArr[i])
            scroll.addSubview(img)
        }
    }
    func turnToHome(){
//        _=self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true) { 
            self.superVC.AddressInfo()
        }
//        self.dismiss(animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        print(scrollView.contentOffset.x)
        if scrollView.contentOffset.x >= app_width * CGFloat(imgCount-1){
            //            最后一张图
            btn.isHidden = false
        }else{
            btn.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
