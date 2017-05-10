//
//  RecommendCategoryView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/1.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

protocol RecommendCategoryDelegate {
    func didSelectItem(index:Int)
}
class RecommendCategoryView: UIView {
//    height=70
    var method = Methods()
    var delegate:RecommendCategoryDelegate?
    var itemCount:Int!
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor=UIColor.white
//        initView()
    }
    func initView(imgArr:[String],titleArr:[String]) {
        itemCount = titleArr.count
        self.imgArr = imgArr
        self.titleArr = titleArr
        for i in 0..<itemCount{
            creatView(x: CGFloat(i) * self.frame.width/CGFloat(itemCount), index: i)
        }
    }
    var imgArr:[String] = []
    var titleArr:[String] = []
    func creatView(x:CGFloat,index:Int){
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(tap:)))
        view.tag=index
        view.addGestureRecognizer(tap)
        view.backgroundColor=UIColor.white
        view.frame = CGRect(x: x, y: 0, width: self.frame.width/CGFloat(itemCount), height: self.frame.height)
        self.addSubview(view)
        
        let img = UIImageView()
        method.creatImage(img: img, x: view.frame.width/3, y: (view.frame.height - view.frame.width/3)/2 - 10, wid: view.frame.width/3, hei: view.frame.width/3, imgName: imgArr[index], imgMode: .scaleAspectFit, superView: view)
        
        let title=UILabel()
        title.textAlignment = .center
        method.creatLabel(lab: title, x: 0, y: img.bottomPosition() + 5, wid: view.frame.width, hei: (view.frame.height - view.frame.width/3)/2, textString: titleArr[index], textcolor: UIColor.gray, textFont: 11, superView: view)
    }
    func viewClick(tap:UIGestureRecognizer) {
        let index = tap.view!.tag
        delegate?.didSelectItem(index: index)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
