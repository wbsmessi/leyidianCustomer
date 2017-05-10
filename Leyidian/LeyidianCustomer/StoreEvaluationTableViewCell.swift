//
//  StoreEvaluationTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/15.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class StoreEvaluationTableViewCell: UITableViewCell {

    let row_height:CGFloat = 100
    var method = Methods()
    var imgUrl = ""{
        didSet{
            method.loadImage(imgUrl: imgUrl, Img_View: headImage)
        }
    }
    var Score:Float=0.0{
        didSet{
            userStar.setwoScorePercent(CGFloat(Score * 0.2))
//            userStar.scorePercent = CGFloat(Score * 0.2)
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
    let headImage = UIImageView()
    var userStar:CWStarRateView!//星级
    let Eva_Context = UILabel()//评论内容
    let userName = UILabel()//用户昵称
    let userScore = UILabel()//分数
    let Eva_time = UILabel()//时间
    func creatView(){
        headImage.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        headImage.backgroundColor = UIColor.red
        headImage.contentMode = .scaleAspectFill
        headImage.layer.cornerRadius = headImage.frame.width/2
        self.contentView.addSubview(headImage)
        
        
        method.creatLabel(lab: userName, x: headImage.rightPosition() + 10, y: 10, wid: 200, hei: 20, textString: "王老五", textcolor: UIColor.black, textFont: 12, superView: self.contentView)
        
        userStar = CWStarRateView(frame: CGRect(x: userName.frame.origin.x, y: userName.bottomPosition(), width: 60, height: 10), numberOfStars: 5)
        userStar.scorePercent = 0.78
        self.contentView.addSubview(userStar)
        
        
        method.creatLabel(lab: userScore, x: userStar.rightPosition() + 10, y: userName.bottomPosition(), wid: 30, hei: 10, textString: "4.7", textcolor: UIColor.gray, textFont: 10, superView: self.contentView)
        
        
        method.creatLabel(lab: Eva_time, x: app_width - 200, y: 10, wid: 180, hei: 20, textString: "2017-02-03 09:00", textcolor: UIColor.gray, textFont: 10, superView: self.contentView)
        Eva_time.textAlignment = .right
        
        method.creatLabel(lab: Eva_Context, x: 15, y: 40, wid: app_width - 30, hei: 50, textString: "这里是评论内容这里是评论内容这里是评论内容这里是评论内容这里是评论内容这里是评论内容这里是评论内容", textcolor: UIColor.gray, textFont: 12, superView: self.contentView)
        Eva_Context.numberOfLines = 2
        Eva_Context.lineBreakMode = .byCharWrapping
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
