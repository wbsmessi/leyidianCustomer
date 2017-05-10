//
//  HomeAdvertisingView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/10.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeAdvertisingView: UIView {

    var method = Methods()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func initView(imgJSON:[JSON]){
        for item in self.subviews{
            //如果已存在，先删除
            item.removeFromSuperview()
        }
        for i in 0..<imgJSON.count{
            let img = UIImageView()
            switch i {
            case 0:
                img.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width/3 - 5)
                print(img.frame)
            case 1:
                img.frame = CGRect(x: 0, y: self.frame.width/3, width: self.frame.width/2-5, height: self.frame.width/2)
            case 2:
                img.frame = CGRect(x: self.frame.width/2, y: self.frame.width/3, width: self.frame.width/2, height: self.frame.width/4)
            case 3:
                img.frame = CGRect(x: self.frame.width/2, y: self.frame.width * 7/12, width: self.frame.width/4-3, height: self.frame.width/4)
            case 4:
                img.frame = CGRect(x: self.frame.width * 3/4, y: self.frame.width * 7/12, width: self.frame.width/4, height: self.frame.width/4)
            default:
                _=""
            }
            img.tag=i
            img.contentMode = .scaleAspectFill
            method.loadImage(imgUrl: imgJSON[i]["imgUrl"].stringValue, Img_View: img)
            self.addSubview(img)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
