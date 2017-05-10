//
//  ScoreDetailViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/21.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScoreDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var infoJSON:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.scoreTable.reloadData()
            }
        }
    }
    var pageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "积分明细", canBack: true)
        creatView()
        loadData()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        HttpTool.shareHttpTool.Http_GetIntegralList(startIndex: pageIndex) { (data) in
            print(data)
            self.infoJSON += data["integralList"].arrayValue
            if data["integralList"].arrayValue.count == 0{
                self.myNoticeError(title: "当前无数据")
            }
            self.pageIndex += 1
        }
    }
    let scoreTable = UITableView()
    func creatView() {
        
        scoreTable.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height)
        scoreTable.delegate = self
        scoreTable.dataSource = self
        scoreTable.tableFooterView = UIView()
        scoreTable.allowsSelection = false
        scoreTable.rowHeight = 60
        self.view.addSubview(scoreTable)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return infoJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "scorecellid") as? MyScoreTableViewCell
        if cell == nil{
            cell = UINib(nibName: "MyScoreTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! MyScoreTableViewCell?
        }
        cell!.scoreTitle.text = infoJSON[indexPath.row]["remark"].stringValue
        let timeStr = method.convertTime(time: infoJSON[indexPath.row]["createDate"].doubleValue)
        cell!.scoreTime.text = timeStr
        //            cell!.score.text = "+"+scoreData["integralList"][indexPath.row + 1]["worth"].stringValue
        
        //             1：收入 O 支出
        if infoJSON[indexPath.row]["type"].stringValue == "0"{
            cell!.score.textColor = UIColor.gray
            cell!.score.text = "-\(infoJSON[indexPath.row]["worth"].intValue)"
        }else{
            cell!.score.text = "+\(infoJSON[indexPath.row]["worth"].intValue)"
        }
        return cell!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
