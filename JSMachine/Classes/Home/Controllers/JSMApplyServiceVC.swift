//
//  JSMApplyServiceVC.swift
//  JSMachine
//  售后申请
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMApplyServiceVC: GYZBaseVC {
    
    /// 是否申请配件
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "售后申请"
        setupUI()
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(personBgView)
        personBgView.addSubview(tagImgView)
        personBgView.addSubview(desLab)
        personBgView.addSubview(lineView)
        personBgView.addSubview(nameInputView)
        personBgView.addSubview(lineView1)
        personBgView.addSubview(numberInputView)
        
        contentView.addSubview(addressBgView)
        addressBgView.addSubview(tagImgView1)
        addressBgView.addSubview(desLab1)
        addressBgView.addSubview(lineView2)
        addressBgView.addSubview(cityInputView)
        addressBgView.addSubview(lineView3)
        addressBgView.addSubview(addressInputView)
        
        contentView.addSubview(detailBgView)
        detailBgView.addSubview(desLab2)
        detailBgView.addSubview(tagImgView2)
        detailBgView.addSubview(lineView4)
        detailBgView.addSubview(typeInputView)
        detailBgView.addSubview(lineView5)
        detailBgView.addSubview(reasonInputView)
        detailBgView.addSubview(lineView6)
        detailBgView.addSubview(applyInputView)
        detailBgView.addSubview(rightIconView)
        
        contentView.addSubview(noteBgView)
        noteBgView.addSubview(tagImgView3)
        noteBgView.addSubview(desLab3)
        noteBgView.addSubview(lineView7)
        noteBgView.addSubview(noteInputView)
        
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
        personBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(kMargin)
            make.height.equalTo(150 + klineDoubleWidth)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab)
            make.size.equalTo(CGSize.init(width: 3, height: 20))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.equalTo(personBgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(personBgView)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        nameInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(personBgView)
            make.height.equalTo(desLab)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(nameInputView.snp.bottom)
            make.height.left.right.equalTo(lineView)
        }
        numberInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom)
            make.right.left.height.equalTo(nameInputView)
        }
        
        addressBgView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(personBgView)
            make.top.equalTo(personBgView.snp.bottom).offset(kMargin)
        }
        tagImgView1.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab1)
            make.size.equalTo(tagImgView)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView1.snp.right).offset(5)
            make.top.equalTo(addressBgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(addressBgView)
            make.top.equalTo(desLab1.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        cityInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom)
            make.left.right.equalTo(addressBgView)
            make.height.equalTo(desLab1)
        }
        lineView3.snp.makeConstraints { (make) in
            make.top.equalTo(cityInputView.snp.bottom)
            make.height.left.right.equalTo(lineView2)
        }
        addressInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom)
            make.right.left.height.equalTo(cityInputView)
        }
        
        detailBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(personBgView)
            make.top.equalTo(addressBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(200 + klineWidth * 3)
        }
        tagImgView2.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab2)
            make.size.equalTo(tagImgView)
        }
        desLab2.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView2.snp.right).offset(5)
            make.top.equalTo(detailBgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.equalTo(detailBgView)
            make.top.equalTo(desLab2.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        typeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView4.snp.bottom)
            make.left.right.equalTo(detailBgView)
            make.height.equalTo(desLab2)
        }
        lineView5.snp.makeConstraints { (make) in
            make.top.equalTo(typeInputView.snp.bottom)
            make.height.left.right.equalTo(lineView4)
        }
        reasonInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView5.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineView6.snp.makeConstraints { (make) in
            make.top.equalTo(reasonInputView.snp.bottom)
            make.height.left.right.equalTo(lineView4)
        }
        applyInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView6.snp.bottom)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
            make.height.left.equalTo(reasonInputView)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(applyInputView)
            make.size.equalTo(rightArrowSize)
        }
        noteBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(personBgView)
            make.top.equalTo(detailBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(100 + klineWidth)
        }
        tagImgView3.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab3)
            make.size.equalTo(tagImgView)
        }
        desLab3.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView3.snp.right).offset(5)
            make.top.equalTo(noteBgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView7.snp.makeConstraints { (make) in
            make.left.right.equalTo(noteBgView)
            make.top.equalTo(desLab3.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        noteInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView7.snp.bottom)
            make.left.right.equalTo(noteBgView)
            make.height.equalTo(desLab3)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(noteBgView.snp.bottom).offset(30)
            make.height.equalTo(kUIButtonHeight)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
        numberInputView.textFiled.keyboardType = .numberPad
        applyInputView.textFiled.isEnabled = false
        applyInputView.addOnClickListener(target: self, action: #selector(onClickedSelectedApply))
        applyInputView.textFiled.text = "否"
        
        if userDefaults.string(forKey: kCompanyCity) != nil {
            cityInputView.textFiled.text = userDefaults.string(forKey: kCompanyCity)
            addressInputView.textFiled.text = userDefaults.string(forKey: kCompanyAddress)
        }
        
    }
    
    /// scrollView
    lazy var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    lazy var contentView: UIView = UIView()
    
    ///
    lazy var personBgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "联系人"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    /// 分割线2
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 姓名
    lazy var nameInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "姓名：", placeHolder: "请输入联系人姓名")
    /// 分割线2
    lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 电话
    lazy var numberInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "电话：", placeHolder: "请输入联系方式")
    
    ///
    lazy var addressBgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "公司地址"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView1 : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    /// 分割线2
    lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 公司地址
    lazy var cityInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "公司地址：", placeHolder: "请输入市/区")
    /// 分割线2
    lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 具体地址
    lazy var addressInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "具体地址：", placeHolder: "请输入详细门牌号")
    
    ///
    lazy var detailBgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab2 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "故障详情"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView2 : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    /// 分割线2
    lazy var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 机械型号
    lazy var typeInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "机械型号：", placeHolder: "请输入机械型号")
    /// 分割线2
    lazy var lineView5 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 故障原因
    lazy var reasonInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "故障原因：", placeHolder: "请输入故障原因")
    /// 分割线2
    lazy var lineView6 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 申请配件
    lazy var applyInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "申请配件：", placeHolder: "是否申请配件")
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    ///
    lazy var noteBgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab3 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "备注"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView3 : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    /// 分割线2
    lazy var lineView7 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 备注说明
    lazy var noteInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "备注说明：", placeHolder: "请输入详细备注说明")
    
    /// 提交按钮
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提 交", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        
        return btn
    }()
    
    /// 提交按钮
    @objc func onClickedSubmitBtn(){

        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            goLogin()
        }else{
            if (nameInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入联系人姓名")
                return
            }
            if (numberInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入联系方式")
                return
            }
            if (cityInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入公司地址")
                return
            }
            if (addressInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入具体地址")
                return
            }
            if (typeInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入型号")
                return
            }
            if (reasonInputView.textFiled.text?.isEmpty)! {
                MBProgressHUD.showAutoDismissHUD(message: "请输入故障原因")
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
    
    ///提交
    func requestSubmitDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("application/apply",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","model":typeInputView.textFiled.text!,"a_name":nameInputView.textFiled.text!,"a_phone":numberInputView.textFiled.text!,"c_address":cityInputView.textFiled.text!,"s_address":addressInputView.textFiled.text!,"f_reason":reasonInputView.textFiled.text!,"a_remark":noteInputView.textFiled.text ?? "","a_part":selectedIndex],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.saveCompanyInfo()
                weakSelf?.clickedBackBtn()
                
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 保存公司信息
    func saveCompanyInfo(){
        userDefaults.set(cityInputView.textFiled.text!, forKey: kCompanyCity)
        userDefaults.set(addressInputView.textFiled.text!, forKey: kCompanyAddress)
    }
    /// 是否申请配件
    @objc func onClickedSelectedApply(){
        GYZAlertViewTools.alertViewTools.showSheet(title: "是否申请配件", message: nil, cancleTitle: "取消", titleArray: ["否","是"], viewController: self) { [weak self](index) in
            
            if index != cancelIndex{
                self?.selectedIndex = index
            }
        }
    }

}
