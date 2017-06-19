//
//  LZCartTableViewCell.swift
//  CartDemo_Swift
//
//  Created by Artron_LQQ on 16/6/27.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

typealias callBackFunc = (_ number: Int) -> Void
typealias selectFunc = (_ select: Bool ) -> Void

class LZCartTableViewCell: UITableViewCell {

    var method = Methods()
    var lzImageView: UIImageView!//商品图片
    var lzNameLabel: UILabel!//商品名字
    var lzDetailLabel: UILabel!//商品名字
    var lzNumberLabel: UILabel!
    var lzPriceLabel: UILabel!
    var oldPriceLabel: UILabel!
    var lzSelectButton: UIButton!
    var goodsDetailId:String!
    //    数量加减器
    var addAndCut:AddAndCutView!
//    当前商品信息
    var goodsModel:LZCartModel!
    
    var addCallback: callBackFunc?
    var cutCallback: callBackFunc?
    var selectAction: selectFunc?
    
    let row_height:CGFloat = 100.0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMainView() {
        
        // 背景view
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
//        backgroundView.layer.borderColor = LZColorTool.colorFromHex(0xeeeeee).cgColor
//        backgroundView.layer.borderWidth = 1
        backgroundView.frame = CGRect(x: 10, y: 0, width: app_width - 20, height: row_height)
        self.addSubview(backgroundView)
    
        let selectButton = UIButton(type: .custom)
        selectButton.frame = CGRect(x: 0, y: 10, width: 40, height: 80)
        selectButton.setImage(UIImage(named: "xuanze-1"), for: UIControlState.selected)
        selectButton.setImage(UIImage(named: "weixuanze"), for: UIControlState())
        selectButton.addTarget(self, action: #selector(selectButtonClick), for: UIControlEvents.touchUpInside)
        backgroundView.addSubview(selectButton)
        lzSelectButton = selectButton
        
        //头像背景view
        let headerBg = UIView()
        headerBg.frame = CGRect(x: selectButton.rightPosition(), y: 10, width: row_height - 20, height: row_height - 20)
//        headerBg.backgroundColor = LZColorTool.colorFromHex(0xf3f3f3)
        backgroundView.addSubview(headerBg)
        
        
        //商品图片
        lzImageView = UIImageView()
        lzImageView.frame = headerBg.frame
        lzImageView.contentMode = UIViewContentMode.scaleAspectFill
        backgroundView.addSubview(lzImageView)
        
        //名称
        let title = UILabel()
        title.frame = CGRect(x: headerBg.rightPosition() + 10, y: 10, width: app_width - headerBg.rightPosition() - 20, height: 25)
        title.font = UIFont.systemFont(ofSize: 14)
        backgroundView.addSubview(title)
        lzNameLabel = title
        
        // 商品描述
        let goodDetail = UILabel()
        goodDetail.frame = CGRect(x: title.frame.origin.x, y: title.bottomPosition(), width: title.frame.width, height: 25)
        goodDetail.font = UIFont.systemFont(ofSize: 12)
        goodDetail.textColor = myAppGryaColor()
        backgroundView.addSubview(goodDetail)
        lzDetailLabel = goodDetail
        
        let moneyIcon = UILabel()
        method.creatLabel(lab: moneyIcon, x: title.frame.origin.x, y: goodDetail.bottomPosition() + 15, wid: 10, hei: 15, textString: "¥", textcolor: MyMoneyColor(), textFont: 12, superView: backgroundView)
        //价格
        let price = UILabel()
        price.frame = CGRect(x: moneyIcon.rightPosition(), y: goodDetail.bottomPosition() + 10, width: 100, height: 20)
        price.font = UIFont.systemFont(ofSize: 18)
        price.textColor = MyMoneyColor()
//        price.
        backgroundView.addSubview(price)
        lzPriceLabel = price
        
        oldPriceLabel = UILabel()
        method.creatLabel(lab: oldPriceLabel, x: price.rightPosition() + 5, y: price.frame.origin.y + 7, wid: 100, hei: 15, textString: "", textcolor: UIColor.gray, textFont: 11, superView: backgroundView)
        
        
        addAndCut = AddAndCutView(frame: CGRect(x: app_width * 4/5 - 25, y: 60, width: app_width/5, height: 25))
        addAndCut.addBtn.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        addAndCut.cutBtn.addTarget(self, action: #selector(cutButtonClick), for: .touchUpInside)
        lzNumberLabel = addAndCut.number
        backgroundView.addSubview(addAndCut)
    }

    func selectButtonClick(_ button: UIButton) {
        
        button.isSelected = !button.isSelected
        
        if selectAction != nil {
            selectAction!(button.isSelected)
        }
    }
    
    func addButtonClick(_ button: UIButton) {
        
        
        //添加数量
        HttpTool.shareHttpTool.Http_AddGoodsToCar(goodsId: goodsModel.goodsId!, count: 1, norm: goodsModel.detail!) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                if var count = Int(self.lzNumberLabel.text!) {
                    count += 1
                    let num = count<=0 ? 1 : count
                    DispatchQueue.main.async {
                        self.lzNumberLabel.text = "\(num)"
                    }
                    if self.addCallback != nil {
                        
                        self.addCallback!(num)
                    }
                }
            }
        }
    }
    
    func cutButtonClick(_ button: UIButton) {
        
        HttpTool.shareHttpTool.Http_CutGoodsFromCar(goodsId: "",detailsID:"\(goodsModel.detailsID!)") { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                if var count = Int(self.lzNumberLabel.text!) {
                    
                    if count > 1{
                        count -= 1
                        
                        let num = count<=0 ? 1 : count
                        
                        DispatchQueue.main.async {
                            self.lzNumberLabel.text = "\(num)"
                        }
                        
                        if self.cutCallback != nil {
                            
                            self.cutCallback!(num)
                        }
                        //购物车减少数量
                    }else{
                              //数量<=1的时候，暂时不处理
                    }
                }
            }
        }
        
    }
    
    func selectAction(_ fun: @escaping (_ select: Bool)-> ()) {
        selectAction = fun
    }
    
    func addNumber (_ fun: @escaping ( _ num: Int)->()) {
        addCallback = fun
    }
    
    func cutNumber (_ fun: @escaping ( _ num : Int)->()) {
        cutCallback = fun
    }
    
    func configCellDateWithModel(_ model: LZCartModel) {
        self.goodsModel = model
        goodsDetailId = "\(model.detailsID)"
//        lzImageView.image = model.image
        method.loadImage(imgUrl: model.image!, Img_View: lzImageView)
        lzNumberLabel.text = "\(model.number)"
        lzNameLabel.text = model.name
        lzDetailLabel.text = model.detail
        lzPriceLabel.text = model.price
        lzPriceLabel.sizeToFit()
        
        oldPriceLabel.frame.origin.x = lzPriceLabel.rightPosition() + 5
        let oldpri = (model.oldprice! == model.price!) ? "" : "¥" + model.oldprice!
        oldPriceLabel.text = oldpri
        oldPriceLabel.sizeToFit()
        if model.oldprice! == ""{
            oldPriceLabel.isHidden = true
        }
//        method.drawLine(startX: 0, startY: oldPriceLabel.frame.height/2, wid: oldPriceLabel.frame.width, hei: 0.8, add: oldPriceLabel)
        method.drawLineWithColor(startX: 0, startY: oldPriceLabel.frame.height/2, wid: oldPriceLabel.frame.width, hei: 0.8, lineColor: UIColor.gray, add: oldPriceLabel)
        if let sel = model.select {
            lzSelectButton.isSelected = sel
        } else {
            lzSelectButton.isSelected = false
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
