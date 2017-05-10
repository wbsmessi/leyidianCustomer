//
//  SingleChose.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/4/24.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

protocol SingleChoseDelegate {
    func itemClick(singleView:SingleChose,chosed:Bool)
}
class SingleChose: UIView {

    var method = Methods()
    var delegate:SingleChoseDelegate?
    let trueBtn = UIButton()
    let falseBtn = UIButton()
    override init(frame:CGRect) {
        super.init(frame: frame)
        //
        method.creatButton(btn: trueBtn, x: 0, y: 0, wid: self.frame.width/2, hei: self.frame.height, title: "是", titlecolor: UIColor.gray, titleFont: 14, bgColor: UIColor.white, superView: self)
        trueBtn.setImage(UIImage(named:"weixuanze"), for: .normal)
        trueBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: trueBtn.titleLabel!.frame.width)
        trueBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: trueBtn.imageView!.frame.width - 10, bottom: 0, right: 0)
        trueBtn.addTarget(self, action: #selector(trueBtnClick(btn:)), for: .touchUpInside)
        //
        method.creatButton(btn: falseBtn, x: self.frame.width/2, y: 0, wid: self.frame.width/2, hei: self.frame.height, title: "否", titlecolor: UIColor.gray, titleFont: 14, bgColor: UIColor.white, superView: self)
        falseBtn.setImage(UIImage(named:"weixuanze"), for: .normal)
        falseBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: falseBtn.titleLabel!.frame.width)
        falseBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: falseBtn.imageView!.frame.width - 10, bottom: 0, right: 0)
        falseBtn.addTarget(self, action: #selector(falseBtnClick(btn:)), for: .touchUpInside)
    }
    func trueBtnClick(btn:UIButton){
        trueBtn.setImage(UIImage(named:"xuanze-1"), for: .normal)
        falseBtn.setImage(UIImage(named:"weixuanze"), for: .normal)
        delegate?.itemClick(singleView:self,chosed: true)
    }
    
    func falseBtnClick(btn:UIButton){
        trueBtn.setImage(UIImage(named:"weixuanze"), for: .normal)
        falseBtn.setImage(UIImage(named:"xuanze-1"), for: .normal)
        delegate?.itemClick(singleView:self,chosed: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
