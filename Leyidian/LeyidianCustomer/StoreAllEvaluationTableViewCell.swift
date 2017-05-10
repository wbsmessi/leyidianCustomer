//
//  StoreAllEvaluationTableViewCell.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/15.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON


//protocol EvaluationChangeDelegate {
//    func EvaluationChange(score:String)
//}
class StoreAllEvaluationTableViewCell: UITableViewCell {

    //row_height=100
    var row_height:CGFloat = 100
    var method = Methods()
//    var delegate:EvaluationChangeDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=UIColor.white
        creatView()
    }
    func initViewWithData(data:JSON){
        let storeAve = Float((data["serviceAppr"].floatValue + data["distributionAppr"].floatValue + data["productAppr"].floatValue)/3.0)
//        delegate?.EvaluationChange(score: "\(storeAve.getTwoDecimal())")
        StoreScore.text = "\(storeAve.getOneDecimal())"
        
        if storeAve.getOneDecimal() > data["storeAppr"].floatValue.getOneDecimal(){
            averageScore.text = "高于平台商家得分" + data["storeAppr"].stringValue
        }else if storeAve.getOneDecimal() < data["storeAppr"].floatValue.getOneDecimal(){
            averageScore.text = "低于于平台商家得分" + data["storeAppr"].stringValue
        }else{
            averageScore.text = "与平台商家得分" + data["storeAppr"].stringValue + "持平"
        }
        
        
        servingScore.text = "\(data["serviceAppr"].floatValue.getOneDecimal())"
        let maxScorePercent:Float = 0.2
        servingStar.scorePercent = CGFloat(data["serviceAppr"].floatValue) * CGFloat(maxScorePercent)
        
        goodsScore.text = "\(data["productAppr"].floatValue.getOneDecimal())"
        goodsStar.scorePercent = CGFloat(data["productAppr"].floatValue) * CGFloat(maxScorePercent)
        
        speedScore.text = "\(data["distributionAppr"].floatValue.getOneDecimal())"
        speedStar.scorePercent = CGFloat(data["distributionAppr"].floatValue) * CGFloat(maxScorePercent)
    }
    let StoreScore = UILabel()//店铺平均得分
    let averageScore = UILabel()//所有商家平均分
    
    let servingScore = UILabel()
    var servingStar:CWStarRateView!
    let goodsScore = UILabel()
    var goodsStar:CWStarRateView!
    let speedScore = UILabel()
    var speedStar:CWStarRateView!
    func creatView() {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: app_width * 0.45, height: row_height)
        self.contentView.addSubview(leftView)
        
        
        StoreScore.textAlignment = .center
        method.creatLabel(lab: StoreScore, x: leftView.frame.width/4, y: 10, wid: leftView.frame.width * 3/4, hei: 30, textString: "", textcolor: MyAppColor(), textFont: 30, superView: leftView)
        StoreScore.font = UIFont(name: "Helvetica-Bold", size: 26)
        
        let zonghepinfen = UILabel()
        method.creatLabel(lab: zonghepinfen, x: StoreScore.frame.origin.x, y: StoreScore.bottomPosition(), wid: StoreScore.frame.width, hei: 30, textString: "综合评分", textcolor: UIColor.black, textFont: 14, superView: leftView)
        zonghepinfen.textAlignment = .center
        
        method.creatLabel(lab: averageScore, x: StoreScore.frame.origin.x, y: zonghepinfen.bottomPosition(), wid: StoreScore.frame.width, hei: 20, textString: "", textcolor: UIColor.gray, textFont: 10, superView: leftView)
        averageScore.textAlignment = .center
        
        let rightView = UIView()
        rightView.frame = CGRect(x: leftView.rightPosition(), y: 0, width: app_width * 0.55, height: row_height)
        self.contentView.addSubview(rightView)
        
        method.drawLine(startX: 0, startY: 15, wid: 0.6, hei: row_height - 30, add: rightView)
        
        let fuwuzhiliang = UILabel()
        method.creatLabel(lab: fuwuzhiliang, x: 10, y: 10, wid: 60, hei: (row_height - 20)/3, textString: "服务态度", textcolor: UIColor.black, textFont: 12, superView: rightView)
        
        servingStar = CWStarRateView(frame: CGRect(x: fuwuzhiliang.rightPosition(), y: fuwuzhiliang.frame.origin.y + 5, width: rightView.frame.width * 0.7 - 60, height: 15), numberOfStars: 5)
        servingStar.allowEditStar = false
        servingStar.scorePercent = 0.67
        rightView.addSubview(servingStar)
        
        //服务质量的平均得分
        method.creatLabel(lab: servingScore, x: servingStar.rightPosition() + 5, y: fuwuzhiliang.frame.origin.y, wid: 20, hei: fuwuzhiliang.frame.height, textString: "", textcolor: MyAppColor(), textFont: 12, superView: rightView)
        
        
        let shangpinzhiliang = UILabel()
        method.creatLabel(lab: shangpinzhiliang, x: 10, y: fuwuzhiliang.bottomPosition(), wid: 60, hei: (row_height - 20)/3, textString: "商品质量", textcolor: UIColor.black, textFont: 12, superView: rightView)
        
        goodsStar = CWStarRateView(frame: CGRect(x: shangpinzhiliang.rightPosition(), y: shangpinzhiliang.frame.origin.y + 5, width: servingStar.frame.width, height: 15), numberOfStars: 5)
        goodsStar.allowEditStar = false
        goodsStar.scorePercent = 0.96
        rightView.addSubview(goodsStar)
        
        //商品质量的平均得分
        method.creatLabel(lab: goodsScore, x: goodsStar.rightPosition() + 5, y: shangpinzhiliang.frame.origin.y, wid: 20, hei: fuwuzhiliang.frame.height, textString: "", textcolor: MyAppColor(), textFont: 12, superView: rightView)
        
        let peisongsudu = UILabel()
        method.creatLabel(lab: peisongsudu, x: 10, y: shangpinzhiliang.bottomPosition(), wid: 60, hei: (row_height - 20)/3, textString: "配送速度", textcolor: UIColor.black, textFont: 12, superView: rightView)
        
        speedStar = CWStarRateView(frame: CGRect(x: peisongsudu.rightPosition(), y: peisongsudu.frame.origin.y + 5, width: servingStar.frame.width, height: 15), numberOfStars: 5)
        speedStar.allowEditStar = false
        speedStar.scorePercent = 0.76
        rightView.addSubview(speedStar)
        
        //配送速度的平均得分\
        method.creatLabel(lab: speedScore, x: speedStar.rightPosition() + 5, y: peisongsudu.frame.origin.y, wid: 20, hei: fuwuzhiliang.frame.height, textString: "", textcolor: MyAppColor(), textFont: 12, superView: rightView)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
