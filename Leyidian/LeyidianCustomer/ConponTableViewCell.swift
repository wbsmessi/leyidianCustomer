//
//  ConponTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/21.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class ConponTableViewCell: UITableViewCell {

    var method = Methods()
    let item_height:CGFloat = 120.0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValue(money:String,remark:String,require:String,fireTime:Double,couponType:couponTypeEnum){
        let attStr = NSMutableAttributedString(string: "¥" + money)
        let rang = ("¥\(money)" as NSString).range(of: "¥")
        attStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: rang)
        moneyLab.attributedText = attStr
        
        remarkLab.text = "满\(remark)元可用"
        userRequire.text = require
        fireDate.text = method.convertTime(time: fireTime)
        
        switch couponType {
        case .unuse:
            markLab.isHidden = true
        case .used:
            markLab.isHidden = false
            markLab.text = "已使用"
        default:
            markLab.isHidden = false
            markLab.text = "已过期"
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = MyGlobalColor()
        creatView()
    }
    
    let moneyLab = UILabel()
    let remarkLab = UILabel()
    let userRequire = UILabel()
    let fireDate = UILabel()
    let markLab = UILabel()
    func creatView() {
        let bgview = UIImageView()
        bgview.frame = CGRect(x: 0, y: 0, width: app_width, height: item_height)
        bgview.image = UIImage(named: "youhuiquanbg")
        self.addSubview(bgview)
        
        method.creatLabel(lab: moneyLab, x: 10, y: 20, wid: (app_width - 20)/3, hei: 40, textString: "¥200", textcolor: UIColor.white, textFont: 22, superView: self)
        moneyLab.font = UIFont(name: "Helvetica-Bold", size: 26)
//        if #available(iOS 8.2, *) {
//            moneyLab.font = UIFont.systemFont(ofSize: 20, weight: 10)
//        } else {
//            // Fallback on earlier versions
//        }
        moneyLab.textAlignment = .center
        
        method.creatLabel(lab: remarkLab, x: 10, y: moneyLab.bottomPosition(), wid: moneyLab.frame.width, hei: 20, textString: "", textcolor: UIColor.white, textFont: 14, superView: self)
        remarkLab.textAlignment = .center
        
        method.creatLabel(lab: userRequire, x: moneyLab.rightPosition() + 15, y: 10, wid: app_width - moneyLab.rightPosition() - 30, hei: 50, textString: "仅限便利店店铺商品", textcolor: UIColor.gray, textFont: 12, superView: self)
        
        method.creatLabel(lab: fireDate, x: userRequire.frame.origin.x, y: 60, wid: userRequire.frame.width, hei: 20, textString: "2017.03.08--2017.09.08", textcolor: UIColor.gray, textFont: 12, superView: self)
        
//        creatUsedReamrk(title: "已使用")
        
        method.creatLabel(lab: markLab, x: app_width - 80, y: 50, wid: 60, hei: 30, textString: "", textcolor: UIColor.black, textFont: 11, superView: self)
        //        lab.backgroundColor = UIColor.red
        markLab.textAlignment = .center
        markLab.layer.cornerRadius = 3
        markLab.layer.borderColor = UIColor.gray.cgColor
        markLab.layer.borderWidth = 0.6
        //旋转lab
        markLab.transform = markLab.transform.rotated(by: -0.5)
    }
    func creatUsedReamrk(title:String){
//        let markLab = UILabel()
//        method.creatLabel(lab: markLab, x: app_width - 80, y: 50, wid: 60, hei: 30, textString: title, textcolor: UIColor.black, textFont: 11, superView: self)
////        lab.backgroundColor = UIColor.red
//        markLab.textAlignment = .center
//        markLab.layer.cornerRadius = 3
//        markLab.layer.borderColor = UIColor.gray.cgColor
//        markLab.layer.borderWidth = 0.6
//        //旋转lab
//        markLab.transform = markLab.transform.rotated(by: -0.5)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
