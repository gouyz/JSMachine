//
//  JSMMineHeaderView.swift
//  JSMachine
//  我的 header
//  Created by gouyz on 2018/11/23.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMMineHeaderView: UIView {
    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(bgViewImg)
        bgViewImg.addSubview(userHeaderView)
        bgViewImg.addSubview(nameLab)
        
        bgViewImg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(kStateHeight)
        }
        userHeaderView.snp.makeConstraints { (make) in
            make.center.equalTo(bgViewImg)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userHeaderView.snp.bottom)
            make.height.equalTo(30)
        }
    }
    
    /// 背景
    lazy var bgViewImg: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_mine_bg"))
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    /// 用户头像 图片
    lazy var userHeaderView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_header_default"))
        imgView.cornerRadius = 30
        
        return imgView
    }()
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "登录/注册"
        
        return lab
    }()
    
}
