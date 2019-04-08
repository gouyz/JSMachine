//
//  JSMNetDotRegisterVC.swift
//  JSMachine
//  网点注册
//  Created by gouyz on 2019/4/8.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMNetDotRegisterVC: GYZBaseVC {

    /// 选择营业执照
    var selectUserImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "网点注册"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(phoneInputView)
        contentView.addSubview(lineView)
        contentView.addSubview(bgView)
        bgView.addSubview(codeInputView)
        bgView.addSubview(codeBtn)
        bgView.addSubview(lineView1)
        contentView.addSubview(pwdInputView)
        contentView.addSubview(lineView2)
        contentView.addSubview(repwdInputView)
        contentView.addSubview(lineView3)
        contentView.addSubview(netDotNameInputView)
        contentView.addSubview(lineView5)
        contentView.addSubview(NetDotManagerInputView)
        contentView.addSubview(lineView6)
        contentView.addSubview(netDotAddressInputView)
        contentView.addSubview(lineView7)
        
        contentView.addSubview(yyzzInputView)
        contentView.addSubview(lineView4)
        contentView.addSubview(yyzzImgView)
        view.addSubview(okBtn)
        
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(okBtn.snp.top)
        }
        okBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.equalTo(contentView)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(phoneInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        codeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView)
            make.left.equalTo(bgView)
            make.right.equalTo(codeBtn.snp.left).offset(-kMargin)
            make.bottom.equalTo(lineView1.snp.top)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.bottom.equalTo(bgView)
            make.height.equalTo(lineView)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(bgView).offset(-kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 30))
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(pwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        
        repwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(repwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        netDotNameInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(lineView3.snp.bottom)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(netDotNameInputView.snp.bottom)
        }
        NetDotManagerInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(lineView5.snp.bottom)
        }
        lineView6.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(NetDotManagerInputView.snp.bottom)
        }
        netDotAddressInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(lineView6.snp.bottom)
        }
        lineView7.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(netDotAddressInputView.snp.bottom)
        }
        yyzzInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(lineView7.snp.bottom)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(yyzzInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        
        yyzzImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.width.equalTo(kScreenWidth * 0.5)
            make.height.equalTo(kScreenWidth * 0.33)///kScreenWidth * 0.5 * 0.65
            make.top.equalTo(lineView4.snp.bottom).offset(kMargin)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
    }
    
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    /// 手机号
    fileprivate lazy var phoneInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_phone", placeHolder: "请输入手机号码", isPhone: true)
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 验证码
    fileprivate lazy var codeInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_code", placeHolder: "请输入验证码", isPhone: true)
    
    /// 分割线2
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        return view
    }()
    /// 密码
    fileprivate lazy var pwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请输入新密码", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 确认密码
    fileprivate lazy var repwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请再次输入新密码", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 获取验证码按钮
    fileprivate lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("发送验证码", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k14Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kBtnClickBGColor
        btn.addTarget(self, action: #selector(clickedCodeBtn(btn:)), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    /// 网点名称
    fileprivate lazy var netDotNameInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_netdot_name", placeHolder: "请输入网点名称", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView5 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 负责人姓名
    fileprivate lazy var NetDotManagerInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_netdot_manager_name", placeHolder: "请输入负责人姓名", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView6 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 网点地址
    fileprivate lazy var netDotAddressInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_address", placeHolder: "请输入网点地址", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView7 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    lazy var yyzzInputView : GYZLoginInputView = {
        let yyzzView = GYZLoginInputView()
        yyzzView.iconView.image = UIImage.init(named: "icon_yyzz")
        yyzzView.textFiled.isEnabled = false
        yyzzView.textFiled.textColor = kGaryFontColor
        yyzzView.textFiled.text = "上传营业执照照片"
        
        return yyzzView
    }()
    /// 分割线3
    fileprivate lazy var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 营业执照照片
    lazy var yyzzImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = kCornerRadius
        imgView.image = UIImage.init(named: "icon_add_img_yyzz")
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectImg))
        
        return imgView
    }()
    
    /// 确定按钮
    fileprivate lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("注  册", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedOkBtn(btn:)), for: .touchUpInside)
        
        return btn
    }()
    
    
    /// 注册
    @objc func clickedOkBtn(btn: UIButton){
        hiddenKeyBoard()
        
        if !validPhoneNO() {
            return
        }
        if codeInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }
        
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        if repwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入确认密码")
            return
        }
        if (pwdInputView.textFiled.text != repwdInputView.textFiled.text){
            MBProgressHUD.showAutoDismissHUD(message: "密码和确认密码不一致")
            return
        }
        if netDotNameInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入网点名称")
            return
        }
        if NetDotManagerInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入负责人姓名")
            return
        }
        if netDotAddressInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入网点地址")
            return
        }
        if selectUserImg == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请上传营业执照")
            return
        }
        
        requestRegister()
        
    }
    
    /// 选择营业执照
    @objc func onClickedSelectImg(){
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [weak self] (image) in
            
            self?.selectUserImg = image
            self?.yyzzImgView.image = image
        })
    }
    /// 判断手机号是否有效
    ///
    /// - Returns:
    func validPhoneNO() -> Bool{
        
        if phoneInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return false
        }
        if phoneInputView.textFiled.text!.isMobileNumber(){
            return true
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return false
        }
        
    }
    /// 获取验证码
    @objc func clickedCodeBtn(btn: UIButton){
        hiddenKeyBoard()
        if validPhoneNO() {
            requestCode()
        }
    }
    
    
    /// 注册
    func requestRegister(){
        
        weak var weakSelf = self
        createHUD(message: "注册中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        if selectUserImg != nil {
            
            imgParam.name = "licence"
            imgParam.fileName = "licence.jpg"
            imgParam.mimeType = "image/jpg"
            imgParam.data = UIImageJPEGRepresentation(selectUserImg!, 0.5)
        }
        
        GYZNetWork.uploadImageRequest("login/dotReg", parameters: ["phone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!,"passagain": repwdInputView.textFiled.text!,"code":codeInputView.textFiled.text!,"fzr_name":NetDotManagerInputView.textFiled.text!,"dot_name":netDotNameInputView.textFiled.text!,"address":netDotAddressInputView.textFiled.text!], uploadParam: selectUserImg == nil ? [] : [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(false, forKey: kIsEngineerLoginTagKey)//是否工程师登录标识
                userDefaults.set(true, forKey: kIsNetDotLoginTagKey)//是否网点登录标识
                userDefaults.set(data["id"].stringValue, forKey: "userId")//用户ID
                userDefaults.set(data["phone"].stringValue, forKey: "phone")//用户电话
                
                JPUSHService.setAlias(data["jg_id"].stringValue, completion: { (iResCode, iAlias, seq) in
                    
                }, seq: 0)
                KeyWindow.rootViewController = GYZBaseNavigationVC.init(rootViewController: JSMNetDotHomeVC())
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 隐藏键盘
    func hiddenKeyBoard(){
        phoneInputView.textFiled.resignFirstResponder()
        pwdInputView.textFiled.resignFirstResponder()
        codeInputView.textFiled.resignFirstResponder()
    }
    
    ///获取验证码
    func requestCode(){
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("login/sms_send", parameters: ["phone":phoneInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.codeBtn.startSMSWithDuration(duration: 60)
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
}
