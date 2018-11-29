//
//  JSMPersonnelVC.swift
//  JSMachine
//  人才库
//  Created by gouyz on 2018/11/21.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMPersonnelVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "职位申请"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交申请", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setupUI()
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(userHeaderView)
        contentView.addSubview(desLab)
        contentView.addSubview(nameDesLab)
        contentView.addSubview(nameTextField)
        contentView.addSubview(birthdayDesLab)
        contentView.addSubview(birthdayLab)
        contentView.addSubview(rightIconView)
        contentView.addSubview(sexDesLab)
        contentView.addSubview(sexLab)
        contentView.addSubview(rightIconView1)
        contentView.addSubview(lineView)
        
        contentView.addSubview(phoneDesLab)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(jobDesLab)
        contentView.addSubview(jobLab)
        contentView.addSubview(rightIconView2)
        contentView.addSubview(addressDesLab)
        contentView.addSubview(addressTextField)
        
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
        
        userHeaderView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(contentView)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(userHeaderView.snp.bottom)
            make.height.equalTo(30)
        }
        nameDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(desLab.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameDesLab)
            make.top.equalTo(nameDesLab.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        birthdayDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameDesLab)
            make.top.equalTo(nameTextField.snp.bottom).offset(kMargin)
        }
        birthdayLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameTextField)
            make.top.equalTo(birthdayDesLab.snp.bottom)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(birthdayLab)
            make.size.equalTo(rightArrowSize)
        }
        sexDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameDesLab)
            make.top.equalTo(birthdayLab.snp.bottom).offset(kMargin)
        }
        sexLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameTextField)
            make.top.equalTo(sexDesLab.snp.bottom)
            make.right.equalTo(rightIconView1.snp.left).offset(-5)
        }
        rightIconView1.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(sexLab)
            make.size.equalTo(rightArrowSize)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameDesLab)
            make.top.equalTo(sexLab.snp.bottom).offset(kMargin)
            make.height.equalTo(klineWidth)
        }
        phoneDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameDesLab)
            make.top.equalTo(lineView.snp.bottom).offset(20)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameTextField)
            make.top.equalTo(phoneDesLab.snp.bottom)
        }
        jobDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameDesLab)
            make.top.equalTo(phoneTextField.snp.bottom).offset(kMargin)
        }
        jobLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameTextField)
            make.top.equalTo(jobDesLab.snp.bottom)
            make.right.equalTo(rightIconView2.snp.left).offset(-5)
        }
        rightIconView2.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(jobLab)
            make.size.equalTo(rightArrowSize)
        }
        addressDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameDesLab)
            make.top.equalTo(jobLab.snp.bottom).offset(kMargin)
        }
        addressTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameTextField)
            make.top.equalTo(addressDesLab.snp.bottom)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
    }
    
    /// scrollView
    lazy var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    lazy var contentView: UIView = UIView()
    /// 用户头像 图片
    lazy var userHeaderView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_header_gray_default"))
        imgView.cornerRadius = 30
        
        return imgView
    }()
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "上传头像"
        
        return lab
    }()
    ///
    lazy var nameDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "名字"
        
        return lab
    }()
    ///
    lazy var nameTextField : UITextField = {
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的真实姓名"
        
        return textFiled
    }()
    ///
    lazy var birthdayDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "出生年月"
        
        return lab
    }()
    ///
    lazy var birthdayLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "请选择您的出生年月"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    ///
    lazy var sexDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "性别"
        
        return lab
    }()
    ///
    lazy var sexLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "请选择您的性别"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView1: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    ///
    lazy var phoneDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "手机号码"
        
        return lab
    }()
    ///
    lazy var phoneTextField : UITextField = {
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的手机号码"
        textFiled.keyboardType = .numberPad
        
        return textFiled
    }()
    ///
    lazy var jobDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "专业类型"
        
        return lab
    }()
    ///
    lazy var jobLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "请选择您的职位"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView2: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    ///
    lazy var addressDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "目前所在地"
        
        return lab
    }()
    ///
    lazy var addressTextField : UITextField = {
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入您的目前所在地"
        
        return textFiled
    }()
    
    /// 提交申请
    @objc func onClickRightBtn(){
        
    }
}
