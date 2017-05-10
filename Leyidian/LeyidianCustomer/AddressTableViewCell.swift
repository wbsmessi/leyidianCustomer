//
//  AddressTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/21.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    var method = Methods()
    var addressRemark:String=""{
        didSet{
            remark.text = addressRemark
            if addressRemark == ""{
                addresslab.frame.origin.x = remark.frame.origin.x
            }else{
                addresslab.frame.origin.x = remark.rightPosition()
            }
        }
    }
    var addressStr:String = ""{
        didSet{
            addresslab.text = addressStr
        }
    }
    
    var phoneAndNameStr:String=""{
        didSet{
            phoneAndName.text = phoneAndNameStr
        }
    }
    var item_height:CGFloat = 60.0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        creatView()
    }
    
    let remark = UILabel()
    let addresslab = UILabel()
    let phoneAndName = UILabel()
    let deleteBtn = UIButton()
    func creatView(){
        
        method.creatLabel(lab: remark, x: 15, y: 5, wid: 50, hei: 30, textString: "公司", textcolor: UIColor.gray, textFont: 12, superView: self)
        
        method.creatLabel(lab: addresslab, x: remark.rightPosition(), y: 5, wid: app_width - 130, hei: 30, textString: "", textcolor: UIColor.gray, textFont: 11, superView: self)
        addresslab.numberOfLines = 2
        addresslab.lineBreakMode = .byCharWrapping
        
        method.creatLabel(lab: phoneAndName, x: 15, y: 30, wid: app_width - 80, hei: 25, textString: "", textcolor: UIColor.gray, textFont: 12, superView: self)
        
        deleteBtn.frame = CGRect(x: app_width - 50, y: 0, width: 50, height: 60)
        deleteBtn.setImage(UIImage(named:"Trash"), for: .normal)
        self.addSubview(deleteBtn)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
