//
//  CancleReasonViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/5/15.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class CancleReasonViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    var method = Methods()
    var orderNo:String!
    var reasonString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "取消订单", canBack: true)
        self.view.backgroundColor = UIColor.white
        creatView()
        // Do any additional setup after loading the view.
    }
    let defaultText = "请输入取消原因"
    let reasonArr:[String] = ["商品选错了","信息填写错误，重新买","忘记使用优惠券","临时有事，不需要了","商品缺货，不能发货","未按约定时间配送","其他"]
    let reasonText = UITextView()
    func creatView(){
        let submitBtn = UIButton()
        method.creatButton(btn: submitBtn, x: app_width - 80, y: 20, wid: 80, hei: 44, title: "提交", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        
        let titlelab = UILabel()
        method.creatLabel(lab: titlelab, x: 0, y: nav_height, wid: app_width, hei: 40, textString: "    请选择取消订单原因", textcolor: UIColor.gray, textFont: 12, superView: self.view)
        titlelab.backgroundColor = MyGlobalColor()
        let table = UITableView()
        table.frame = CGRect(x: 0, y: titlelab.bottomPosition(), width: app_width, height: 40 * CGFloat(reasonArr.count))
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 40
        table.tableFooterView = UIView()
        table.bounces = false
        self.view.addSubview(table)
        
        let budingView = UIView()
        budingView.frame = CGRect(x: 0, y: table.bottomPosition(), width: app_width, height: app_height - reasonText.bottomPosition())
        budingView.backgroundColor = MyGlobalColor()
        self.view.addSubview(budingView)
        
        reasonText.frame = CGRect(x: 0, y: table.bottomPosition(), width: app_width, height: 60)
        reasonText.backgroundColor = UIColor.white
        reasonText.isHidden = true
        reasonText.text = defaultText
        reasonText.delegate = self
        reasonText.font = UIFont.systemFont(ofSize: 12)
        reasonText.textColor = UIColor.gray
        self.view.addSubview(reasonText)
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return reasonArr.count
    }
    var selectedIndex:IndexPath?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CancleReasonTableViewCell
        if cell == nil{
            cell = CancleReasonTableViewCell()
        }
        cell!.reasonStr = reasonArr[indexPath.row]
//        let title = UILabel()
//        method.creatLabel(lab: title, x: 15, y: 0, wid: app_width - 30, hei: 40, textString: reasonArr[indexPath.row], textcolor: setMyColor(r: 102, g: 102, b: 102, a: 1), textFont: 14, superView: cell.contentView)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex == nil{
            let cell = tableView.cellForRow(at: indexPath) as! CancleReasonTableViewCell
            cell.selectedMark.setImage(UIImage(named:"xuanze-1"), for: .normal)
        }else{
            let cell = tableView.cellForRow(at: self.selectedIndex!) as! CancleReasonTableViewCell
            cell.selectedMark.setImage(UIImage(named:"weixuanze"), for: .normal)
            
            let cellnew = tableView.cellForRow(at: indexPath) as! CancleReasonTableViewCell
            cellnew.selectedMark.setImage(UIImage(named:"xuanze-1"), for: .normal)
        }
        self.selectedIndex = indexPath
        if indexPath.row == (self.reasonArr.count - 1){
            self.reasonText.isHidden = false
            reasonString = reasonArr[indexPath.row]
        }else{
            self.reasonText.isHidden = true
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultText{
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = defaultText
        }
    }
    func submitBtnClick(){
//        let orderNo = self.infoArr[index]["orderNo"].stringValue
        
        if selectedIndex != nil{
            //其他
            if selectedIndex!.row == (self.reasonArr.count - 1){
                reasonString = reasonText.text
            }else{
                reasonString = reasonArr[self.selectedIndex!.row]
            }
        }
        guard  reasonString != "" else {
            self.myNoticeError(title: "请选择退款原因")
            return
        }
        HttpTool.shareHttpTool.Http_CancelOrder(remark: reasonString, orderNo: orderNo) { (data) in
            print(data)
            if data["code"].stringValue == "SUCCESS"{
                self.myNoticeSuccess(title: "取消订单成功")
                self.backPage()
            }else{
                self.myNoticeError(title: data["msg"].stringValue)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
