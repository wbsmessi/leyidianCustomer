//
//  UserInfoViewController.swift
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/2/28.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController,adminItemViewDelegate,RecommendCategoryDelegate {
    
    let adminPageImgArr = ["quanbudingdan","daifukuan","daiqianshou","daipingjija","tuikuandan"]
    let adminPageTitleArr = ["全部订单","待付款","待签收","待评价","退款单"]
    var method = Methods()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = MyGlobalColor()
        creatView()
        
    }
    
    let headImage = UIImageView()
//    let userNickName = UILabel()
    let userNickName = UIButton()
    let signatureLab = UILabel()
    var messageBtn:UIButton!
    func creatView() {
        let topBgImg = UIImageView()
        topBgImg.frame = CGRect(x: 0, y: 0, width: app_width, height: (app_height - tab_height)/3)
        topBgImg.image = UIImage(named: "wode-bg")
        topBgImg.isUserInteractionEnabled = true
        self.view.addSubview(topBgImg)
        let tap = UITapGestureRecognizer(target: self, action: #selector(editUserInfo))
        topBgImg.addGestureRecognizer(tap)
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRect(x: app_width - 45, y: 30, width: 30, height: 30)
        rightBtn.setImage(UIImage(named:"youxiaoxi-bai"), for: .normal)//xiaoxi-bai
        rightBtn.addTarget(self, action: #selector(messageBtnClick), for: .touchUpInside)
        self.messageBtn = rightBtn
        self.view.addSubview(rightBtn)
        
        
        headImage.frame = CGRect(x: topBgImg.frame.width/2 - topBgImg.frame.width/8, y: topBgImg.frame.height/2 - topBgImg.frame.width/8, width: topBgImg.frame.width/4, height: topBgImg.frame.width/4)
        headImage.layer.cornerRadius = headImage.frame.width/2
        headImage.contentMode = .scaleAspectFill
        headImage.clipsToBounds = true
        headImage.layer.borderColor = UIColor.white.cgColor
        headImage.layer.borderWidth = 2.0
        topBgImg.addSubview(headImage)
        
        method.creatButton(btn: userNickName, x: 10, y: headImage.bottomPosition() + 5, wid: topBgImg.frame.width - 20, hei: 20, title: "用户昵称", titlecolor: UIColor.white, titleFont: 13, bgColor: UIColor.clear, superView: topBgImg)
        userNickName.setImage(UIImage(named: "nv"), for: .normal)
        self.userNickName.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.userNickName.titleLabel!.frame.width + 30, bottom: 0, right: -self.userNickName.titleLabel!.frame.width)
        self.userNickName.titleEdgeInsets = UIEdgeInsets(top: 0, left: -self.userNickName.imageView!.frame.width, bottom: 0, right: self.userNickName.imageView!.frame.width)
//        method.creatLabel(lab: userNickName, x: 10, y: headImage.bottomPosition() + 5, wid: topBgImg.frame.width - 20, hei: 20, textString: "", textcolor: UIColor.white, textFont: 12, superView: topBgImg)
//        userNickName.textAlignment = .center
        
        
        method.creatLabel(lab: signatureLab, x: 10, y: userNickName.bottomPosition(), wid: topBgImg.frame.width - 20, hei: userNickName.frame.height, textString: "", textcolor: UIColor.white, textFont: 11, superView: topBgImg)
        signatureLab.textAlignment = .center
        
        //四项推荐类型
        let RCM_CATEGORY = RecommendCategoryView(frame: CGRect(x: 0, y: topBgImg.bottomPosition(), width: app_width, height: 80))
        RCM_CATEGORY.initView(imgArr: adminPageImgArr, titleArr: adminPageTitleArr)
        RCM_CATEGORY.delegate=self
        self.view.addSubview(RCM_CATEGORY)
        
        let height_bo = app_width > ((app_height - tab_height) * 2/3 - 100) ? ((app_height - tab_height) * 2/3 - 100) : (app_width - 50)
        let adminview = adminItemView(frame: CGRect(x: 0, y: RCM_CATEGORY.bottomPosition(), width: app_width, height: height_bo - 30), line_itemCount: 3)
        adminview.initView(imgArr: ["wode-dingan","jifenduihuan","youhuiquan","shouhuodiz","hezuo","fxiang","gouwuzhinan","yijianfankui","shezhi"], titleArr: ["我的积分","积分兑换","我的优惠券","收获地址","申请合作","分享给好友","购物指南","意见反馈","设置"])
        adminview.delegate = self
        self.view.addSubview(adminview)
        
        method.drawLine(startX: adminview.frame.width/3, startY: 0, wid: 0.6, hei: adminview.frame.height, add: adminview)
        method.drawLine(startX: adminview.frame.width * 2/3, startY: 0, wid: 0.6, hei: adminview.frame.height, add: adminview)
        method.drawLine(startX: 0, startY: adminview.frame.height/3, wid: adminview.frame.width, hei: 0.6, add: adminview)
        method.drawLine(startX: 0, startY: adminview.frame.height * 2/3, wid: adminview.frame.width, hei: 0.6, add: adminview)
        
    }
    /****************************************************************************************
     ****************************************事件处理*****************************************
     ********************************************************************************************/
    func editUserInfo(){
        if method.isLogin(){
            let vc = EditUserInfoViewController()
            self.pushToNext(vc: vc)
        }else{
            self.pushToNext(vc: LoginAppViewController())
        }
        
    }
    func messageBtnClick(){
        let vc = MessageCenterViewController()
        self.pushToNext(vc: vc)
    }
    //订单类的delegate
    func didSelectItem(index: Int) {
        print(index)
        if method.isLogin(){
            let vc = OrderViewController()
            switch index {
            case 0:
                vc.orderType = orderTypeEnum.allOrder
            case 1:
                vc.orderType = orderTypeEnum.waitPay
            case 2:
                vc.orderType = orderTypeEnum.arrived
            case 3:
                vc.orderType = orderTypeEnum.waitEnv
            default:
                vc.orderType = orderTypeEnum.refund
            }
            self.pushToNext(vc: vc)
        }else{
            self.pushToNext(vc: LoginAppViewController())
        }
    }
    //九宫格的delegate
    func adminItemclick(index: Int) {
//        print(index)
        if index == 5{
            //分享到第三方
            UMSocialUIManager.showShareMenuViewInWindow(platformSelectionBlock: { (platformType, userInfo) in
                //分享
                UMSocialSwiftInterface().shareWebpageToPlatformType(platformType: platformType, vc: self)
            })
        }else{
//            跳页
            if method.isLogin(){
                var vc:UIViewController!
                switch index {
                case 0:
                    vc = MyScoreViewController()
                case 1:
                    //积分兑换
                    vc = LYDWebViewController()
//                    print(HttpTool().getDuibaUrl())
                    (vc as! LYDWebViewController).nav_title = "积分兑换"
                    (vc as! LYDWebViewController).loadUrl = HttpTool().getDuibaUrl()
//                    vc.url = headerUrlShot + getDesKey(param: "mallApp/mallUrl?userID=\(UserId)"))
                case 2:
                    vc = CouponViewController()
                    (vc as! CouponViewController).initListView()
                case 3:
                    vc = AddressViewController()
                case 4:
                    vc = CooperationViewController()
                case 6:
                    vc = ShopGuideViewController()
                case 7:
                    vc = FeedBackViewController()
                default:
                    vc = SettingViewController()
                }
                self.pushToNext(vc: vc)
            }else{
                self.pushToNext(vc: LoginAppViewController())
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        print("ssssss")
        if method.isLogin(){
            let user_Image = MyUserInfo.value(forKey: userInfoKey.headUrl.rawValue) as? String
            let user_nickName = MyUserInfo.value(forKey: userInfoKey.nickName.rawValue) as? String
            let user_signature = MyUserInfo.value(forKey: userInfoKey.signature.rawValue) as? String
            let user_sex = MyUserInfo.value(forKey: userInfoKey.sex.rawValue) as? String
//            print(user_Image)
            DispatchQueue.main.async {
                self.method.loadImageWithDefault(imgUrl: user_Image ?? "0", Img_View: self.headImage, defaultImage: "weidenglu")
//                self.method.loadImage(imgUrl: user_Image ?? "0", Img_View: self.headImage)
                self.userNickName.setTitle(user_nickName ?? "", for: .normal)
                self.signatureLab.text = user_signature ?? "登录后，体验乐易点带给你的品质生活"
                self.userNickName.setImage(UIImage(named: user_sex! == "1" ? "nv":"nan"), for: .normal)
                
                self.userNickName.titleEdgeInsets = UIEdgeInsets(top: 0, left: -self.userNickName.imageView!.frame.width - 5, bottom: 0, right: self.userNickName.imageView!.frame.width + 5)
                self.userNickName.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.userNickName.titleLabel!.frame.width + 5, bottom: 0, right: -self.userNickName.titleLabel!.frame.width - 5)
            }
        }else{
//            self.method.loadImage(imgUrl: user_Image ?? "0", Img_View: self.headImage)
            self.headImage.image = UIImage(named: "weidenglu")
//            self.userNickName.text = "立即登录／注册"
            self.userNickName.setTitle("立即登录／注册", for: .normal)
            self.userNickName.setImage(UIImage(named: ""), for: .normal)
            self.signatureLab.text = "登录后，体验乐易点带给你的品质生活"
        }
        self.noticeNumber()
    }
    
    func noticeNumber(){
        HttpTool.shareHttpTool.Http_getNoticeNum{ (data) in
            print(data)
            DispatchQueue.main.async {
                if data["resultData"]["notice_type_p"].intValue > 0 || data["resultData"]["notice_type_s"].intValue > 0{
                    //需要通知的红点
                    self.messageBtn.setImage(UIImage(named:"youxiaoxi-bai"), for: .normal)
                }else{
                    self.messageBtn.setImage(UIImage(named:"xiaoxi-bai"), for: .normal)
                }
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
