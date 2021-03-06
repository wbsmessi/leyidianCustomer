//
//  NormChoseView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/4/7.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

//自定义规格选择弹窗
protocol NormChoseViewDelegate {
    func NormChoseEnd()
}
class NormChoseView: UIView {

    var method = Methods()
    var delegate:NormChoseViewDelegate?
    var goodsInfo:JSON!{
        didSet{
            
            normView?.removeFromSuperview()
            
            let itemCount = goodsInfo["normList"].arrayValue.count
            let height = 40 + 45 + (itemWidth/2 + 10) * CGFloat((itemCount-1)/4 + 1)
            
            normView = UIView()
            normView!.frame = CGRect(x: app_width * 0.1, y: app_height/2 - height/2 - 60, width: app_width * 0.8, height: height + 40)
            normView!.alpha = 0
            normView!.backgroundColor = UIColor.white
            bgView.addSubview(normView!)
            
            method.creatLabel(lab: goodsMark, x: 10, y: 10, wid: normView!.frame.width - 40, hei: 30, textString: "", textcolor: UIColor.black, textFont: 14, superView: normView!)
            let goodsName = goodsInfo["commodityName"].stringValue + "  "
            let goodsMation = goodsInfo["commodityPrompt"].stringValue
            let attStr = NSMutableAttributedString(string: goodsName + goodsMation)
            let range = NSMakeRange(goodsName.characters.count, goodsMation.characters.count)
            
            attStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 11)], range: range)
            attStr.addAttributes([NSForegroundColorAttributeName:UIColor.gray], range: range)
            goodsMark.attributedText = attStr
            
            let cancleBtn = UIButton()
            cancleBtn.frame = CGRect(x: normView!.frame.width - 30, y: 10, width: 30, height: 30)
            cancleBtn.setImage(UIImage(named:"shanchu"), for: .normal)
            normView!.addSubview(cancleBtn)
            cancleBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
            
            for i in 0..<itemCount{
                let btn = UIButton()
                let btnx = 10 * CGFloat(i%4 + 1) + itemWidth * CGFloat(i%4)
                let btny = 50 + (itemWidth/2 + 10) * CGFloat(i/4)
                method.creatButton(btn: btn, x: btnx, y: btny, wid: itemWidth, hei: itemWidth/2, title: goodsInfo["normList"][i]["norm"].stringValue, titlecolor: UIColor.gray, titleFont: 12, bgColor: UIColor.clear, superView: normView!)
                btn.layer.cornerRadius = 5
                btn.layer.borderColor = setMyColor(r: 204, g: 204, b: 204, a: 1).cgColor
                btn.layer.borderWidth = 0.6
                btn.tag = i + 10
                btn.addTarget(self, action: #selector(choseNorm(btn:)), for: .touchUpInside)
            }
            
            let shuliang = UILabel()
            method.creatLabel(lab: shuliang, x: 10, y: normView!.frame.height - 40, wid: 50, hei: 40, textString: "数量", textcolor: UIColor.gray, textFont: 14, superView: normView!)
            
            addAndCut = AddAndCutView(frame: CGRect(x: normView!.frame.width - 90, y: shuliang.frame.origin.y + 5, width: 80, height: 25))
            addAndCut.addBtn.addTarget(self, action: #selector(addGoods), for: .touchUpInside)
            addAndCut.cutBtn.addTarget(self, action: #selector(cutGoods), for: .touchUpInside)
            addAndCut.nowCount = 0
            normView!.addSubview(addAndCut)
            
            DispatchQueue.main.async {
                
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatView()
    }
    let itemWidth:CGFloat = (app_width * 0.8 - 50)/4  //一行最多四个
    var bgView:UIView!
    var normView:UIView?
    var addAndCut:AddAndCutView!
    let goodsMark = UILabel()
    func creatView() {
//        super.init(frame: frame)
//        self.goodsInfo = goodsInfo
        self.isHidden = true
//        let itemCount = goodsInfo["normList"].arrayValue.count
//        
//        let height = 40 + 45 + (itemWidth/2 + 10) * CGFloat((itemCount-1)/4 + 1)
        
        bgView = UIView()
        bgView.frame = self.frame
        bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        self.addSubview(bgView)
        
    }
    func closeView(){
        animationHide(hide: true)
    }
    var selectedNormBtn:UIButton?
    func choseNorm(btn:UIButton){
        if selectedNormBtn != nil{
            selectedNormBtn!.setTitleColor(UIColor.gray, for: .normal)
            selectedNormBtn!.layer.borderColor = setMyColor(r: 204, g: 204, b: 204, a: 1).cgColor
        }
        btn.setTitleColor(setMyColor(r: 255, g: 109, b: 1, a: 1), for: .normal)
        btn.layer.borderColor = setMyColor(r: 255, g: 221, b: 67, a: 1).cgColor
        self.selectedNormBtn = btn
    }
    func addGoods(){
        if let btn = selectedNormBtn{
            let index = btn.tag - 10
            let normStr = self.goodsInfo["normList"][index]["norm"].stringValue
            let goodsId = self.goodsInfo["commodityID"].stringValue
            
            method.addTocar(goodId: goodsId, norm: normStr, isSuccesce: { (dataBool) in
                print(dataBool)
                if dataBool{
                    self.addAndCut.nowCount += 1
                }
            })
        }else{
            self.infoNotice("请先选择种类")
        }
    }
    func cutGoods(){
        self.infoNotice("请在购物车删减此商品")
//        let goodsId = self.goodsInfo["commodityID"].stringValue
//        method.cutFromcar(goodsId: goodsId) { (data) in
//            print(data)
//        }
    }
    func animationHide(hide:Bool){
        
        if hide{
            //隐藏
            UIView.animate(withDuration: 0.3, animations: {
                self.normView?.alpha = 0
            }, completion: { (finish) in
                self.isHidden = hide
            })
            self.selectedNormBtn = nil
            self.delegate?.NormChoseEnd()
        }else{
            //显示
            self.isHidden = hide
            UIView.animate(withDuration: 0.3, animations: {
                self.normView?.alpha = 1
            }, completion: { (finish) in
                
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
