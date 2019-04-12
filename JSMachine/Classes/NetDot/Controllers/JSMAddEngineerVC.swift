//
//  JSMAddEngineerVC.swift
//  JSMachine
//  添加工程师
//  Created by gouyz on 2019/4/12.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMAddEngineerVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    /// 工作类型
    var typeList: [JSMWorkTypeModel] = [JSMWorkTypeModel]()
    var typeNameList: [String] = [String]()
    var selectedIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "添加工程师"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        phoneInputView.textFiled.keyboardType = .numberPad
        requestWorkTypeDatas()
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameInputView)
        contentView.addSubview(lineView)
        contentView.addSubview(codeInputView)
        contentView.addSubview(lineView1)
        contentView.addSubview(phoneInputView)
        contentView.addSubview(lineView2)
        contentView.addSubview(workTypeInputView)
        contentView.addSubview(rightIconView)
        contentView.addSubview(lineView3)
        contentView.addSubview(addressInputView)
        contentView.addSubview(lineView4)
        
        contentView.addSubview(desLab)
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
        
        nameInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.equalTo(contentView)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(nameInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        codeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.height.equalTo(nameInputView)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(codeInputView.snp.bottom)
        }
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom)
            make.left.right.height.equalTo(nameInputView)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(phoneInputView.snp.bottom)
        }
        workTypeInputView.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameInputView)
            make.right.equalTo(rightIconView.snp.left)
            make.top.equalTo(lineView2.snp.bottom)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(workTypeInputView)
            make.size.equalTo(rightArrowSize)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(workTypeInputView.snp.bottom)
        }
        addressInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom)
            make.left.right.height.equalTo(nameInputView)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(addressInputView.snp.bottom)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView4.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(desLab.snp.bottom).offset(30)
            make.height.equalTo(kUIButtonHeight)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
        workTypeInputView.textFiled.isEnabled = false
        workTypeInputView.addOnClickListener(target: self, action: #selector(onClickedSelectedWorkType))
        
    }
    
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    /// 姓名
    fileprivate lazy var nameInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "姓名：", placeHolder: "请输入姓名")
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 工号
    fileprivate lazy var codeInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "工号：", placeHolder: "请输入工号")
    /// 分割线3
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 联系方式
    fileprivate lazy var phoneInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "联系方式：", placeHolder: "请输入联系方式")
    /// 分割线3
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 工作类型
    fileprivate lazy var workTypeInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "工作类型：", placeHolder: "请选择工作类型")
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    /// 分割线3
    fileprivate lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 所在地点
    fileprivate lazy var addressInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "所在地点：", placeHolder: "请输入所在地点")
    /// 分割线3
    fileprivate lazy var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "默认登录密码000000"
        
        return lab
    }()
    
    /// 提交按钮
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        
        return btn
    }()
    
    ///获取工作类型列表数据
    func requestWorkTypeDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("second/addIndex",parameters: nil,  success: { (response) in
            
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMWorkTypeModel.init(dict: itemInfo)
                    
                    weakSelf?.typeNameList.append(model.position!)
                    weakSelf?.typeList.append(model)
                }
                
                if weakSelf?.typeList.count > 0{
                    weakSelf?.selectedIndex = 0
                    weakSelf?.workTypeInputView.textFiled.text = weakSelf?.typeNameList[0]
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    /// 提交按钮
    @objc func onClickedSubmitBtn(){
        if (nameInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入姓名")
            return
        }
        if (codeInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入工号")
            return
        }
        if (phoneInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入联系方式")
            return
        }else if !phoneInputView.textFiled.text!.isMobileNumber(){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return
        }
        if (addressInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入所在地点")
            return
        }
        if selectedIndex == -1 {
            MBProgressHUD.showAutoDismissHUD(message: "请选择工作类型")
            return
        }
        
        requestSubmitDatas()
    }
    /// 选择工作类型
    @objc func onClickedSelectedWorkType(){
        if typeList.count > 0 {
            UsefulPickerView.showSingleColPicker("请选择工作类型", data: typeNameList, defaultSelectedIndex: selectedIndex) {[weak self] (index, value) in
                self?.selectedIndex = index
                self?.workTypeInputView.textFiled.text = value
            }
        }
    }
    ///需求提交
    func requestSubmitDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/addEngineer",parameters: ["d_id":userDefaults.string(forKey: "userId") ?? "","code":codeInputView.textFiled.text!,"type":typeList[selectedIndex].id!,"real_name":nameInputView.textFiled.text!,"phone":phoneInputView.textFiled.text!,"address":addressInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
