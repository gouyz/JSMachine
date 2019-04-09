//
//  JSMNeedDetailCell.swift
//  JSMachine
//  需求详情cell
//  Created by gouyz on 2019/4/9.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMNeedDetailCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(typeLab)
        contentView.addSubview(noteLab)
        contentView.addSubview(numberLab)
        
        
        typeLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(contentView)
            make.height.equalTo(30)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(typeLab.snp.bottom)
        }
        noteLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(typeLab)
            make.top.equalTo(numberLab.snp.bottom).offset(kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    
    /// 产品型号
    lazy var typeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品型号：KRV-40E-121-B"
        
        return lab
    }()
    /// 产品数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品数量：2（个）"
        
        return lab
    }()
    /// 用户备注
    lazy var noteLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.text = "用户备注：0.3kv"
        
        return lab
    }()
    
}
