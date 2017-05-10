//
//  MessageCenterViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/7.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class MessageCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TypeChoseDelegate {

    //是否是系统消息，true为系统消息（右），false为平台公告（左）
    var isSystemMsg:Bool = false{
        didSet{
            messageTable.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "消息中心", canBack: true)
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        // Do any additional setup after loading the view.
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return isSystemMsg ? 3 : 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if isSystemMsg{
            var cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as? SystemMessageTableViewCell
            if cell == nil{
                cell = UINib(nibName: "SystemMessageTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! SystemMessageTableViewCell?
            }
            cell?.messageTitle.text = "[订单详情]"
            cell?.messageDetail.text = "商品已经开始配送，请保持电话畅通"
            cell?.messageDate.text = "2017-03-06 12:33"
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as? PlatformNoticeTableViewCell
            if cell == nil{
                cell = UINib(nibName: "PlatformNoticeTableViewCell", bundle: nil).instantiate(withOwner: self, options: nil).last as! PlatformNoticeTableViewCell?
            }
            cell?.messageImg.backgroundColor = UIColor.red
            cell?.messageContext.text = "但是觉得审时度势圣诞节收到后记家时的黄度势圣诞节收到后记家时的黄度势圣诞节收到后记家时的黄度势圣诞节收到后记家时的黄金时间电视电话技能"
            cell?.messageDate.text = "2017-03-06 12:33"
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSystemMsg ? 60.0 : 100.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func TypeChoseClick(index:Int){
        //是否是系统消息
        isSystemMsg = (index == 0) ? false : true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
