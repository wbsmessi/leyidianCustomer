//
//  EvaluationViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/4/10.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class EvaluationViewController: UIViewController,CWStarRateViewDelegate,UITextViewDelegate {

    var method = Methods()
    var orderInfo:JSON!
    //服务评分
    var serviceStar:String = "5.0"
//    商品评分
    var productStar:String = "5.0"
//    配送评分
    var distributionStar:String = "5.0"
    
    let defaultContext = "你可以从服务态度，商品质量，配送速度等方面来发表评价"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(orderInfo)
        self.setTitleView(title: "立即评价", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        // Do any additional setup after loading the view.
    }
    
    //评价内容
    let eva_context = UITextView()
    var wordCount:UILabel!
    func creatView(){
        //提交按钮
        let submitBtn = UIButton()
        method.creatButton(btn: submitBtn, x: app_width - 60, y: 30, wid: 60, hei: 30, title: "提交", titlecolor: UIColor.black, titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        
        let goodsCount = orderInfo["details"].arrayValue.count
        let goodsImg_wid = (app_width - 60)/5 //每一行最多放五个
        let imgViewHeight = (goodsImg_wid + 10) * CGFloat((goodsCount - 1)/5 + 1)
        
        
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: nav_height, width: app_height, height: 50 + imgViewHeight)
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        creatItem(Y: 0, title: "订单号", value: orderInfo["orderNo"].stringValue, superView: topView)
        let orderTime = method.convertTime(time: orderInfo["createDate"].doubleValue)
        creatItem(Y: 25, title: "下单时间", value: orderTime, superView: topView)
        
        
        for i in 0..<goodsCount{
            let img = UIImageView()
            img.frame = CGRect(x: 10 + (goodsImg_wid + 10) * CGFloat(i%5), y: 60 + (goodsImg_wid + 10) * CGFloat(i/5), width: goodsImg_wid, height: goodsImg_wid)
            img.layer.borderColor = UIColor.lightGray.cgColor
            img.layer.borderWidth = 0.6
            method.loadImage(imgUrl: orderInfo["details"][i]["commodityImg"].stringValue, Img_View: img)
            topView.addSubview(img)
        }
        
        let CenterView = UIView()
        CenterView.frame = CGRect(x: 0, y: topView.bottomPosition() + 10, width: app_width, height: 95)
        CenterView.backgroundColor = UIColor.white
        self.view.addSubview(CenterView)
        
        creatEnv_item(Y: 10, index: 10, title: "服务态度", superView: CenterView)
        creatEnv_item(Y: 35, index: 11, title: "商品质量", superView: CenterView)
        creatEnv_item(Y: 60, index: 12, title: "配送速度", superView: CenterView)
        
        
        eva_context.frame = CGRect(x: 0, y: CenterView.bottomPosition() + 1, width: app_width, height: 150)
        eva_context.backgroundColor = UIColor.white
        eva_context.textColor = UIColor.gray
        eva_context.delegate = self
        eva_context.returnKeyType = .done
        eva_context.text = defaultContext
        self.view.addSubview(eva_context)
        
        wordCount = UILabel()
        wordCount.textAlignment = .right
        method.creatLabel(lab: wordCount, x: app_width - 100, y: eva_context.bottomPosition() - 20, wid: 80, hei: 20, textString: "300字", textcolor: setMyColor(r: 101, g: 102, b: 103, a: 1), textFont: 12, superView: self.view)
    }
    
    func creatItem(Y:CGFloat,title:String,value:String,superView:UIView){
        let titleLab = UILabel()
        method.creatLabel(lab: titleLab, x: 10, y: Y, wid: 120, hei: 25, textString: title, textcolor: UIColor.gray, textFont: 12, superView: superView)
        
        let context = UILabel()
        context.textAlignment = .right
        method.creatLabel(lab: context, x: titleLab.rightPosition(), y: Y, wid: app_width - 140, hei: 25, textString: value, textcolor: UIColor.gray, textFont: 12, superView: superView)
        
    }
    func creatEnv_item(Y:CGFloat,index:Int,title:String,superView:UIView){
        let titleLab = UILabel()
        method.creatLabel(lab: titleLab, x: 10, y: Y, wid: 100, hei: 25, textString: title, textcolor: UIColor.gray, textFont: 12, superView: superView)
        
        let starView = CWStarRateView(frame: CGRect(x: app_width - 140, y: Y + 5, width: 100, height: 15), numberOfStars: 5)
        starView!.allowEditStar = true
        starView!.allowIncompleteStar = false
        starView!.tag = index
        starView!.hasAnimation = true
//        starView!.scorePercent = 0.0
        starView!.delegate = self
        superView.addSubview(starView!)
        
        let scoreLab = UILabel()
        scoreLab.textAlignment = .right
        scoreLab.tag = index + 100
        method.creatLabel(lab: scoreLab, x: starView!.rightPosition(), y: Y, wid: 30, hei: 25, textString: "5.0", textcolor: MyAppColor(), textFont: 12, superView: superView)
    }
    
    func starRateView(_ starRateView: CWStarRateView!, scroePercentDidChange newScorePercent: CGFloat) {
//        print(starRateView.tag)
//        print(newScorePercent * 5)
        let score = newScorePercent * 5
        switch starRateView.tag {
        case 10:
            serviceStar = "\(score)"
        case 11:
            productStar = "\(score)"
        case 12:
            distributionStar = "\(score)"
        default:
            _=""
        }
        
        if let lab = self.view.viewWithTag(starRateView.tag + 100) as? UILabel{
            lab.text = "\(newScorePercent * 5)"
        }
    }
    func submitBtnClick(){
//        serviceStar == nil || distributionStar == nil || productStar == nil || 
        if eva_context.text == "" || eva_context.text == defaultContext{
            self.myNoticeError(title: "请输入评价内容")
            return
        }
        HttpTool.shareHttpTool.Http_OrderAppraise(orderID: self.orderInfo["orderID"].stringValue, serviceAppr: serviceStar, productAppr: productStar, distributionAppr: distributionStar, content: eva_context.text!) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "发表评价成功")
                self.backPage()
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
//        let count = textView.text.characters.count
        
//        DispatchQueue.main.async {
//            self.wordCount.text = "还可以输入\(300 - count)字"
//        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }else{
            let count = textView.text.characters.count
            if count >= 300{
                return false
            }
        }
        
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultContext{
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = defaultContext
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
