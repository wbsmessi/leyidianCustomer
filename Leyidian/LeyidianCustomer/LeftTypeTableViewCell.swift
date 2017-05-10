//
//  LeftTypeTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/6.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class LeftTypeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = MyGlobalColor()
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var isSelectCell:Bool = false{
        didSet{
            if isSelectCell{
                //选中
                self.backgroundColor = UIColor.white
                titleLab.textColor = MyAppColor()
                drawLine(add: self)
            }else{
                //未选中
                self.backgroundColor = MyGlobalColor()
                titleLab.textColor = UIColor.black
                line.removeFromSuperlayer()
            }
        }
    }
    let titleLab = UILabel()
    func creatView() {
        titleLab.frame = CGRect(x: 15, y: 0, width: 100, height: 40)
        titleLab.font=UIFont.systemFont(ofSize: 12)
        titleLab.textColor = UIColor.black
        titleLab.textAlignment = .center
        self.addSubview(titleLab)
    }
    
    let line = CALayer()
    func drawLine(add:UIView){
        line.frame = CGRect(x: 15, y: 0, width: 3, height: titleLab.frame.height)
        line.backgroundColor = MyAppColor().cgColor
        add.layer.addSublayer(line)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
