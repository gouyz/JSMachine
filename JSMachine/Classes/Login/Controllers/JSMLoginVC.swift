//
//  JSMLoginVC.swift
//  JSMachine
//  登录
//  Created by gouyz on 2018/11/21.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMLoginVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "登  录"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("注册", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setupUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(phoneInputView)
        view.addSubview(lineView)
        view.addSubview(pwdInputView)
        view.addSubview(lineView1)
        view.addSubview(loginBtn)
        view.addSubview(forgetPwdBtn)
        view.addSubview(userLoginBtn)
        view.addSubview(netDotLoginBtn)
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(phoneInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(pwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        userLoginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom).offset(kUIButtonHeight)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(kUIButtonHeight)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(userLoginBtn)
            make.top.equalTo(userLoginBtn.snp.bottom).offset(30)
        }
        netDotLoginBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(userLoginBtn)
            make.top.equalTo(loginBtn.snp.bottom).offset(30)
        }
        forgetPwdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(netDotLoginBtn.snp.bottom).offset(20)
            make.right.equalTo(loginBtn)
            make.size.equalTo(CGSize(width:70,height:20))
        }
    }
    /// 手机号
    fileprivate lazy var phoneInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_phone", placeHolder: "请输入手机号码", isPhone: true)
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 密码
    fileprivate lazy var pwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请输入密码", isPhone: false)
    
    /// 分割线2
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 忘记密码按钮
    fileprivate lazy var forgetPwdBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("忘记密码?", for: .normal)
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(clickedForgetPwdBtn), for: .touchUpInside)
        return btn
    }()
    /// 登录按钮
    fileprivate lazy var userLoginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("登  录", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedUserLoginBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        return btn
    }()
    
    /// 工程师登录按钮
    fileprivate lazy var loginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitle("工程师登录", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedLoginBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        
        return btn
    }()
    /// 网点登录按钮
    fileprivate lazy var netDotLoginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitle("网点登录", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedNetDotLoginBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        
        return btn
    }()
    /// 网点登录
    @objc func onClickedNetDotLoginBtn(){
        hiddenKeyBoard()
        
        if !validPhoneNO() {
            return
        }
        
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        requestNetDotLogin()
    }
    
    /// 工程师登录
    @objc func onClickedLoginBtn(){
        hiddenKeyBoard()
        
        if !validPhoneNO() {
            return
        }
        
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        requestEngineerLogin()
    }
    /// 用户登录
    @objc func clickedUserLoginBtn() {
        hiddenKeyBoard()
        
        if !validPhoneNO() {
            return
        }

        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }

        requestLogin()
    }
    /// 忘记密码
    @objc func clickedForgetPwdBtn() {
        let forgetPwdVC = JSMForgetPwdVC()
//        forgetPwdVC.registerType = .forgetpwd
        navigationController?.pushViewController(forgetPwdVC, animated: true)
    }
    
    /// 注册
    @objc func onClickRightBtn(){
        let vc = JSMRegisterVC()
        navigationController?.pushViewController(vc, animated: true)
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
    /// 隐藏键盘
    func hiddenKeyBoard(){
        phoneInputView.textFiled.resignFirstResponder()
        pwdInputView.textFiled.resignFirstResponder()
    }
    
    /// 用户登录
    func requestLogin(){
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("login/userLogin", parameters: ["phone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(false, forKey: kIsEngineerLoginTagKey)//是否工程师登录标识
                userDefaults.set(false, forKey: kIsNetDotLoginTagKey)//是否网点登录标识
                userDefaults.set(data["user_id"].stringValue, forKey: "userId")//用户ID
                userDefaults.set(data["phone"].stringValue, forKey: "phone")//用户电话
                userDefaults.set(data["head"].stringValue, forKey: "head")//用户头像
                JPUSHService.setAlias("testgyz", completion: { (iResCode, iAlias, seq) in
                    
                }, seq: 0)
                KeyWindow.rootViewController = GYZMainTabBarVC()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 工程师登录
    func requestEngineerLogin(){
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("login/engineerLogin", parameters: ["phone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(true, forKey: kIsEngineerLoginTagKey)//是否工程师登录标识
                userDefaults.set(false, forKey: kIsNetDotLoginTagKey)//是否网点登录标识
                userDefaults.set(data["id"].stringValue, forKey: "userId")//用户ID
                userDefaults.set(data["phone"].stringValue, forKey: "phone")//用户电话
                userDefaults.set(data["head"].stringValue, forKey: "head")//用户头像
                userDefaults.set(data["real_name"].stringValue, forKey: "realName")//用户姓名
                userDefaults.set(data["code"].stringValue, forKey: "code")//工程师工号
                userDefaults.set(data["sex"].stringValue, forKey: "sex")//性别（1男2女）
                userDefaults.set(data["birthday"].stringValue, forKey: "birthday")//工程师生日
                
                KeyWindow.rootViewController = GYZBaseNavigationVC.init(rootViewController: JSMEngineerHomerVC())
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 网点登录
    func requestNetDotLogin(){
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("login/dotLogin", parameters: ["phone":phoneInputView.textFiled.text!,"password": pwdInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(false, forKey: kIsEngineerLoginTagKey)//是否工程师登录标识
                userDefaults.set(true, forKey: kIsNetDotLoginTagKey)//是否网点登录标识
                userDefaults.set(data["id"].stringValue, forKey: "userId")//用户ID
                userDefaults.set(data["dot_name"].stringValue, forKey: "dotName")//网点名称
                userDefaults.set(data["fzr_phone"].stringValue, forKey: "phone")//网点负责人手机号
                
                KeyWindow.rootViewController = GYZBaseNavigationVC.init(rootViewController: JSMNetDotHomeVC())
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
