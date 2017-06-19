//
//  MessageCenterViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/7.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

class MessageCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TypeChoseDelegate {

    //是否是系统消息，true为系统消息（右），false为平台公告（左）
    var isSystemMsg:Bool = false{
        didSet{
            self.loadData()
        }
    }
    
    var noticeType = "P"
    var noticeList:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.messageTable.reloadData()
            }
            
        }
    }
    var indexPage:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "消息中心", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        loadData()
//        self.myNoticeNodata()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        HttpTool.shareHttpTool.Http_getNoticeList(noticeType: noticeType, startIndex: indexPage) { (data)  in
            print(data)
            self.messageTable.mj_header.endRefreshing()
            self.messageTable.mj_footer.endRefreshing()
            self.noticeList = data["resultData"].arrayValue
        }
    }
    
    let messageTable = UITableView()
    func creatView() {
        let topType = TypeChoseView(frame: CGRect(x: 0, y: nav_height, width: app_width, height: 50))
        topType.item_width = app_width/2
        topType.typeChoseDelegate = self
        topType.reloadWithArray(array:["平台公告","系统消息"])
        self.view.addSubview(topType)
        
        messageTable.frame = CGRect(x: 0, y: topType.bottomPosition()+10, width: app_width, height: app_height - 80)
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.tableFooterView = UIView()
        messageTable.backgroundColor = UIColor.white
        messageTable.register(UINib.init(nibName: "SystemMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "systemCell")
        messageTable.register(UINib.init(nibName: "PlatformNoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "PlatformNoticeId")
        self.view.addSubview(messageTable)
        
        self.messageTable.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.indexPage = 0
            self.noticeList = []
            self.loadData()
        })
        self.messageTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.indexPage += 1
            self.loadData()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return noticeList.count
    }
    var method = Methods()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if isSystemMsg{
            var cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as? SystemMessageTableViewCell
            if cell == nil{
                cell = UINib(nibName: "SystemMessageTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! SystemMessageTableViewCell?
            }
            cell?.messageTitle.text = noticeList[indexPath.row]["title"].stringValue
            cell?.messageDetail.text = noticeList[indexPath.row]["content"].stringValue
            cell?.messageDate.text = method.convertTime(time: noticeList[indexPath.row]["createDate"].doubleValue)
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as? PlatformNoticeTableViewCell
            if cell == nil{
                cell = UINib(nibName: "PlatformNoticeTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! PlatformNoticeTableViewCell?
            }
//            cell?.messageImg.backgroundColor = UIColor.red
            method.loadImage(imgUrl: noticeList[indexPath.row]["noticeImg"].stringValue, Img_View: cell!.messageImg)
            cell!.messageContext.text = noticeList[indexPath.row]["title"].stringValue
            cell!.messageDate.text = method.convertTime(time: noticeList[indexPath.row]["createDate"].doubleValue)
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSystemMsg ? 60.0 : 100.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSystemMsg{
            //系统消息
        }else{
            let vc = NoticeDetailViewController()
            vc.noticeInfo = noticeList[indexPath.row]
            self.pushToNext(vc: vc)
        }
    }
    func TypeChoseClick(index:Int){
        //是否是系统消息
        self.noticeType = (index == 0) ? "P" : "S"
        isSystemMsg = (index == 0) ? false : true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
