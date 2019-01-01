//
//  JSMPublishNeedVC.swift
//  JSMachine
//  发布需求
//  Created by gouyz on 2018/11/27.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMPublishNeedVC: GYZBaseVC {
    
    /// 选择时间戳
    var selectTime: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "发布快购"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(typeInputView)
        contentView.addSubview(lineView)
        contentView.addSubview(roteInputView)
        contentView.addSubview(lineView2)
        contentView.addSubview(numInputView)
        contentView.addSubview(lineView3)
        contentView.addSubview(dateInputView)
        contentView.addSubview(rightIconView)
        contentView.addSubview(lineView4)
        contentView.addSubview(noteInputView)
        contentView.addSubview(lineView5)
        
        contentView.addSubview(ziXunBtn)
        contentView.addSubview(submitBtn)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        
        typeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.equalTo(contentView)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(typeInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        roteInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(roteInputView.snp.bottom)
        }
        
        numInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(numInputView.snp.bottom)
        }
        
        dateInputView.snp.makeConstraints { (make) in
            make.left.height.equalTo(typeInputView)
            make.right.equalTo(rightIconView.snp.left)
            make.top.equalTo(lineView3.snp.bottom)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(dateInputView)
            make.size.equalTo(rightArrowSize)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(dateInputView.snp.bottom)
        }
        noteInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView4.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(noteInputView.snp.bottom)
        }
        
        ziXunBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(lineView5.snp.bottom).offset(50)
            make.height.equalTo(kUIButtonHeight)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(ziXunBtn)
            make.top.equalTo(ziXunBtn.snp.bottom).offset(20)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
        dateInputView.textFiled.isEnabled = false
        dateInputView.addOnClickListener(target: self, action: #selector(onClickedSelectedDate))
        
    }
    
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    /// 型号
    fileprivate lazy var typeInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "型号：", placeHolder: "请输入型号")
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 传动比
    fileprivate lazy var roteInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "传动比：", placeHolder: "请输入传动比")
    
    /// 分割线2
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 数量
    fileprivate lazy var numInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "数量：", placeHolder: "请输入数量")
    /// 分割线3
    fileprivate lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 交货期
    fileprivate lazy var dateInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "交货期：", placeHolder: "请选择交货期")
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    /// 分割线3
    fileprivate lazy var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 备注
    fileprivate lazy var noteInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "备注：", placeHolder: "请输入备注")
    /// 分割线3
    fileprivate lazy var lineView5 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 在线咨询按钮
    fileprivate lazy var ziXunBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("在线咨询", for: .normal)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedZiXunBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        
        return btn
    }()
    
    /// 提交按钮
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提交快购", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        
        return btn
    }()
    
    
    /// 在线咨询按钮
    @objc func clickedZiXunBtn(){
        goOnLineVC()
    }
    //技术在线
    func goOnLineVC(){
        let vc = JSMTechnologyOnlineVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 提交按钮
    @objc func onClickedSubmitBtn(){
        
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            goLogin()
        }else{
            if (typeInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入型号")
                return
            }
            if (roteInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入传动比")
                return
            }
            if (dateInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请选择交货期")
                return
            }
            
            requestSubmitDatas()
        }
        
    }
    /// 登录
    func goLogin(){
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///需求提交
    func requestSubmitDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("need/releaseNeed",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","pro_model":typeInputView.textFiled.text!,"drive_ratio":roteInputView.textFiled.text!,"num":numInputView.textFiled.text!,"remark":noteInputView.textFiled.text ?? "","deal_date":selectTime],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.goSuccessVC()
                
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 发布成功vc
    func goSuccessVC(){
        let vc = JSMPublishSuccessVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 选择日期
    @objc func onClickedSelectedDate(){
        UsefulPickerView.showDatePicker("请选择交货期") { [weak self](date) in
            self?.selectTime = Int(date.timeIntervalSince1970)
            self?.dateInputView.textFiled.text = date.dateToStringWithFormat(format: "yyyy-MM-dd")
        }
    }
}
