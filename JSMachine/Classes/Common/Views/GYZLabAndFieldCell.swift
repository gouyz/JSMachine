//
//  GYZLabAndFieldCell.swift
//  JSMachine
//  label 和 textField cell
//  Created by gouyz on 2019/4/9.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class GYZLabAndFieldCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(desLab)
        contentView.addSubview(textFiled)
        // 布局子控件
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.bottom.equalTo(-5)
            make.top.equalTo(5)
            make.height.greaterThanOrEqualTo(34)
            make.width.equalTo(100)
        }
        
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right).offset(kMargin)
            make.top.bottom.equalTo(desLab)
            make.right.equalTo(-kMargin)
        }
    }
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 输入框
    lazy var textFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        return textFiled
    }()
}
