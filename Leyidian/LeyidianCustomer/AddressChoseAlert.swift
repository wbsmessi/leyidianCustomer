//
//  AddressChoseAlert.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/30.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

protocol AddressChoseAlertDelegate {
    func AddressChoseRowClick(index:Int)
}
class AddressChoseAlert: UIView,UITableViewDelegate,UITableViewDataSource {

    var method = Methods()
    var delegate:AddressChoseAlertDelegate?
    override init(frame:CGRect) {
        super.init(frame: frame)
        creatView()
    }
    
    func creatView() {
        let bgview = UIView()
        bgview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        bgview.frame = self.frame
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        bgview.addGestureRecognizer(tap)
        self.addSubview(bgview)
        
        let table = UITableView()
        table.backgroundColor = UIColor.white
        table.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 80)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = table.frame.height/2
        table.separatorStyle = .none
        self.addSubview(table)
    }
    func closeView(){
        self.removeFromSuperview()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let title = UILabel()
        if indexPath.row == 0{
            cell.accessoryType = .disclosureIndicator
            method.creatLabel(lab: title, x: 30, y: 0, wid: 100, hei: 40, textString: "定位、搜索地标", textcolor: myAppBlackColor(), textFont: 12, superView: cell.contentView)
            
            let title2 = UILabel()
            title2.textAlignment = .right
            method.creatLabel(lab: title2, x: self.frame.width - 200, y: 0, wid: 170, hei: 40, textString: "写字楼、小区、学校等", textcolor: UIColor.gray, textFont: 12, superView: cell.contentView)
        }else{
            method.creatLabel(lab: title, x: 0, y: 0, wid: self.frame.width, hei: 40, textString: "新增地址", textcolor: MyAppColor(), textFont: 14, superView: cell.contentView)
            title.backgroundColor = MyGlobalColor()
            title.textAlignment = .center
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.AddressChoseRowClick(index: indexPath.row)
        self.removeFromSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
