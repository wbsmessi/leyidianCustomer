//
//  LeftTypeView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/6.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol GoodsTypeDelegate {
    func typeClick(index:Int)
}
class LeftTypeView: UIView,UITableViewDelegate,UITableViewDataSource {
    var dataArr:[JSON] = []{
        didSet{
            DispatchQueue.main.async {
                self.typeTable.reloadData()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatView()
    }
    var delegate:GoodsTypeDelegate?
    let typeTable = UITableView()
    func creatView(){
        typeTable.frame = CGRect(x: -15, y: 0, width: self.frame.width + 15, height: self.frame.height)
        typeTable.tableFooterView=UIView()
        typeTable.dataSource = self
        typeTable.delegate = self
        typeTable.showsVerticalScrollIndicator = false
        typeTable.backgroundColor=setMyColor(r: 248, g: 248, b: 248, a: 1)
        self.addSubview(typeTable)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArr.count
    }
//    var titleArr = ["推荐商品","饮料酒水","推荐商品","饮料酒水","推荐商品","饮料酒水","休闲零食","饮料酒水","休闲零食","饮料酒水","休闲零食"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)") as? LeftTypeTableViewCell
        if cell == nil{
            cell = LeftTypeTableViewCell()
        }
        cell!.selectionStyle = .none
        cell!.titleLab.text = dataArr[indexPath.row]["classifyName"].stringValue
        if indexPath == selectedIndex{
            cell?.isSelectCell=true
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)//默认是现实第一个个分类
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectedIndex != indexPath else {
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as? LeftTypeTableViewCell//当前选中行，设置选择色白色
        cell?.isSelectCell = true
        
        //之前选择的颜色去掉
        let selectedCell = tableView.cellForRow(at: selectedIndex) as? LeftTypeTableViewCell
        selectedCell?.isSelectCell = false
        selectedIndex = indexPath
//        selectedCell?.titleLab.font = UIFont.systemFont(ofSize: 12)
//        selectedCell?.lineRight.isHidden = false
        delegate?.typeClick(index:indexPath.row)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
