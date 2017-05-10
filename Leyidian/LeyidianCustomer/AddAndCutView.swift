//
//  AddAndCutView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/16.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class AddAndCutView: UIView {

    var method = Methods()
    var nowCount:Int = 1{
        didSet{
//            print("not work?")
            DispatchQueue.main.async {
                self.number.text = "\(self.nowCount)"
            }
        }
    }
    var addBtn:UIButton!
    var cutBtn:UIButton!
    var number:UILabel!
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = setMyColor(r: 248, g: 248, b: 248, a: 1)
        self.layer.cornerRadius=self.frame.height/2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth=0.6
        creatView()
    }
    
    func creatView() {
        cutBtn = UIButton()
        cutBtn.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
        cutBtn.setImage(UIImage(named:"jian-noborder"), for: .normal)
//        cutBtn.addTarget(self, action: #selector(loginCheck), for: .touchUpInside)
        self.addSubview(cutBtn)
        
        number = UILabel()
        number.frame = CGRect(x: cutBtn.rightPosition(), y: 0, width: self.frame.width - 2*(self.frame.height), height: self.frame.height)
        number.textColor = MyAppColor()
        number.text = "1"
        number.font = UIFont.systemFont(ofSize: 12)
        number.textAlignment = .center
        
        self.addSubview(number)
        
        addBtn = UIButton()
        addBtn.frame = CGRect(x: number.rightPosition(), y: 0, width: self.frame.height, height: self.frame.height)
        addBtn.setImage(UIImage(named:"jia-noborder"), for: .normal)
//        addBtn.addTarget(self, action: #selector(loginCheck), for: .touchUpInside)
        self.addSubview(addBtn)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
