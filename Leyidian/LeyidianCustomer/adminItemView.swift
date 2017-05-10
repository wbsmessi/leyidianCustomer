//
//  adminItemView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

protocol adminItemViewDelegate {
    func adminItemclick(index:Int)
}
class adminItemView: UIView {

    //    height=70
    var method = Methods()
    var delegate:adminItemViewDelegate?
    //每行个数
    var line_itemCount:Int = 3
    //总个数
    var itemCount:Int!
//    总行数
    var lineCount:Int!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect,line_itemCount:Int) {
        super.init(frame: frame)
        //每一行个数
        self.line_itemCount = line_itemCount
    }
    func initView(imgArr:[String],titleArr:[String]) {
        itemCount = titleArr.count
        self.imgArr = imgArr
        self.titleArr = titleArr
        self.lineCount = (itemCount-1)/line_itemCount + 1
        for i in 0..<itemCount{
            let orgin_x:CGFloat = self.frame.width/CGFloat(line_itemCount) * CGFloat(i%line_itemCount)
            let orgin_y:CGFloat = self.frame.height/CGFloat(lineCount) * CGFloat(i/lineCount)
            creatView(x: orgin_x, y: orgin_y, index: i)
        }
    }
    var imgArr:[String] = []
    var titleArr:[String] = []
    func creatView(x:CGFloat,y:CGFloat,index:Int){
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(tap:)))
        view.tag=index
        view.addGestureRecognizer(tap)
        view.backgroundColor=UIColor.white
        view.frame = CGRect(x: x, y: y, width: self.frame.width/CGFloat(line_itemCount), height: self.frame.height/CGFloat(lineCount))
        self.addSubview(view)
        
        let img = UIImageView()
        method.creatImage(img: img, x: view.frame.width/3, y: view.frame.height/4, wid: view.frame.width/3, hei: view.frame.height/3, imgName: imgArr[index], imgMode: .scaleAspectFit, superView: view)
        
        let title=UILabel()
        title.textAlignment = .center
        method.creatLabel(lab: title, x: 0, y: img.bottomPosition(), wid: view.frame.width, hei: view.frame.height/3, textString: titleArr[index], textcolor: UIColor.black, textFont: 11, superView: view)
    }
    func viewClick(tap:UIGestureRecognizer) {
        let index = tap.view!.tag
        delegate?.adminItemclick(index: index)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
