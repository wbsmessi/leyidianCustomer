//
//  ShopTypeView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/1.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol TypeChoseDelegate {
    func TypeChoseClick(index:Int)
}
class TypeChoseView: UIView {

    var typeValue:[String] = []
    var shop_id:String!
    var typeChoseDelegate:TypeChoseDelegate?
    var item_width:CGFloat = 80.0
    lazy var scroll = UIScrollView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatView()
    }
    

    func reloadWithArray(array: [String]) {
        DispatchQueue.main.async {
            for item in self.scroll.subviews{
                //移除原有的
                item.removeFromSuperview()
            }
            self.scroll.contentSize = CGSize(width: self.item_width * CGFloat(array.count), height: self.scroll.frame.height)
            self.typeValue = array
            for i in 0..<array.count{
                self.creatItem(index: i, title: array[i],count:array.count)
            }
        }
    }
    
    func creatView(){
        self.backgroundColor = UIColor.white
        scroll.isUserInteractionEnabled = true
        scroll.backgroundColor = UIColor.white
        scroll.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(scroll)
        
        
//        initWithArray(array: array)
    }
    
    var method = Methods()
    func creatItem(index:Int,title:String,count:Int){
//        let newcount = CGFloat(count)
        let btn = UIButton()
        btn.tag = index + 10
        method.creatButton(btn: btn, x: CGFloat(index) * item_width, y: 0, wid: item_width, hei: self.frame.height - 0.6, title: title, titlecolor: UIColor.black, titleFont: 12, bgColor: UIColor.white, superView: scroll)
        btn.addTarget(self, action: #selector(choseItem(btn:)), for: .touchUpInside)
        if index == 0{
            btn.setTitleColor(MyAppColor(), for: .normal)
            let bottomBorder = CALayer()
//            print(btn.titleLabel!.frame.origin.x)
            bottomBorder.frame = CGRect(x: item_width/5, y: btn.frame.height - 7, width: item_width * 3/5, height: 2)
//            bottomBorder.frame = CGRect(x: btn.titleLabel!.frame.origin.x, y: btn.frame.height - 7, width: btn.titleLabel!.frame.width, height: 2)
//            
//            print(bottomBorder.frame)
            bottomBorder.backgroundColor = MyAppColor().cgColor
            btn.layer.addSublayer(bottomBorder)
        }
    }
    func choseItem(btn:UIButton){
        for i in 10..<typeValue.count + 10{
            if let btn = viewWithTag(i) as? UIButton{
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.layer.sublayers?.last?.backgroundColor = UIColor.white.cgColor
            }
        }
        btn.setTitleColor(MyAppColor(), for: .normal)
        let topBorder = CALayer()
        
        topBorder.frame = CGRect(x: item_width/5, y: btn.frame.height - 7, width: item_width * 3/5, height: 2)
        topBorder.backgroundColor = MyAppColor().cgColor
        btn.layer.addSublayer(topBorder)
        
//        reloadGoodsData(index: "\(typeValue[btn.tag - 10]["id"].intValue)")
        typeChoseDelegate?.TypeChoseClick(index: btn.tag - 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}