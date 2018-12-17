//
//  JSMPersonnelSuccessVC.swift
//  JSMachine
//  人才库提交成功
//  Created by gouyz on 2018/12/17.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMPersonnelSuccessVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "提交成功"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(iconView)
        iconView.addSubview(successIconView)
        iconView.addSubview(successLab)
        view.addSubview(homeBtn)
        
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(kScreenWidth * 0.7)
        }
        successIconView.snp.makeConstraints { (make) in
            make.center.equalTo(iconView)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        successLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(successIconView.snp.bottom)
            make.height.equalTo(50)
        }
        
        homeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(iconView.snp.bottom).offset(40)
            make.height.equalTo(kUIButtonHeight)
        }
    }
    
    /// 图片
    lazy var iconView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_talent_bg")
        
        return imgView
    }()
    
    /// 图片
    lazy var successIconView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_success")
        
        return imgView
    }()
    
    /// 成功
    lazy var successLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.numberOfLines = 2
        lab.text = "提交成功！\n请您耐心等待，我们将有专业人员尽快与您联系"
        
        return lab
    }()
    /// 首页按钮
    fileprivate lazy var homeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("首 页", for: .normal)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedHomeBtn), for: .touchUpInside)
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        
        return btn
    }()
    
   
    
    /// 首页按钮
    @objc func clickedHomeBtn(){
        self.tabBarController?.selectedIndex = 0
        navigationController?.popToRootViewController(animated: true)
        
    }
}

