//
//  JSMAuthenticityResultVC.swift
//  JSMachine
//  真伪查询结果
//  Created by gouyz on 2018/11/29.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMAuthenticityResultVC: GYZBaseVC {
    
    /// 查询成功
    var isSuccess: Bool = true
    var result: String = ""
    var shopName: String = ""
    var jsmNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "真伪查询结果"
        
        setupUI()
        
        if isSuccess || userDefaults.bool(forKey: kIsEngineerLoginTagKey) || userDefaults.bool(forKey: kIsNetDotLoginTagKey) {
            bgComplainView.isHidden = true
            submitBtn.isHidden = true
        }else{
            phoneInputView.textFiled.keyboardType = .numberPad
        }
        
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(iconView)
        contentView.addSubview(bgView)
        bgView.addSubview(tagImgView)
        bgView.addSubview(desLab)
        bgView.addSubview(lineView)
        bgView.addSubview(typeInputView)
        bgView.addSubview(lineView1)
        bgView.addSubview(numberInputView)
        bgView.addSubview(lineView2)
        bgView.addSubview(resultView)
        
        contentView.addSubview(bgComplainView)
        bgComplainView.addSubview(tagImgView1)
        bgComplainView.addSubview(desLab1)
        bgComplainView.addSubview(lineView3)
        bgComplainView.addSubview(complainCPInputView)
        bgComplainView.addSubview(lineView4)
        bgComplainView.addSubview(complainCGInputView)
        bgComplainView.addSubview(lineView5)
        bgComplainView.addSubview(complainNoInputView)
        bgComplainView.addSubview(lineView6)
        bgComplainView.addSubview(phoneInputView)
        bgComplainView.addSubview(lineView7)
        bgComplainView.addSubview(companyInputView)
        bgComplainView.addSubview(lineView8)
        bgComplainView.addSubview(personInputView)
        
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
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.48)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
            make.height.equalTo(200 + klineWidth * 3)
            
            if isSuccess{
                // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
                // 否则的话，上面的控件会被强制拉伸变形
                // 最后的-10是边距，这个可以随意设置
                make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
            }
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab)
            make.size.equalTo(CGSize.init(width: 3, height: 20))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        typeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(bgView)
            make.height.equalTo(desLab)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(typeInputView.snp.bottom)
            make.height.left.right.equalTo(lineView)
        }
        numberInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        lineView2.snp.makeConstraints { (make) in
            make.top.equalTo(numberInputView.snp.bottom)
            make.height.left.right.equalTo(lineView)
        }
        resultView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom)
            make.left.right.height.equalTo(typeInputView)
        }
        
        bgComplainView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView.snp.bottom).offset(kMargin)
            if isSuccess {
                make.height.equalTo(0)
            }else{
                make.height.equalTo(350 + klineWidth * 6)
            }
        }
        tagImgView1.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab1)
            make.size.equalTo(tagImgView)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView1.snp.right).offset(5)
            make.top.equalTo(bgComplainView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgComplainView)
            make.top.equalTo(desLab1.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        complainCPInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom)
            make.left.right.equalTo(bgComplainView)
            make.height.equalTo(desLab1)
        }
        lineView4.snp.makeConstraints { (make) in
            make.top.equalTo(complainCPInputView.snp.bottom)
            make.height.left.right.equalTo(lineView3)
        }
        complainCGInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView4.snp.bottom)
            make.left.right.height.equalTo(complainCPInputView)
        }
        lineView5.snp.makeConstraints { (make) in
            make.top.equalTo(complainCGInputView.snp.bottom)
            make.height.left.right.equalTo(lineView3)
        }
        complainNoInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView5.snp.bottom)
            make.left.right.height.equalTo(complainCPInputView)
        }
        lineView6.snp.makeConstraints { (make) in
            make.top.equalTo(complainNoInputView.snp.bottom)
            make.height.left.right.equalTo(lineView3)
        }
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView6.snp.bottom)
            make.left.right.height.equalTo(complainCPInputView)
        }
        lineView7.snp.makeConstraints { (make) in
            make.top.equalTo(phoneInputView.snp.bottom)
            make.height.left.right.equalTo(lineView3)
        }
        companyInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView7.snp.bottom)
            make.left.right.height.equalTo(complainCPInputView)
        }
        lineView8.snp.makeConstraints { (make) in
            make.top.equalTo(companyInputView.snp.bottom)
            make.height.left.right.equalTo(lineView3)
        }
        personInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView8.snp.bottom)
            make.left.right.height.equalTo(complainCPInputView)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(iconView)
            make.top.equalTo(bgComplainView.snp.bottom).offset(20)
            
            if isSuccess {
                make.height.equalTo(0)
            }else{
                make.height.equalTo(kUIButtonHeight)
                // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
                // 否则的话，上面的控件会被强制拉伸变形
                // 最后的-10是边距，这个可以随意设置
                make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
            }
        }
        
    }
    
    /// scrollView
    lazy var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    lazy var contentView: UIView = UIView()
    /// banner
    lazy var iconView:UIImageView = UIImageView.init(image: UIImage.init(named: "icon_authenticity_banner"))
    
    ///
    lazy var bgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "查询结果"
        
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
    /// 减速机品牌
    lazy var typeInputView : GYZLabAndLabView = {
        let inputView = GYZLabAndLabView()
        inputView.desLab.text = "减速机品牌："
        inputView.contentLab.text = shopName
        
        return inputView
    }()
    /// 分割线2
    lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 出厂编号
    lazy var numberInputView : GYZLabAndLabView = {
        let inputView = GYZLabAndLabView()
        inputView.desLab.text = "出厂编号："
        inputView.contentLab.text = jsmNumber
        
        return inputView
    }()
    /// 分割线2
    lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 对应型号
    lazy var resultView : GYZLabAndLabView = {
        let inputView = GYZLabAndLabView()
        inputView.desLab.text = "对应型号："
        inputView.contentLab.text = result
        inputView.contentLab.textColor = kRedFontColor
        
        return inputView
    }()
    
    ///
    lazy var bgComplainView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "投诉"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView1 : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    /// 分割线2
    lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 产品品牌
    lazy var complainCPInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "产品品牌：", placeHolder: "请输入产品品牌")
    /// 分割线2
    lazy var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 采购型号
    lazy var complainCGInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "采购型号：", placeHolder: "请输入采购型号")
    /// 分割线2
    lazy var lineView5 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 出厂编号
    lazy var complainNoInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "出厂编号：", placeHolder: "请输入出厂编号")
    /// 分割线2
    lazy var lineView6 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 联系方式
    lazy var phoneInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "联系方式：", placeHolder: "请输入联系方式")
    /// 分割线2
    lazy var lineView7 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 企业名称
    lazy var companyInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "企业名称：", placeHolder: "请输入企业名称")
    /// 分割线2
    lazy var lineView8 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 联系人
    lazy var personInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "联系人：", placeHolder: "请输入联系人姓名")
    
    /// 提交投诉按钮
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提交投诉", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        
        return btn
    }()
    
    /// 提交按钮
    @objc func onClickedSubmitBtn(){
        if (complainCPInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入产品品牌")
            return
        }
        if (complainCGInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入采购型号")
            return
        }
        if (complainNoInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入出厂编号")
            return
        }
        if (phoneInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入联系方式")
            return
        }
        if !phoneInputView.textFiled.text!.isMobileNumber() {
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的联系方式")
            return
        }
        if (companyInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入企业名称")
            return
        }
        if (personInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入联系人姓名")
            return
        }
        
        requestSubmitDatas()
    }
    
    ///真伪查询投诉
    func requestSubmitDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("shop/complaint",parameters: ["band":complainCPInputView.textFiled.text!,"model":complainCGInputView.textFiled.text!,"num":complainNoInputView.textFiled.text!,"phone":phoneInputView.textFiled.text!,"c_name":companyInputView.textFiled.text!,"name":personInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.clickedBackBtn()
                
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
