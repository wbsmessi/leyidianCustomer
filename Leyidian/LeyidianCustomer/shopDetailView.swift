//
//  shopDetailView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/8.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class shopDetailView: UIView {

    var method = Methods()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatView()
    }
    
    let scroll = UIScrollView()
    func creatView() {
        
        scroll.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        scroll.backgroundColor = UIColor(white: 1, alpha: 1)
        self.addSubview(scroll)
    }
    func reloadData(data:[JSON]){
        print(data)
        DispatchQueue.main.async {
            for item in self.scroll.subviews{
                item.removeFromSuperview()
            }
//            height = 80
            let count = data.count
            let hei = self.frame.height - 40
            let wid = hei
            self.scroll.contentSize = CGSize(width: CGFloat(count) * (10 + wid), height: self.frame.height)
            
            for i in 0..<count{
                let img = UIImageView()
//                img.backgroundColor = UIColor.red
                img.frame = CGRect(x: 10 + (20 + wid) * CGFloat(i), y: 10, width: wid, height: hei)
                self.method.loadImage(imgUrl: data[i]["img"].stringValue, Img_View: img)
                img.contentMode = .scaleAspectFit
                self.scroll.addSubview(img)
                
                let lab=UILabel()
                lab.textAlignment = .center
                self.method.creatLabel(lab: lab, x: img.frame.origin.x - 10, y: hei + 10, wid: img.frame.width + 20, hei: 20, textString: data[i]["storeName"].stringValue, textcolor: UIColor.gray, textFont: 10, superView: self.scroll)
            }
        }
    }
    func animationShow(show:Bool) {
        if show{
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scroll.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.scroll.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
