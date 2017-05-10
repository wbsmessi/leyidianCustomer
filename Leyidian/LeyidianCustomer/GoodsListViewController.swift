//
//  GoodsListViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/2.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var goodsInfo:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "商品列表", canBack: true)
        // Do any additional setup after loading the view.
        print(goodsInfo)
        creatView()
    }
    
    func creatView(){
        let goodsTable = UITableView()
        goodsTable.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - nav_height)
        goodsTable.delegate = self
        goodsTable.dataSource = self
        goodsTable.tableFooterView = UIView()
        goodsTable.rowHeight = 100
        self.view.addSubview(goodsTable)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? GoodsListTableViewCell
        if cell == nil{
            cell = GoodsListTableViewCell()
        }
        cell!.goodsInfo             = goodsInfo[indexPath.row]
        cell!.imageUrl              = goodsInfo[indexPath.row]["commodityImg"].stringValue
        cell!.goodsName.text        = goodsInfo[indexPath.row]["commodityName"].stringValue
        cell!.goodsDetail.text      = goodsInfo[indexPath.row]["commodityRemark"].stringValue
        cell!.goodsPrice.text       = goodsInfo[indexPath.row]["price"].doubleValue.getMoney()
        cell!.goodsCount.text       = "x" + goodsInfo[indexPath.row]["num"].stringValue
        return cell!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
