//
//  SectionHeaderCollectionReusableView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/2.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    var method = Methods()
    var headImgUrl = ""{
        didSet{
            print("-----------------")
            print(headImgUrl)
            method.loadImage(imgUrl: headImgUrl, Img_View: bgImage)
        }
    }
    lazy var bgImage = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgImage.frame=CGRect(x: 0, y: 0, width: self.frame.width, height: app_width * 0.1)
//        print(bgImage.frame)
//        bgImage.backgroundColor = UIColor.blue
        bgImage.contentMode = .scaleToFill
//        bgImage.image = UIImage(named: "xiansh")
        self.addSubview(bgImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
