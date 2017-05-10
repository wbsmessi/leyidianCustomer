//
//  orderStatusView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/24.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class orderStatusView: UIView,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var infoArr:[JSON] = []{
        didSet{
            table.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatView()
    }
    let table = UITableView()
    func creatView(){
        
        table.delegate = self
        table.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        table.dataSource = self
        table.rowHeight = 60
        table.separatorStyle = .none
        self.addSubview(table)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        
        let icon = UIImageView()
        method.creatImage(img: icon, x: 25, y: 20, wid: 16, hei: 16, imgName: "shijian", imgMode: .scaleAspectFill, superView: cell.contentView)
        if indexPath.row == 0{
            icon.image = UIImage(named: "shijianzh")
        }
        
        if indexPath.row != 2{ //row = 2 表示最后一行
//            下面一根
            method.drawLine(startX: 33, startY: icon.bottomPosition(), wid: 0.6, hei: 24, add: cell.contentView)
        }
        if indexPath.row != 0{
            method.drawLine(startX: 33, startY: 0, wid: 0.6, hei: 20, add: cell.contentView)
        }
        
        let statusTitle = UILabel()
        method.creatLabel(lab: statusTitle, x: 50, y: 10, wid: app_width - 200, hei: 20, textString: "下单成功", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
        let statusTime = UILabel()
        method.creatLabel(lab: statusTime, x: app_width - 150, y: 10, wid: 135, hei: 20, textString: "2017-08-09 12:00:00", textcolor: UIColor.gray, textFont: 10, superView: cell.contentView)
        statusTime.textAlignment = .right
        
        let statusRemark = UILabel()
        method.creatLabel(lab: statusRemark, x: 50, y: 30, wid: app_width - 65, hei: 30, textString: "下单成功,请保持电话畅通", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
        method.drawLine(startX: 50, startY: 59, wid: app_width - 50, hei: 0.6, add: cell.contentView)
        return cell
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
