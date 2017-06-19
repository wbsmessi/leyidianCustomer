//
//  FeedBackViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/20.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit
import DKImagePickerController

class FeedBackViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,DECChoseAlertViewDelegate {
    
    let defaultContext="请输入你的反馈意见，我们将努力改进"
    //投诉类型
    let feedBackTypeDic:[String:feedBackTypeEnum] = ["服务投诉":feedBackTypeEnum.serviceComplaints,"功能建议":feedBackTypeEnum.funcationAdvice,"界面建议":feedBackTypeEnum.uiAdvice,"操作建议":feedBackTypeEnum.useAdvice]
    var choseImgArr:[String] = []
    var method = Methods()
    var maxImgCount:Int = 5
    var imgArr:[DKAsset] = []{
        didSet{
            for item in self.imgBgView.subviews{
                item.removeFromSuperview()
            }
            for i in 0..<imgArr.count{
                imgArr[i].fetchImageWithSize(CGSize(width: 70, height: 70), options: nil, completeBlock: { (img, value) in
                    let img11 = UIImageView()
                    img11.frame = CGRect(x: 15 + 75 * CGFloat(i), y: 15, width: 70, height: 70)
                    img11.image = img
                    img11.isUserInteractionEnabled = true
//                    img11.tag = i + 100
                    self.imgBgView.addSubview(img11)
                    
                    let btn = UIButton()
                    btn.tag = i + 10
//                    btn.setImage(UIImage(named:"删除"), for: .normal)
                    btn.setBackgroundImage(UIImage(named:"删除"), for: .normal)
//                    btn.imageView?.contentMode = .scaleToFill
                    btn.frame = CGRect(x: img11.frame.width - 15, y: -10, width: 18, height: 18)
                    img11.addSubview(btn)
                    btn.addTarget(self, action: #selector(self.removewImg(btn:)), for: .touchUpInside)
//                    print(btn.frame)
                })
            }
            if imgArr.count < maxImgCount{
                imgBgView.contentSize = CGSize(width: 75 * CGFloat(imgArr.count + 1) + 15, height: 75)
                AddImageBtn.frame.origin.x = 15 + 75 * CGFloat(imgArr.count)
                self.imgBgView.addSubview(AddImageBtn)
            }else{
                imgBgView.contentSize = CGSize(width: 75 * CGFloat(maxImgCount) + 15, height: 75)
            }
            
        }
    }
//    移除单张照片
    func removewImg(btn:UIButton){
        let index = btn.tag - 10
        print(index)
        imgArr.remove(at: index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "意见反馈", canBack: true)
        creatView()
        // Do any additional setup after loading the view.
    }
    var alertView:DECChoseAlertView!
    func creatView(){
        let submitBtn = UIButton()
        method.creatButton(btn: submitBtn, x: app_width - 80, y: 30, wid: 80, hei: 30, title: "提交", titlecolor: MyAppColor(), titleFont: 14, bgColor: UIColor.clear, superView: self.view)
        submitBtn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        let table = UITableView()
        table.frame = CGRect(x: 0, y: nav_height, width: app_width, height: app_height - 200)
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.tableFooterView = UIView()
        self.view.addSubview(table)
//        (1服务投诉、2功能建议、3界面建议、4操作建议)
        
        alertView = DECChoseAlertView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height), arr: [["服务投诉","功能建议","界面建议","操作建议"]])
        alertView.delegate = self
        self.view.addSubview(alertView)
    }
    
    func submitClick(){
        
        guard adviceTypeStr.text != "" else {
            self.myNoticeError(title: "请选择反馈类型")
            return
        }
        guard opinionText.text != "" else {
            self.myNoticeError(title: "请输入反馈内容")
            return
        }
        guard opinionText.text != defaultContext else {
            self.myNoticeError(title: "请输入反馈内容")
            return
        }
        guard phoneText.text != "" else {
            self.myNoticeError(title: "手机号码不正确")
            return
        }
        guard opinionText.text != defaultContext else {
            self.myNoticeError(title: "请输入反馈内容")
            return
        }
        if phoneText.text != ""{
            if phoneText.text?.characters.count != 11{
                self.myNoticeError(title: "手机号码不正确")
                return
            }
        }
        //测试说图片不是必填项
//        guard self.imgArr.count > 0 else {
//            self.myNoticeError(title: "请选择图片")
//            return
//        }
        self.choseImgArr = []
        self.infoNotice("提交中")
//        上传图片
        for item in self.imgArr{
            item.fetchOriginalImage(true, completeBlock: { (img, value) in
                if let imgdata = UIImageJPEGRepresentation(img!, 0.2){
                    //                        print("it work")
                    self.choseImgArr.append(self.method.uploadImage(imgData: imgdata))
                }
            })
        }
        
        let type:feedBackTypeEnum = feedBackTypeDic[adviceTypeStr.text!]!
        HttpTool.shareHttpTool.Http_Http_FeedBackd(feedbackType: type.rawValue, content: opinionText.text!, phone: phoneText.text!, imgs: choseImgArr) { (data) in
            print(data)
            self.clearAllNotice()
            if data["code"] == "SUCCESS"{
                self.backPage()
                self.myNoticeSuccess(title: "提交成功")
            }else{
                self.myNoticeError(title: "提交失败，请重试")
            }
        }
//        if adviceTypeStr.text != "" && opinionText.text != ""  && phoneText.text != ""  && self.imgArr.count > 0{
//            guard opinionText.text != defaultContext else {
//                self.myNoticeError(title: "请输入反馈内容")
//                return
//            }
//            
//        }else{
//            self.myNoticeError(title: "请填写完整")
//        }
    }
    func ImgChose(){
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = maxImgCount
        pickerController.allowMultipleTypes = false
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.imgArr = assets
        }
        
        self.present(pickerController, animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 250
        default:
            return 35
        }
    }
    //意见反馈
    let opinionText = UITextView()
    //电话号码
    let phoneText = UITextField()
    //图片加在这个上
    let imgBgView = UIScrollView()
    //添加图片按钮
    let AddImageBtn = UIButton()
//    建议类型
    let adviceTypeStr = UILabel()
    //字数展示
    let wordCountLab = UILabel()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell.accessoryType = .disclosureIndicator
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: 100, hei: 35, textString: "反馈类型", textcolor: myAppBlackColor(), textFont: 14, superView: cell.contentView)
            
            
            adviceTypeStr.textAlignment = .right
            method.creatLabel(lab: adviceTypeStr, x: 120, y: 0, wid: app_width - 150, hei: 35, textString: "", textcolor: UIColor.gray, textFont: 11, superView: cell.contentView)
        case 1:
            cell.selectionStyle = .none
            opinionText.frame = CGRect(x: 5, y: 0, width: app_width - 10, height: 149)
            opinionText.delegate = self
            opinionText.returnKeyType = .done
            opinionText.text = defaultContext
            opinionText.textColor = UIColor.gray
            cell.contentView.addSubview(opinionText)
            method.drawLine(startX: 15, startY: opinionText.bottomPosition(), wid: app_width - 15, hei: 0.6, add: cell.contentView)
            
            method.creatLabel(lab: wordCountLab, x: 50, y: opinionText.bottomPosition() - 20, wid: app_width - 70, hei: 20, textString: "还可以输入200字", textcolor: setMyColor(r: 204, g: 204, b: 204, a: 1), textFont: 12, superView: cell.contentView)
            wordCountLab.textAlignment = .right
            
            imgBgView.frame = CGRect(x: 0, y: opinionText.bottomPosition()+5, width: app_width, height: 100)
            imgBgView.backgroundColor = UIColor.white
            imgBgView.showsHorizontalScrollIndicator = false
            cell.contentView.addSubview(imgBgView)
            
            
            method.creatButton(btn: AddImageBtn, x: 15, y: 15, wid: 70, hei: 70, title: "+", titlecolor: UIColor.gray, titleFont: 35, bgColor: UIColor.white, superView: imgBgView)
            AddImageBtn.layer.borderWidth = 1
            AddImageBtn.layer.borderColor = setMyColor(r: 204, g: 204, b: 204, a: 1).cgColor
            AddImageBtn.addTarget(self, action: #selector(ImgChose), for: .touchUpInside)
            
        default:
            let lab = UILabel()
            method.creatLabel(lab: lab, x: 15, y: 0, wid: 65, hei: 35, textString: "联系方式", textcolor: UIColor.black, textFont: 12, superView: cell.contentView)
            phoneText.frame = CGRect(x: 90, y: 0, width: app_width - 100, height: 35)
            phoneText.font = UIFont.systemFont(ofSize: 12)
            phoneText.placeholder = "选填手机号码，便于我们与您联系"
            phoneText.delegate = self
            phoneText.returnKeyType = .done
            phoneText.keyboardType = .phonePad
            cell.contentView.addSubview(phoneText)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        closeKeyboard()
        if indexPath.section == 0{
            alertView.animationHideOrNot(hide: false)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }else{
            let count = textView.text.characters.count
            if count >= 200{
                return false
            }
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultContext{
            textView.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.characters.count
//        print("sddssd")
        wordCountLab.text = "还可以输入\(200 - count)字"
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = defaultContext
        }
    }
    func DECChoseAlert(title:String){
        print(title)
        adviceTypeStr.text = title
    }
    func getAdviewTitle()->String{
        return ""
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
    func closeKeyboard(){
        //意见反馈
        self.opinionText.resignFirstResponder()
        //电话号码
        self.phoneText.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
