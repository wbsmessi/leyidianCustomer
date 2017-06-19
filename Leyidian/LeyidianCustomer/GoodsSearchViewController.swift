//
//  GoodsSearchViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/31.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    var method = Methods()
//    var hotView_height:CGFloat = 100.0
    var hotwordsArr:[JSON] = []{
        didSet{
//            hotwordsView.removeFromSuperview()
            
            DispatchQueue.main.async {
                self.creatHotWordsView(words: self.hotwordsArr)
                
            }
        }
    }
    var historyArr:[String]{
        get{
            if let arr = MyUserInfo.value(forKey: userInfoKey.searchHistory.rawValue) as? [String]{
                return arr
            }else{
                return []
            }
        }
        set{
            MyUserInfo.setValue(newValue, forKey: userInfoKey.searchHistory.rawValue)
            MyUserInfo.synchronize()
            //新增后刷新一次
            self.searchtable.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
        }
    }
    var pageIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "", canBack: true)
        creatSearctView()
        creatMainView()
        loadHotWords()
        // Do any additional setup after loading the view.
    }
    func loadHotWords(){
        HttpTool.shareHttpTool.Http_getHotWords { (data) -> (Void) in
            print(data)
            self.hotwordsArr = data.arrayValue
//            self.creatHotWordsView(words: data.arrayValue)
        }
    }
    let searchText = UITextField()
    func creatSearctView(){
        
        searchText.frame = CGRect(x: 50, y: 27, width: app_width - 100, height: 30)
        searchText.leftView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 30))
        searchText.leftView?.contentMode = .center
        (searchText.leftView as! UIImageView).image = UIImage(named: "sousuo-h")
        searchText.leftViewMode = .always
        searchText.backgroundColor = MyGlobalColor()
        searchText.placeholder = "请输入商品，品牌名字等"
        searchText.delegate = self
        searchText.returnKeyType = .search
        searchText.font = UIFont.systemFont(ofSize: 12)
        searchText.layer.cornerRadius = searchText.frame.height/2
        searchText.clearButtonRect(forBounds: CGRect(x: searchText.frame.width - 30, y: 5, width: 20, height: 20))
        searchText.clearButtonMode = .always
        self.view.addSubview(searchText)
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRect(x: app_width - 50, y: 30, width: 50, height: 30)
        method.creatButton(btn: rightBtn, x: app_width - 50, y: 27, wid: 50, hei: 30, title: "搜索", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
    }
    let searchtable = UITableView()
    func creatMainView(){
        searchtable.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height)
        searchtable.delegate = self
        searchtable.dataSource = self
        searchtable.tableFooterView = UIView()
        searchtable.backgroundColor = MyGlobalColor()
        self.view.addSubview(searchtable)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? 1 : historyArr.count
    }
    var hotWordsViewHeight:CGFloat = 10.0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? (hotWordsViewHeight+20):40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10:40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lab = UILabel()
        lab.text = section == 0 ? "     热门搜索":"     历史搜索"
        lab.textColor = UIColor.gray
        lab.backgroundColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        if indexPath.section == 0{
            let cell = UITableViewCell()
//            cell.contentView.backgroundColor = UIColor.blue
             return cell
        }else{
            let cell = UITableViewCell()
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 20, y: 0, wid: app_width - 60, hei: 40, textString: historyArr[indexPath.row], textcolor: UIColor.gray, textFont: 11, superView: cell.contentView)
            
            let btn = UIButton()
//            btn.frame = CGRect(x: app_width - 40, y: 0, width: 40, height: 40)
            method.creatButton(btn: btn, x: app_width - 40, y: 0, wid: 40, hei: 40, title: "", titlecolor: UIColor.gray, titleFont: 14, bgColor: UIColor.clear, superView: cell.contentView)
            btn.setImage(UIImage(named:"shanchu"), for: .normal)
            
            btn.tag = indexPath.row
            btn.addTarget(self, action: #selector(deleteHistory(btn:)), for: .touchUpInside)
            if indexPath.row == 0{
                method.drawLine(startX: 15, startY: 0, wid: app_width - 15, hei: 0.6, add: cell.contentView)
            }
            return cell
        }
       
    }
    let hotwordsView = UIView()
    func creatHotWordsView(words:[JSON]){
//        var height
        
        var orgin_y:CGFloat = 0
        var boforeBtn:UIButton!
        for i in 0..<words.count{
            let btn = UIButton()
            let wordsStr = words[i]["words"].stringValue
            print(wordsStr)
            let wordsWidth:CGFloat = 30 + self.getStringWidth(str: wordsStr, font: 12)
            var orgin_x:CGFloat = 0.0
            if i > 0{
                orgin_x = boforeBtn.rightPosition() + 15
            }
//            orgin_y = (orgin_x + wordsWidth + 15) > app_width - 30 ? (orgin_y+45):orgin_y
            if (orgin_x + wordsWidth + 15) > app_width - 30{
                orgin_x = 0
                orgin_y += 40.0
            }
            print(orgin_x)
            
            method.creatButton(btn: btn, x: orgin_x, y: orgin_y, wid: wordsWidth, hei: 30, title: wordsStr, titlecolor: myAppGryaColor(), titleFont: 12, bgColor: UIColor.white, superView: hotwordsView)
            boforeBtn = btn
            btn.layer.cornerRadius = 5
            btn.layer.borderWidth = 0.6
            btn.layer.borderColor = myAppGryaColor().cgColor
            if i%2 != 0{
                btn.setTitleColor(MyAppColor(), for: .normal)
                btn.layer.borderColor = MyAppColor().cgColor
            }
            btn.tag = 100+i
            btn.addTarget(self, action: #selector(hotWordsChose(btn:)), for: .touchUpInside)
        }
        self.hotWordsViewHeight = orgin_y + CGFloat(30)
        
        hotwordsView.frame = CGRect(x: 15, y: 10, width: app_width - 30, height: self.hotWordsViewHeight)
//        hotwordsView.backgroundColor = UIColor.red
        self.searchtable.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        self.searchtable.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView.addSubview(hotwordsView)
        
    }
    func hotWordsChose(btn:UIButton){
//        let index = btn.tag - 100
        let word = btn.titleLabel!.text!
        searchText.text = word
        searchGoods(text: word)
    }
    func getStringWidth(str:String,font:CGFloat)->CGFloat{
        let attrs:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: font)]
        let size = (str as NSString).size(attributes: attrs as? [String : Any])
        return size.width
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footview = UIButton()
        if section == 1{
            
            method.drawLineWithColor(startX: 15, startY: 0, wid: app_width - 15, hei: 0.6, lineColor: setMyColor(r: 200, g: 199, b: 204, a: 1), add: footview)
            footview.backgroundColor = UIColor.white
            footview.setTitle("清空搜索历史", for: .normal)
            footview.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            footview.setTitleColor(MyAppColor(), for: .normal)
//            footview.text = "清空搜索历史"
//            footview.textColor = MyAppColor()
//            footview.font = UIFont.systemFont(ofSize: 11)
//            footview.textAlignment = .center
            footview.addTarget(self, action: #selector(clearHistorySearch), for: .touchUpInside)
        }
        return footview
    }
    func clearHistorySearch(){
        historyArr.removeAll()
        searchtable.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
    }
    func deleteHistory(btn:UIButton){
        let index = btn.tag
        historyArr.remove(at: index)
        searchtable.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchText.resignFirstResponder()
        searchText.text = historyArr[indexPath.row]
        if indexPath.section == 0{
            return
        }else{
            searchGoods(text: historyArr[indexPath.row])
        }
        
    }
    
    func rightBtnClick(){
        searchText.resignFirstResponder()
        searchGoods(text: searchText.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        searchGoods(text: textField.text!)
        //去搜索
        return true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchText.resignFirstResponder()
    }
    func searchGoods(text:String){
        //若已存在，则无视，不存在，则添加到历史记录
        guard text != "" else {
            self.myNoticeError(title: "搜索内容为空")
            return
        }
        if !method.isItemInArray(item: text, arr: historyArr){
            historyArr.insert(text, at: 0)
            print(historyArr)
        }
        let vc = SearchListViewController()
        vc.searchStr = text
        self.pushToNext(vc: vc)
//        HttpTool.shareHttpTool.Http_goodsSearch(startIndex: pageIndex, searchText: text) { (data) in
//            print(data)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
