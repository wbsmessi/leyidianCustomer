//
//  CategoryGoodsView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/7.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh


protocol CategoryGoodsViewDelegate {
    func goodsChose(goodsId:String)
    func categoryTypeChose(classifyID:String,sortType:goodsSortType,orderOrCategory:Bool)
    func goodsNormChose(goodsInfo:JSON)
    func pullLoadMore(pageIndex:Int)
}

class CategoryGoodsView: UIView,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GoodsCollectionViewCellDelegate,goodsTableListTableViewCellDelegate {

    var currentVC:UIViewController!
    var pageIndex:Int = 0
    var categoryData:JSON!{
        didSet{
            self.currentSortType = nil
            self.currentClassifyID = nil
            //有改变先置为空
            title = []
            //二级分类
            title.append("全部")
            for item in categoryData["childClassifyList"].arrayValue{
                title.append(item["classifyName"].stringValue)
            }
        }
    }
    
    var goodsInfo:[JSON] = []{
        didSet{
            self.listTable.mj_footer.endRefreshing()
            self.listCollect.mj_footer.endRefreshing()
            DispatchQueue.main.async {
                self.listTable.reloadData()
                self.listCollect.reloadData()
            }
            
        }
    }
    var ordertitle = ["默认排序","销量最高","价格最低","价格最高"]
    var title:[String] = []
    var method = Methods()
    var delegate:CategoryGoodsViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatView()
    }
    let topView = UIImageView()
    var listTable:UITableView!
    var listCollect:UICollectionView!
    //分类按钮
    let categoryBtn = UIButton()
    let orderByBtn = UIButton()
    func creatView() {
        topView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        topView.image = UIImage(named: "typebg")
        topView.isUserInteractionEnabled = true
        self.addSubview(topView)
        
        method.creatButton(btn: categoryBtn, x: 0, y: 0, wid: self.frame.width/2 - 20, hei: 40, title: "全部分类", titlecolor: UIColor.black, titleFont: 12, bgColor: UIColor.white, superView: topView)
        categoryBtn.setImage(UIImage(named:"jiantou-up"), for: .normal)
        categoryBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -categoryBtn.imageView!.frame.width, bottom: 0, right: categoryBtn.imageView!.frame.width)
        categoryBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: categoryBtn.titleLabel!.frame.width, bottom: 0, right: -categoryBtn.titleLabel!.frame.width)
        categoryBtn.addTarget(self, action: #selector(categoryClick(btn:)), for: .touchUpInside)
//        print(categoryBtn.imageView!.frame)
//        print(categoryBtn.titleLabel!.frame)
//        print(categoryBtn.frame)
        
        method.creatButton(btn: orderByBtn, x: categoryBtn.rightPosition(), y: 0, wid: self.frame.width/2 - 20, hei: 40, title: "综合排序", titlecolor: UIColor.black, titleFont: 12, bgColor: UIColor.white, superView: topView)
        orderByBtn.setImage(UIImage(named:"jiantou-up"), for: .normal)
        orderByBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -orderByBtn.imageView!.frame.width, bottom: 0, right: orderByBtn.imageView!.frame.width)
        orderByBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: orderByBtn.titleLabel!.frame.width, bottom: 0, right: -orderByBtn.titleLabel!.frame.width)
        orderByBtn.addTarget(self, action: #selector(orderByClick(btn:)), for: .touchUpInside)
        //切换列表格式
        let listType = UIButton()
        listType.frame = CGRect(x: orderByBtn.rightPosition(), y: 0, width: 40, height: 40)
        listType.setImage(UIImage(named:"fenlei"), for: .normal)
        topView.addSubview(listType)
        listType.backgroundColor = UIColor.white
        listType.addTarget(self, action: #selector(listTypeClick(btn:)), for: .touchUpInside)
        
        listTable = UITableView()
        listTable.frame = CGRect(x: 0, y: topView.bottomPosition(), width: self.frame.width, height: self.frame.height - topView.frame.height)
        listTable.delegate = self
        listTable.dataSource = self
        listTable.tableFooterView = UIView()
        listTable.isHidden = true
        self.addSubview(listTable)
        
        self.listTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageIndex += 1
            self.delegate?.pullLoadMore(pageIndex: self.pageIndex)
        })
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // 设置间距
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        listCollect = UICollectionView(frame: listTable.frame, collectionViewLayout: layout)
        listCollect.backgroundColor = UIColor.white
        listCollect.delegate = self
        listCollect.dataSource = self
        listCollect.showsVerticalScrollIndicator=false
        listCollect.register(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: "goodscell")
        self.addSubview(listCollect)
        
        self.listCollect.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageIndex += 1
            self.delegate?.pullLoadMore(pageIndex: self.pageIndex)
        })
        
    }
    lazy var bgView:UIView={
       let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 40, width: self.frame.width, height: self.frame.height - 40)
        bgView.backgroundColor = UIColor(white: 0.3, alpha: 0.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBgView))
        bgView.addGestureRecognizer(tap)
        return bgView
    }()
//    分类事件
    func categoryClick(btn:UIButton){
        //设置selected为true选中，
        btn.isSelected = !btn.isSelected
        btn.setImage(UIImage(named: btn.isSelected ? "jiantou-down":"jiantou-up"), for: .normal)
        if btn.isSelected{
            orderByBtn.isSelected = false
            orderByBtn.setImage(UIImage(named: "jiantou-up"), for: .normal)
        }
        self.orderOrCategory = false
        animationBgView(itemArr: title, show: btn.isSelected)
    }
    //排序事件
    func orderByClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.setImage(UIImage(named: btn.isSelected ? "jiantou-down":"jiantou-up"), for: .normal)
        if btn.isSelected{
            categoryBtn.isSelected = false
            categoryBtn.setImage(UIImage(named: "jiantou-up"), for: .normal)
        }
        self.orderOrCategory = true
        animationBgView(itemArr: ordertitle, show: btn.isSelected)
    }
    func listTypeClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        btn.setImage(UIImage(named: btn.isSelected ? "fenlei-xuanzong":"fenlei"), for: .normal)
        listCollect.isHidden = btn.isSelected
        listTable.isHidden = !btn.isSelected
    }
    //关闭弹窗
    func closeBgView(){
        categoryBtn.isSelected = false
        categoryBtn.setImage(UIImage(named: categoryBtn.isSelected ? "jiantou-down":"jiantou-up"), for: .normal)
        orderByBtn.isSelected = false
        orderByBtn.setImage(UIImage(named: categoryBtn.isSelected ? "jiantou-down":"jiantou-up"), for: .normal)
        animationBgView(itemArr: [""], show: false)
    }
    func animationBgView(itemArr:[String],show:Bool){
        DispatchQueue.main.async {
            self.removewAllView(view: self.bgView)
            if show{
                self.categoryItem(titleArr: itemArr, add: self.bgView)
                self.addSubview(self.bgView)
                UIView.animate(withDuration: 0.3, animations: {
                    self.bgView.alpha = 1
                    self.bgView.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
                })
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.bgView.alpha = 0
                }, completion: { (finished) in
                    self.removewAllView(view: self.bgView)
                })
            }
        }
    }
    func removewAllView(view:UIView) {
        
        for item in view.subviews{
            item.removeFromSuperview()
        }
        view.removeFromSuperview()
    }
    
    func categoryItem(titleArr:[String],add:UIView){
        let item_heiht:CGFloat = 30.0
        let item_width:CGFloat = add.frame.width/3
        let itemView = UIView()
        itemView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: item_heiht * CGFloat((titleArr.count-1)/3 + 1))
        itemView.backgroundColor = UIColor.white
        add.addSubview(itemView)
        
        for i in 0..<titleArr.count{
            let btn = UIButton()
            btn.tag = i + 100
            method.creatButton(btn: btn, x: CGFloat(i%3) * item_width, y: CGFloat(i/3) * item_heiht, wid: item_width, hei: item_heiht, title: titleArr[i], titlecolor: UIColor.black, titleFont: 12, bgColor: UIColor.white, superView: itemView)
            btn.addTarget(self, action: #selector(categoryOrOrderChose(btn:)), for: .touchUpInside)
            if i==0{
                //默认第一个选项选中色
                btn.setTitleColor(MyAppColor(), for: UIControlState.normal)
                selectedBtn = btn
            }
        }
    }
    
    var orderOrCategory:Bool=true//true是排序，false是分类
    var selectedBtn:UIButton?
    //当前选择的分类和排序
    var currentSortType:goodsSortType?
    var currentClassifyID:String?
    func categoryOrOrderChose(btn:UIButton){
        
        selectedBtn?.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(MyAppColor(), for: UIControlState.normal)
        closeBgView()
        
        
        if !orderOrCategory{//true是排序，false是分类
            //分类id
            //  =100就是查询全部类别的东西，
            DispatchQueue.main.async {
                self.categoryBtn.setTitle(self.title[btn.tag - 100], for: .normal)
            }
            
            currentClassifyID = (btn.tag != 100) ? categoryData["childClassifyList"][btn.tag - 100 - 1]["classifyID"].stringValue : categoryData["classifyID"].stringValue
        }else{
            DispatchQueue.main.async {
                self.orderByBtn.setTitle(self.ordertitle[btn.tag - 100], for: .normal)
            }
            switch btn.tag - 100 {
            case 0:
                currentSortType = goodsSortType.defaultType
            case 1:
                currentSortType = goodsSortType.highSales
            case 2:
                currentSortType = goodsSortType.lowPrice
            default:
                currentSortType = goodsSortType.highPrice
            }
        }
        delegate?.categoryTypeChose(classifyID:currentClassifyID ?? "",sortType: currentSortType ?? goodsSortType.defaultType,orderOrCategory:self.orderOrCategory)
    }
    //////////////////////GoodsCollectionViewCellDelegate
    func alertNormChose(goods:JSON){
        delegate?.goodsNormChose(goodsInfo:goods)
    }
    func goodsTableListAlertNormChose(goods: JSON) {
        delegate?.goodsNormChose(goodsInfo:goods)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CategoryGoodsView{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return goodsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? goodsTableListTableViewCell
        if cell == nil{
            cell = goodsTableListTableViewCell()
        }
        cell!.currentVC = self.currentVC
        cell!.delegate = self
        cell!.creatView(cell_wid: app_width - 100)
//        print(goodsInfo)
//        print(indexPath.row)
        cell!.goodsInfo = goodsInfo[indexPath.row]
        cell!.imageUrl = goodsInfo[indexPath.row]["cover"].stringValue
        cell!.oldPrice = "¥" + goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
        cell!.goodsName.text = goodsInfo[indexPath.row]["commodityName"].stringValue
        cell!.goodsDetail.text = goodsInfo[indexPath.row]["commodityRemark"].stringValue
        
//        var salePrice = goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
//        if goodsInfo[indexPath.row]["commodityTypes"].stringValue != ""{
//            salePrice = goodsInfo[indexPath.row]["discountPrice"].doubleValue.getMoney()
//        }
//        cell!.goodsPrice.text = salePrice
        
        var salePrice = goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
        
        if method.hasStringInArr(arrStr: goodsInfo[indexPath.row]["commodityTypes"].stringValue){
            salePrice = goodsInfo[indexPath.row]["discountPrice"].doubleValue.getMoney()
            
        }else{
            cell!.goodsOldPrice.isHidden = true
        }
        cell!.goodsPrice.text = salePrice
        cell!.goodsStatus = goodsInfo[indexPath.row]["status"].stringValue
        cell!.goodsActiveType = goodsInfo[indexPath.row]["commodityTypes"].stringValue
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //选择的商品的id
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.goodsChose(goodsId: goodsInfo[indexPath.row]["commodityID"].stringValue)
    }
    
}
extension CategoryGoodsView{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width-5)/2, height: (self.frame.width-10) * 2/3)
    }
    //    返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goodsChose(goodsId: goodsInfo[indexPath.item]["commodityID"].stringValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodscell", for: indexPath) as! GoodsCollectionViewCell
        cell.selfViewController = self.currentVC
        cell.delegate = self
        cell.indexRow = indexPath.item
        cell.goodsInfo = goodsInfo[indexPath.row]
        cell.imageUrl = goodsInfo[indexPath.row]["cover"].stringValue
        cell.oldPrice = "¥" + goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
        cell.goodsName.text = goodsInfo[indexPath.row]["commodityName"].stringValue
        cell.goodsDetail.text = goodsInfo[indexPath.row]["commodityRemark"].stringValue
//        数量显示
//        cell.goodsNumInCar = goodsInfo[indexPath.row]["commodityNum"].intValue
//        var salePrice = goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
//        if goodsInfo[indexPath.row]["commodityTypes"].stringValue != ""{
//            salePrice = goodsInfo[indexPath.row]["discountPrice"].doubleValue.getMoney()
//        }
//        
//        cell.nowPrice.text = salePrice
        var salePrice = goodsInfo[indexPath.row]["retailPrice"].doubleValue.getMoney()
        
        if method.hasStringInArr(arrStr: goodsInfo[indexPath.row]["commodityTypes"].stringValue){
            salePrice = goodsInfo[indexPath.row]["discountPrice"].doubleValue.getMoney()
            cell.goodsOldPrice.isHidden = false
        }else{
            cell.goodsOldPrice.isHidden = true
        }
        cell.nowPrice.text = salePrice
        
        cell.goodsActiveType = goodsInfo[indexPath.row]["commodityTypes"].stringValue
        cell.goodsStatus =  goodsInfo[indexPath.row]["status"].stringValue
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        delegate?.goodsChose(goodsId: "")
//    }
}
