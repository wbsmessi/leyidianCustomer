//
//  HomeAdvertisingView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/10.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol HomeAdvertisingViewDelegate {
    func HomeAdvertisingImageClick(info:JSON)
}
class HomeAdvertisingView: UIView {

    var method = Methods()
    var delegate:HomeAdvertisingViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = MyGlobalColor()
    }
    var imageJson:[JSON] = []
    func initView(imgJSON:[JSON]){
        self.imageJson = imgJSON
        for item in self.subviews{
            //如果已存在，先删除
            item.removeFromSuperview()
        }
        
        for i in 0..<5{
            let img = UIImageView()
            img.tag = i + 100
            img.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageClick(tap:)))
            img.addGestureRecognizer(tap)
            
            let imgurl = (i < imgJSON.count) ? imgJSON[i]["imgUrl"].stringValue : "noimage"
            switch i {
            case 0:
                img.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width/3 - 5)
                method.loadImageWithDefault(imgUrl: imgurl, Img_View: img, defaultImage: "5tu_shang")
            case 1:
                img.frame = CGRect(x: 0, y: self.frame.width/3, width: self.frame.width/2-5, height: self.frame.width/2)
                method.loadImageWithDefault(imgUrl: imgurl, Img_View: img, defaultImage: "5tu_zuo")
            case 2:
                img.frame = CGRect(x: self.frame.width/2, y: self.frame.width/3, width: self.frame.width/2, height: self.frame.width/4)
                method.loadImageWithDefault(imgUrl: imgurl, Img_View: img, defaultImage: "5tu_zhong")
            case 3:
                img.frame = CGRect(x: self.frame.width/2, y: self.frame.width * 7/12, width: self.frame.width/4-3, height: self.frame.width/4)
                method.loadImageWithDefault(imgUrl: imgurl, Img_View: img, defaultImage: "5tu_xiao")
            case 4:
                img.frame = CGRect(x: self.frame.width * 3/4, y: self.frame.width * 7/12, width: self.frame.width/4, height: self.frame.width/4)
                method.loadImageWithDefault(imgUrl: imgurl, Img_View: img, defaultImage: "5tu_xiao")
            default:
                _=""
            }
//            img.tag=i
            img.contentMode = .scaleAspectFill
            
            
            self.addSubview(img)
        }
    }
    func imageClick(tap:UITapGestureRecognizer){
        let tag = tap.view!.tag - 100
        if tag < self.imageJson.count{
            self.delegate?.HomeAdvertisingImageClick(info: self.imageJson[tag])
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
