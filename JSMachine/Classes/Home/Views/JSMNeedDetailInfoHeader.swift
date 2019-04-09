//
//  JSMNeedDetailInfoHeader.swift
//  JSMachine
//  需求详情 竞标信息header
//  Created by gouyz on 2019/4/9.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMNeedDetailInfoHeader: UITableViewHeaderFooterView {

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
        contentView.addSubview(titleLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(-kMargin)
        }
    }
    
    /// 图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_jingbiao_tag")
        
        return imgView
    }()
    
    /// 名称
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "竞标信息"
        
        return lab
    }()
}
