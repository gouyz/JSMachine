//
//  JSMMySaleServiceFooterView.swift
//  JSMachine
//  我的售后 footer
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMMySaleServiceFooterView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(downIconView)
        
        downIconView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 16, height: 13))
        }
    }
    /// 向下箭头图标
    lazy var downIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_service_down"))
}

