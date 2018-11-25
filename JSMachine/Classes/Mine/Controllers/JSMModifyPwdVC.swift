//
//  JSMModifyPwdVC.swift
//  JSMachine
//  修改密码
//  Created by gouyz on 2018/11/25.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMModifyPwdVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "修改密码"
        self.view.backgroundColor = kWhiteColor
        
        
        view.addSubview(oldPwdFiled)
        view.addSubview(lineView)
        view.addSubview(pwdFiled)
        view.addSubview(lineView1)
        view.addSubview(rePwdFiled)
        view.addSubview(lineView2)
        
        view.addSubview(modifyBtn)
        
        oldPwdFiled.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(oldPwdFiled)
            make.top.equalTo(oldPwdFiled.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        pwdFiled.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(oldPwdFiled)
            make.top.equalTo(lineView.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(pwdFiled.snp.bottom)
        }
        rePwdFiled.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(oldPwdFiled)
            make.top.equalTo(lineView1.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(rePwdFiled.snp.bottom)
        }
        
        modifyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(lineView2.snp.bottom).offset(50)
            make.height.equalTo(kUIButtonHeight)
        }
    }
    

    /// 输入框
    lazy var oldPwdFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入原密码"
        textFiled.cornerRadius = kCornerRadius
        textFiled.isSecureTextEntry = true
        
        return textFiled
    }()
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 输入框
    lazy var pwdFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入新密码"
        textFiled.cornerRadius = kCornerRadius
        textFiled.isSecureTextEntry = true
        
        return textFiled
    }()
    /// 分割线
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 输入框
    lazy var rePwdFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请重新输入新密码"
        textFiled.cornerRadius = kCornerRadius
        textFiled.isSecureTextEntry = true
        
        return textFiled
    }()
    /// 分割线
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    /// 确认按钮
    lazy var modifyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("确认修改", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedModifyBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        return btn
    }()
    /// 确认修改
    @objc func clickedModifyBtn(){
        
    }
}
