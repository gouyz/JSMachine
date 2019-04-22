//
//  JSMSubmitBidingCell.swift
//  JSMachine
//  提交竞标cell
//  Created by gouyz on 2019/4/22.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMSubmitBidingCell: UITableViewCell {

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
            make.top.equalTo(contentView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        
        textFiled.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom)
            make.bottom.equalTo(-kMargin)
        }
    }
    
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        
        return lab
    }()
    /// 输入框
    lazy var textFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.borderColor = kGrayLineColor
        textFiled.borderWidth = klineWidth
        textFiled.cornerRadius = kCornerRadius
        return textFiled
    }()

}
