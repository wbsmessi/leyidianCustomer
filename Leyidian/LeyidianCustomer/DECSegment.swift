//
//  DECSegment.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/3.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

protocol DECSegmentDelegate {
    func DECSegmentSelect(index:Int)
}
class DECSegment: UIView {

    var method = Methods()
    var selectedColor = MyAppColor()
    var delegate:DECSegmentDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.white
    }
    func initView(items: [String]){
        let item_width = self.frame.width/CGFloat(items.count)
        for i in 0..<items.count{
            let btn = UIButton()
            btn.tag = i
            method.creatButton(btn: btn, x: item_width*CGFloat(i), y: 0, wid: item_width, hei: self.frame.height, title: items[i], titlecolor: UIColor.black, titleFont: 14, bgColor: MyGlobalColor(), superView: self)
            if i == 0{
                btn.setTitleColor(selectedColor, for: .normal)
                btn.backgroundColor = UIColor.white
            }
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        }
        
    }
    func btnClick(btn:UIButton) {
        for item in self.subviews{
            if item.isKind(of: UIButton.classForCoder()){
                (item as! UIButton).backgroundColor = MyGlobalColor()
                (item as! UIButton).setTitleColor(UIColor.black, for: .normal)
            }
        }
        btn.setTitleColor(selectedColor, for: .normal)
        btn.backgroundColor = UIColor.white
        delegate?.DECSegmentSelect(index: btn.tag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
