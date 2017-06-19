//
//  EditUserInfoViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,DECChoseAlertViewDelegate {
    var method = Methods()
    var nickNameStr:String{
        get{
            let nickNameStr = MyUserInfo.value(forKey: userInfoKey.nickName.rawValue) as? String
            return nickNameStr ?? ""
        }
        set{
            MyUserInfo.setValue(newValue, forKey: userInfoKey.nickName.rawValue)
            MyUserInfo.synchronize()
        }
    }
    var signatureStr:String{
        get{
            let signatureS = MyUserInfo.value(forKey: userInfoKey.signature.rawValue) as? String
            return signatureS ?? ""
        }
        set{
            MyUserInfo.setValue(newValue, forKey: userInfoKey.signature.rawValue)
            MyUserInfo.synchronize()
        }
    }
    var sexStr:String{
//        0 男 1 女
        get{
            let sex = MyUserInfo.value(forKey: userInfoKey.sex.rawValue) as? String
            return sex ?? "0"
        }
        set{
            MyUserInfo.setValue(newValue, forKey: userInfoKey.sex.rawValue)
            MyUserInfo.synchronize()
        }
    }
    var headimageUrlStr:String{
        //
        get{
            let url = MyUserInfo.value(forKey: userInfoKey.headUrl.rawValue) as? String
            return url ?? ""
        }
        set{
            print(newValue)
            MyUserInfo.setValue(newValue, forKey: userInfoKey.headUrl.rawValue)
            MyUserInfo.synchronize()
        }
    }
    
    //新图片地址
    var newHeadImgUrl = ""
    var nowInfoChanged:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "个人资料",canBack:false)
        newHeadImgUrl = headimageUrlStr
        creatView()
    }
    
    var alertView:DECChoseAlertView!
    func creatView(){
        
        let saveBtn = UIButton()
        method.creatButton(btn: saveBtn, x: app_width - 60, y: 30, wid: 60, hei: 30, title: "保存", titlecolor: UIColor.black, titleFont: 13, bgColor: UIColor.clear, superView: self.view)
        saveBtn.addTarget(self, action: #selector(submitEdit), for: .touchUpInside)
        
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 15, y: 30, width: 25, height: 25)
        backBtn.setImage(UIImage(named:"fanhui"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        self.view.backgroundColor = MyGlobalColor()
        let infoEditTable = UITableView()
        infoEditTable.backgroundColor = MyGlobalColor()
        infoEditTable.frame = CGRect(x: 0, y: 80, width: app_width, height: app_height - 80)
        infoEditTable.delegate = self
        infoEditTable.dataSource = self
        infoEditTable.tableFooterView = UIView()
        self.view.addSubview(infoEditTable)
        
        alertView = DECChoseAlertView(frame: CGRect(x: 0, y: 0, width: app_width, height: app_height), arr: [["男","女"]])
        alertView.delegate = self
        self.view.addSubview(alertView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return title_arr.count
    }
    let title_arr = ["头像","昵称","性别","签名"]
    //    头像
    lazy var head_image:UIImageView={
        let head_image = UIImageView()
        head_image.backgroundColor = UIColor.red
        return head_image
    }()
    //    昵称
    lazy var nickName:UITextField={
        let nickName = UITextField()
        return nickName
    }()
    let sexLab = UILabel()
    //    昵称
    lazy var signature:UITextField={
        let signature = UITextField()
        return signature
    }()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let lab_title = UILabel()
        lab_title.textAlignment = .center
        method.creatLabel(lab: lab_title, x: 0, y: 0, wid: 60, hei: indexPath.row == 0 ? 60:50, textString: title_arr[indexPath.row], textcolor: myAppBlackColor(), textFont: 12, superView: cell.contentView)
        
        switch indexPath.row {
        case 0:
            cell.accessoryType = .disclosureIndicator
            method.creatImage(img: head_image, x: app_width - 80, y: 5, wid: 50, hei: 50, imgName: "", imgMode: .scaleAspectFill, superView: cell.contentView)
            head_image.clipsToBounds = true
            head_image.layer.cornerRadius = head_image.frame.width/2
//            let imgurl = MyUserInfo.value(forKey: userInfoKey.headUrl.rawValue)
            method.loadImage(imgUrl: headimageUrlStr, Img_View: head_image)
        case 1:
            //nickname
            nickName.frame = CGRect(x: lab_title.rightPosition(), y: 0, width: app_width - 80, height: 50)
            nickName.font = UIFont.systemFont(ofSize: 12)
            nickName.placeholder = "请输入昵称"
            nickName.text = nickNameStr
            nickName.returnKeyType = .done
            nickName.delegate = self
            nickName.textColor = myAppGryaColor()
            cell.contentView.addSubview(nickName)
        case 2:
            cell.accessoryType = .disclosureIndicator
            // sex
            method.creatLabel(lab: sexLab, x: lab_title.rightPosition(), y: 0, wid: app_width - 80, hei: 50, textString: sexStr == "0" ? "男" : "女", textcolor: myAppGryaColor(), textFont: 12, superView: cell.contentView)
        default:
            // signature
            signature.frame = CGRect(x: lab_title.rightPosition(), y: 0, width: app_width - 80, height: 50)
            signature.font = UIFont.systemFont(ofSize: 12)
            signature.text = signatureStr
            signature.placeholder = "请输入签名"
            signature.returnKeyType = .done
            signature.delegate = self
            signature.textColor = myAppGryaColor()
            cell.contentView.addSubview(signature)

        }
        return cell
    }
//    func numberOfSections(in tableView: UITableView) -> Int{
//        return 3
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 0:10
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 60:50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
//            照片选择
            PhotoChose()
        case 2:
            nickName.resignFirstResponder()
            signature.resignFirstResponder()
//            性别修改
            alertView.animationHideOrNot(hide: false)
        default:
            return
        }
    }
    //提交昵称修改
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        //        nickNameStr
//        if textField.text == ""{
//            return false
//        }
//        if textField == nickName{
//            self.nickNameStr = textField.text!
//        }else{
//            self.signatureStr = signature.text!
//        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " "{
            return false
        }else{
            return true
        }
    }
    func PhotoChose(){
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let xiangji = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) -> Void in
            self.fromPhotograph(typeInt:1)
        })
        let xiangce = UIAlertAction(title: "从相册中选择", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) -> Void in
            self.fromPhotograph(typeInt:0)
        })
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        action.addAction(xiangji)
        action.addAction(xiangce)
        action.addAction(cancelAction)
        self.present(action, animated: true, completion: nil)
        
    }
    //拍照
    func fromPhotograph(typeInt:Int){
        var type:UIImagePickerControllerSourceType!
        if typeInt == 0{
            type = UIImagePickerControllerSourceType.photoLibrary
        }else{
            type = UIImagePickerControllerSourceType.camera
        }
        
        if  UIImagePickerController.isSourceTypeAvailable(type){
            //创建图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //设置来源
            picker.sourceType = type
            //允许编辑
            picker.allowsEditing = true
            //打开相机
            self.present(picker, animated: true, completion: { () -> Void in
                //                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
            })
        }else{
            print("no camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
//        NSData *data =UIImageJPEGRepresentation(image, 1.0);
        let imgdata = UIImageJPEGRepresentation(img, 0.6)
        let imgurl = method.uploadImage(imgData: imgdata!)
        if imgurl == ""{
            self.myNoticeError(title: "图片上传失败")
        }else{
            head_image.image = img
            newHeadImgUrl = imgurl
        }
//        let path:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
//        let cachepaht = path.appendingPathComponent("headImg.png")
//        do{
//            try UIImageJPEGRepresentation(img, 0.3)?.write(to: URL(fileURLWithPath: cachepaht))
//            _=method.uploadImage(imgData: imgdata!)
//            //            try UIImagePNGRepresentation(img)?.write(to: URL(fileURLWithPath: cachepaht))
////            self.loadingStatus()
////            HttpTool.shareHttpTool.Http_EditAvatar(){ (value) in
////                print(value)
////                guard value["status"].stringValue == "200"else{
////                    return
////                }
////                MyUserInfo.setValue(value["data"].stringValue, forKey: "UserImage")
////            }
//        }
//        catch {
//            print("什么异常")
//        }
        
    }
    func DECChoseAlert(title:String){
        sexLab.text = title
    }
    func backBtnClick(){
        if headimageUrlStr != newHeadImgUrl || signatureStr != signature.text! || nickNameStr != nickName.text! || (sexLab.text != "" && sexStr != (sexLab.text == "男" ? "0":"1")){
            //信息有变化
            let alert = UIAlertController(title: "提示", message: "你确定要放弃个人资料的修改吗", preferredStyle: .alert)
            let act1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let act2 = UIAlertAction(title: "确定", style: .default, handler: { (data) in
                self.backPage()
            })
            alert.addAction(act1)
            alert.addAction(act2)
            self.present(alert, animated: true, completion: nil)
        }else{
            self.backPage()
        }
    }
    func submitEdit(){
        //本地保存头像信息
        print(newHeadImgUrl)
        var nowSex=""
        if self.sexLab.text == "男"{
            nowSex = "0"
        }else{
            nowSex = "1"
        }
        HttpTool.shareHttpTool.Http_EditInfomation(nickName: nickName.text!, headUrl: newHeadImgUrl, sex: nowSex, signature: signature.text!) { (data) in
            print(data)
            guard data["code"].stringValue == "SUCCESS" else{
                self.myNoticeError(title: data["msg"].stringValue)
                return
            }
            //本地保存昵称信息
            if self.nickName.text != ""{
                self.nickNameStr = self.nickName.text!
            }
            //        //本地保存性别信息
            if self.sexLab.text == "男"{
                self.sexStr = "0"
            }else{
                self.sexStr = "1"
            }
            //        //本地保存签名信息
            self.signatureStr = self.signature.text!
//            if self.signature.text != ""{
//                self.signatureStr = self.signature.text!
//            }
            //        //本地保存签名信息
            if self.newHeadImgUrl != ""{
                self.headimageUrlStr = self.newHeadImgUrl
                print(self.headimageUrlStr)
            }
            self.myNoticeSuccess(title: data["msg"].stringValue)
            
            self.backPage()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
