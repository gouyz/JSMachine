//
//  JSMModifyEmailVC.swift
//  JSMachine
//  修改邮箱
//  Created by gouyz on 2018/11/25.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMModifyEmailVC: GYZBaseVC {

    var email: String = ""
    /// 选择结果回调
    var resultBlock:((_ email: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "修改邮箱"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(bgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(contentField)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(bgView)
            make.width.equalTo(80)
        }
        contentField.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(nameLab)
        }
        
        contentField.text = email
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 昵称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "邮箱："
        
        return lab
    }()
    
    /// 输入内容
    lazy var contentField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.textAlignment = .right
        textFiled.placeholder = "请输入邮箱"
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    
    
    /// 保存
    @objc func onClickRightBtn(){
        
        //除去前后空格,防止只输入空格的情况
        let content = contentField.text?.trimmingCharacters(in: .whitespaces)
        if (content?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入邮箱")
            return
        }
        if !(content?.isValidateEmail())! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的邮箱")
            return
        }
       requestModifyUserInfo()
    }
    
    /// 修改个人资料
    func requestModifyUserInfo(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/saveInfo", parameters: ["user_id": userDefaults.string(forKey: "userId") ?? "","email":contentField.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!((weakSelf?.contentField.text)!)
                }
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
