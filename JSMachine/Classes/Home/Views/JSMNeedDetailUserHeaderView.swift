//
//  JSMNeedDetailUserHeaderView.swift
//  JSMachine
//  需求详情用户信息 header
//  Created by gouyz on 2019/4/9.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMNeedDetailUserHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(iconView)
        contentView.addSubview(useNameLab)
        contentView.addSubview(dateLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        useNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(dateLab.snp.left).offset(-kMargin)
        }
        
        dateLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(-kMargin)
            make.width.equalTo(90)
        }
    }
    
    /// 用户图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.cornerRadius = 15
        
        return imgView
    }()
    
    /// 用户名称
    lazy var useNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "陈光军"
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "2018/11/28"
        
        return lab
    }()
}
