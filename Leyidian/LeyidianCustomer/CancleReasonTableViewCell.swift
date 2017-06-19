//
//  CancleReasonTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/15.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class CancleReasonTableViewCell: UITableViewCell {

    var method = Methods()
    var reasonStr:String = ""{
        didSet{
            DispatchQueue.main.async {
                self.title.text = self.reasonStr
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let title = UILabel()
    let selectedMark = UIButton()
    func creatView(){
        
        method.creatLabel(lab: title, x: 15, y: 0, wid: app_width - 80, hei: 40, textString: "", textcolor: setMyColor(r: 102, g: 102, b: 102, a: 1), textFont: 14, superView: self.contentView)
        
        
        selectedMark.frame = CGRect(x: title.rightPosition(), y: 0, width: 65, height: 40)
//        selectedMark.setImage(UIImage(named: "xuanze-1"), for: UIControlState.selected)
        selectedMark.setImage(UIImage(named: "weixuanze"), for: UIControlState())
//        selectedMark.addTarget(self, action: #selector(selectedMarkBtnClick(btn:)), for: .touchUpInside)
        self.contentView.addSubview(selectedMark)
    }
    func selectedMarkBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
