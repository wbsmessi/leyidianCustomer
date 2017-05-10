//
//  DECMaBannerView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/1.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DECMaBannerViewDelegate {
    func DECMaBannerClick(BannerView:DECMaBannerView,index:Int)
}
class DECMaBannerView: UIView,UIScrollViewDelegate{
    
    //宏定义：分页控件的高度
    let pageControlHeight = 20
    //屏幕宽高
    let ScreenWidth = app_width
    let ScreenHeight = app_height
    //定义一个数组存放图片的名字
    private var titleArray1 : NSArray?
    var delegate:DECMaBannerViewDelegate?
    //变量
    var _scrollView : UIScrollView?
    var _pageControl : UIPageControl?
    var _timer:Timer?
    var radiusNeed:Bool = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI(frame: frame)
    }
    init(frame: CGRect,radiusNeed:Bool) {
        super.init(frame: frame)
        self.radiusNeed = radiusNeed
        createUI(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI(frame:CGRect) {
        
        //滑动视图的创建
        _scrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width:frame.width,height:frame.height))
        _scrollView?.delegate = self
        _scrollView?.isPagingEnabled = true
        _scrollView?.showsVerticalScrollIndicator = false
        _scrollView?.showsHorizontalScrollIndicator = false
        self.addSubview(_scrollView!)
        
        if radiusNeed{
            let radiusView = UIImageView()
            radiusView.frame = CGRect(x: 0, y: self.frame.height - 70, width: self.frame.width, height: 70)
            radiusView.contentMode = .scaleAspectFill
            radiusView.image = UIImage(named: "banner_hu")
            self.addSubview(radiusView)
        }
        //创建分页效果
        _pageControl = UIPageControl.init(frame: CGRect(x:0,y:self.frame.height - 70,width:ScreenWidth,height:CGFloat(pageControlHeight)))
        _pageControl?.backgroundColor = UIColor.clear
        _pageControl?.pageIndicatorTintColor = UIColor.white
        _pageControl?.currentPageIndicatorTintColor = MyAppColor()
        self.addSubview(_pageControl!)
    }
    var imgJSON:[JSON] = []{
        didSet{
            var imgArr:[String] = []
            for item in imgJSON{
                imgArr.append(item["imgUrl"].stringValue)
            }
            titleArray = imgArr
        }
    }
    var titleArray : [String] = []
        {
        didSet{
            if titleArray.count == 0{
                return
            }
            //使用mutableArray来
            var mutArray = titleArray
            //将最后一张图片插入两次，目的是使得到最后一张图片的时候直接跳转到第一张
            mutArray.append(titleArray[0])
            //同时将一张图片添加进去
            mutArray.insert(titleArray.last!, at: 0)
            //将生成的数组给_titleArray = 5 1 2 3 4 5 1
            self.titleArray = mutArray
            
            //创建视图
            DispatchQueue.main.async {
                self.createScrollContentView()
            }
            
        }
    }
    func createScrollContentView (){
        //获取滑动视图的子视图
        let subViews = _scrollView?.subviews
        //如果子视图存在，就要删除，然后重绘
        for obj in subViews!{
            obj.removeFromSuperview()
        }
        
        for i in 0 ..< self.titleArray.count {
            
            let imageView : UIImageView = UIImageView.init(frame: CGRect(x: CGFloat(i)*ScreenWidth,y:0,width:ScreenWidth,height:(_scrollView?.frame.size.height)!))
            
//            let imageView = UIImageView(cornerRadiusAdvance: 80, rectCornerType: [.bottomLeft, .bottomRight])
//            imageView!.frame = CGRect(x: CGFloat(i)*ScreenWidth, y: 0, width: ScreenWidth, height: _scrollView!.frame.size.height)
            
            Methods().loadImage(imgUrl: self.titleArray[i], Img_View: imageView)
            //将图片视图添加到滑动视图上
            imageView.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap(tap:)))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFill
            _scrollView?.addSubview(imageView)
            
        }
        
        //分页效果
        _pageControl?.numberOfPages = self.titleArray.count - 2
        //设置分页大小
        _scrollView?.contentSize = CGSize(width:CGFloat(self.titleArray.count)*ScreenWidth,height:(_scrollView?.frame.size.height)!)
        //设置偏移量
        _scrollView?.contentOffset = CGPoint(x:(_scrollView?.frame.size.width)!,y:0)
//        startOrCloseScroll(status: true)
    }
    func imageTap(tap:UIGestureRecognizer){
        let index = tap.view!.tag
        delegate?.DECMaBannerClick(BannerView: self, index: index)
//        print(index)
    }
    func startOrCloseScroll(status:Bool){
        if status{
            //开始
            self._timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }else{
            //结束
            self._timer?.invalidate()
            self._timer = nil
        }
    }
    func updateTime(){
        if let nowpage = _pageControl?.currentPage{
//            print(nowpage)
            //获取当前的分页效果
            let currentPage  = nowpage + 1
            //获取当前分页
            _pageControl?.currentPage = currentPage - 1
            //
            if currentPage == 0 {
                //设置滑动视图的偏移量
                _scrollView?.contentOffset = CGPoint(x:CGFloat(self.titleArray.count-2)*ScreenWidth,y:0)
                //设置分页指示位置
                _pageControl?.currentPage = self.titleArray.count - 2 - 1
                
            }else if currentPage == self.titleArray.count - 1 {
                _scrollView?.contentOffset = CGPoint(x:Int(ScreenWidth),y:0)
                //设置分页指示器
                _pageControl?.currentPage = 0
            }else{
//                print(CGFloat(currentPage) * ScreenWidth)
                _scrollView?.setContentOffset(CGPoint(x: CGFloat(currentPage + 1) * ScreenWidth, y: 0), animated: true)
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前的分页效果
        let currentPage  = scrollView.contentOffset.x/ScreenWidth
        //获取当前分页
        _pageControl?.currentPage = Int(currentPage) - 1
        //
        if currentPage == 0 {
            //设置滑动视图的偏移量
            scrollView.contentOffset = CGPoint(x:CGFloat(self.titleArray.count-2)*ScreenWidth,y:0)
            //设置分页指示位置
            _pageControl?.currentPage = self.titleArray.count - 2 - 1
            
        }else if currentPage == CGFloat(self.titleArray.count) - 1 {
            scrollView.contentOffset = CGPoint(x:Int(ScreenWidth),y:0)
            //设置分页指示器
            _pageControl?.currentPage = 0
        }
    }
    
}
