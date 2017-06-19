//
//  MyScoreViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class MyScoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var method = Methods()
    var pageIndex:Int = 0
//    var scoreData:JSON!{
//        didSet{
//            self.scoreInfoArr += scoreData["integralList"].arrayValue
//        }
//    }
    var scoreInfoArr:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.scoreTable.reloadData()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "我的积分", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        self.creatView()
        loadData()
    }
    func loadData(){
        HttpTool.shareHttpTool.Http_GetIntegralList(startIndex: pageIndex) { (data) in
            print(data)
//            self.scoreData = data
//            self.scoreTable.mj_footer.endRefreshing()
            self.scoreTable.mj_header.endRefreshing()
            DispatchQueue.main.async {
                self.score.text = data["userIntegral"].stringValue
            }
            self.scoreInfoArr = data["integralList"].arrayValue
        }
    }
    var scoreTable:UITableView!
    let score = UILabel()
    func creatView(){
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: nav_height, width: app_width, height: 150)
        topView.backgroundColor = setMyColor(r: 254, g: 177, b: 0, a: 1)
        self.view.addSubview(topView)
        
        let dangqianjifen = UILabel()
        method.creatLabel(lab: dangqianjifen, x: 15, y: 0, wid: 100, hei: 30, textString: "当前积分", textcolor: UIColor.white, textFont: 13, superView: topView)
        
        let userHelp = UIButton()
        method.creatButton(btn: userHelp, x: app_width - 100, y: dangqianjifen.frame.origin.y, wid: 100, hei: 30, title: "使用帮助", titlecolor: UIColor.white, titleFont: 13, bgColor: UIColor.clear, superView: topView)
        userHelp.setImage(UIImage(named:"bangzhu"), for: .normal)
        userHelp.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: userHelp.titleLabel!.frame.width)
        userHelp.titleEdgeInsets = UIEdgeInsets(top: 0, left: userHelp.imageView!.frame.width, bottom: 0, right: 0)
        
        
        method.creatLabel(lab: score, x: 50, y: dangqianjifen.bottomPosition() + 15, wid: app_width - 100, hei: 60, textString: "", textcolor: UIColor.white, textFont: 26, superView: topView)
        score.textAlignment = .center
        
        let remark = UILabel()
        remark.textAlignment = .center
        method.creatLabel(lab: remark, x: 0, y: score.bottomPosition(), wid: app_width, hei: 30, textString: "积分可以当钱花，多领一些囤起来", textcolor: UIColor.white, textFont: 11, superView: topView)
        
        scoreTable = UITableView()
        scoreTable.frame = CGRect(x: 0, y: topView.bottomPosition() + 10, width: app_width, height: app_height - topView.bottomPosition())
        scoreTable.delegate = self
        scoreTable.dataSource = self
        scoreTable.tableFooterView = UIView()
        self.view.addSubview(scoreTable)
        
        self.scoreTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageIndex = 0
//            self.scoreInfoArr = []
            self.loadData()
        })
//        self.scoreTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            self.pageIndex += 1
//            self.loadData()
//        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension MyScoreViewController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 40 : 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let linecount = scoreInfoArr.count
        return linecount > 10 ? 11:linecount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0{
           let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            let shouzhimingxi = UILabel()
            method.creatLabel(lab: shouzhimingxi, x: 15, y: 0, wid: 100, hei: 40, textString: "收支明细", textcolor: UIColor.black, textFont: 14, superView: cell.contentView)
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "scorecellid") as? MyScoreTableViewCell
            if cell == nil{
                 cell = UINib(nibName: "MyScoreTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! MyScoreTableViewCell?
            }
//            print(scoreInfoArr[indexPath.row - 1]["remark"].stringValue)
            cell!.scoreTitle.text = scoreInfoArr[indexPath.row - 1]["remark"].stringValue
            
            let timeStr = method.convertTime(time: scoreInfoArr[indexPath.row - 1]["createDate"].doubleValue)
            cell!.scoreTime.text = timeStr
//            cell!.score.text = "+"+scoreData["integralList"][indexPath.row + 1]["worth"].stringValue
            
//             1：收入 O 支出
            if scoreInfoArr[indexPath.row - 1]["type"].stringValue == "0"{
                cell!.score.textColor = UIColor.gray
                cell!.score.text = "-\(scoreInfoArr[indexPath.row - 1]["worth"].intValue)"
            }else{
                cell!.score.text = "+\(scoreInfoArr[indexPath.row - 1]["worth"].intValue)"
            }
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row == 0 else {
            return
        }
        let vc = ScoreDetailViewController()
        self.pushToNext(vc: vc)
        
    }
}
