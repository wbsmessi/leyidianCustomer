//
//  DECChoseAlertView.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/22.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

protocol DECChoseAlertViewDelegate {
    func DECChoseAlert(title:String)
}
class DECChoseAlertView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

    var method = Methods()
    var titleArr:[[String]]! = []{
        didSet{
            selectedTitle = ""
            for i in 0..<titleArr.count{
                if i == 0{
                    selectedTitle += titleArr[i][0]
                }else{
                    selectedTitle += "-" + titleArr[i][0]
                }
            }
            if self.titleArr.count > 1{
                startTime   = "00:00"
                endTime     = "-00:00"
            }
            picker.reloadAllComponents()
        }
    }
    var delegate:DECChoseAlertViewDelegate?
    var selectedColor:UIColor = MyAppColor()
    var selectedTitle:String = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let bgview = UIView()
    let bottomView = UIView()
    let picker = UIPickerView()
    init(frame: CGRect,arr:[[String]]) {
        for i in 0..<arr.count{
            if i == 0{
                selectedTitle += arr[i][0]
            }else{
                selectedTitle += "-" + arr[i][0]
            }
        }
        super.init(frame: frame)
        bgview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        bgview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(bgview)
        self.isHidden = true
        
        bottomView.frame = CGRect(x: 0, y: self.frame.height - 235, width: self.frame.width, height: 235)
        bottomView.backgroundColor = UIColor.white
        bgview.addSubview(bottomView)
        
        let toolView = UIView(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 35))
        toolView.backgroundColor = MyGlobalColor()
        bottomView.addSubview(toolView)
        
        let leftBtn = UIButton()
        method.creatButton(btn: leftBtn, x: 0, y: 0, wid: 80, hei: toolView.frame.height, title: "取消", titlecolor: UIColor.gray, titleFont: 14, bgColor: UIColor.clear, superView: toolView)
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        let rightBtn = UIButton()
        method.creatButton(btn: rightBtn, x: toolView.frame.width - 80, y: 0, wid: 80, hei: toolView.frame.height, title: "确定", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: toolView)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        picker.frame = CGRect(x: 0, y: toolView.bottomPosition(), width: bottomView.frame.width, height: bottomView.frame.height - toolView.frame.height)
        picker.dataSource = self
        picker.delegate = self
        bottomView.addSubview(picker)
        self.titleArr = arr
    }
    func leftBtnClick(){
        animationHideOrNot(hide: true)
    }
    func rightBtnClick(){
        delegate?.DECChoseAlert(title: selectedTitle)
        animationHideOrNot(hide: true)
    }
    func animationHideOrNot(hide:Bool){
        
        if hide{
            //隐藏
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomView.frame.origin.y = self.frame.height
            }, completion: { (finish) in
                self.isHidden = hide
            })
        }else{
            //显示
            self.isHidden = hide
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomView.frame.origin.y = self.frame.height - 235
            }, completion: { (finish) in
                
            })
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return titleArr.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return titleArr[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleArr[component][row]
    }
    var startTime   = "00:00"
    var endTime     = "-00:00"
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let view = pickerView.view(forRow: row, forComponent: component) as? UILabel{
            view.textColor = MyAppColor()
        }
        self.selectedTitle = ""
        if self.titleArr.count > 1{
            if component == 0{
                startTime = titleArr[component][row]
            }else{
                endTime = "-" + titleArr[component][row]
            }
            selectedTitle = startTime + endTime
        }else{
            selectedTitle = titleArr[component][row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UILabel()
        view.text = titleArr[component][row]
        view.textAlignment = .center
//        view.textColor = (row == 0) ? MyAppColor():UIColor.gray
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
