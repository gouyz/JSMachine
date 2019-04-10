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
    /// 型号控件数组
    var typeViewArr: [GYZLabAndFieldView] = [GYZLabAndFieldView]()
    /// 型号控件对应数量数组
    var numViewArr: [GYZLabAndFieldView] = [GYZLabAndFieldView]()
    /// 备注控件数组
    var noteViewArr: [GYZLabAndFieldView] = [GYZLabAndFieldView]()
    
    var inputModels: String = ""
    var inputNums: String = ""
    var inputNotes: String = ""

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
        contentView.addSubview(addBtn)
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
    
        numInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(numInputView.snp.bottom)
        }
        noteInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(noteInputView.snp.bottom)
        }
        addBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView5.snp.bottom)
            make.size.equalTo(CGSize.init(width: 60, height: kTitleHeight))
        }
        dateInputView.snp.makeConstraints { (make) in
            make.left.height.equalTo(typeInputView)
            make.right.equalTo(rightIconView.snp.left)
            make.top.equalTo(addBtn.snp.bottom)
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
        
        ziXunBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(lineView4.snp.bottom).offset(50)
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
        
        typeViewArr.append(typeInputView)
        numViewArr.append(numInputView)
        noteViewArr.append(noteInputView)
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
    /// 数量
    fileprivate lazy var numInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "数量：", placeHolder: "请输入数量")
    /// 分割线3
    fileprivate lazy var lineView3 : UIView = {
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
    /// 添加
    lazy var addBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_goods_add"), for: .normal)
        
        btn.addTarget(self, action: #selector(onClickedAddBtn), for: .touchUpInside)
        
        return btn
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
    /// 添加按钮
    @objc func onClickedAddBtn(){
        /// 型号
        let typeInputViews : GYZLabAndFieldView = GYZLabAndFieldView(desName: "型号：", placeHolder: "请输入型号")
        
        /// 分割线
        let lineViews : UIView = {
            let line = UIView()
            line.backgroundColor = kGrayLineColor
            return line
        }()
        /// 数量
        let numInputViews : GYZLabAndFieldView = GYZLabAndFieldView(desName: "数量：", placeHolder: "请输入数量")
        /// 分割线3
        let lineViews1 : UIView = {
            let line = UIView()
            line.backgroundColor = kGrayLineColor
            return line
        }()
        /// 备注
        let noteInputViews : GYZLabAndFieldView = GYZLabAndFieldView(desName: "备注：", placeHolder: "请输入备注")
        /// 分割线3
        let lineViews2 : UIView = {
            let line = UIView()
            line.backgroundColor = kGrayLineColor
            return line
        }()
        contentView.addSubview(typeInputViews)
        contentView.addSubview(lineViews)
        contentView.addSubview(numInputViews)
        contentView.addSubview(lineViews1)
        contentView.addSubview(noteInputViews)
        contentView.addSubview(lineViews2)
        
        typeInputViews.snp.makeConstraints { (make) in
            make.top.equalTo(noteViewArr[noteViewArr.count - 1].snp.bottom).offset(klineWidth)
            make.left.right.height.equalTo(typeInputView)
        }
        lineViews.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(typeInputViews.snp.bottom)
        }
        numInputViews.snp.makeConstraints { (make) in
            make.top.equalTo(lineViews.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineViews1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(numInputViews.snp.bottom)
        }
        noteInputViews.snp.makeConstraints { (make) in
            make.top.equalTo(lineViews1.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineViews2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(noteInputViews.snp.bottom)
        }
        addBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(contentView).offset(-kMargin)
            make.top.equalTo(lineViews2.snp.bottom)
            make.size.equalTo(CGSize.init(width: 60, height: kTitleHeight))
        }
        
        typeViewArr.append(typeInputViews)
        numViewArr.append(numInputViews)
        noteViewArr.append(noteInputViews)
    }
    
    
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
            inputNotes = ""
            inputModels = ""
            inputNums = ""
            
            for typeField in typeViewArr {
                if (typeField.textFiled.text?.isEmpty)! {
                    MBProgressHUD.showAutoDismissHUD(message: "请输入型号")
                    return
                }
                inputModels += typeField.textFiled.text! + " / "
            }
            if inputModels.count > 0{
                inputModels = inputModels.subString(start: 0, length: inputModels.count - 3)
            }
            for typeField in numViewArr {
                if (typeField.textFiled.text?.isEmpty)! {
                    MBProgressHUD.showAutoDismissHUD(message: "请输入数量")
                    return
                }
                inputNums += typeField.textFiled.text! + " / "
            }
            if inputNums.count > 0{
                inputNums = inputNums.subString(start: 0, length: inputNums.count - 3)
            }
            for typeField in noteViewArr {
                var txt: String = " "
                if !(typeField.textFiled.text?.isEmpty)! {
                    txt = typeField.textFiled.text!
                }
                inputNotes += txt + " / "
            }
            if inputNotes.count > 0{
                inputNotes = inputNotes.subString(start: 0, length: inputNotes.count - 3)
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
        
        GYZNetWork.requestNetwork("need/releaseNeed",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","pro_model":inputModels,"num":inputNums,"remark":inputNotes,"deal_date":selectTime],  success: { (response) in
            
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
