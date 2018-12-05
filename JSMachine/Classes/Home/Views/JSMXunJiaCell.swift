//
//  JSMXunJiaCell.swift
//  JSMachine
//  询价  cell
//  Created by gouyz on 2018/12/5.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMXunJiaCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(nameLab)
        contentView.addSubview(moneyLab)
        contentView.addSubview(operatorView)
        operatorView.addSubview(operatorLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(moneyLab)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(operatorView)
        }
        operatorView.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLab.snp.right)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(nameLab)
            make.right.equalTo(-kMargin)
        }
        operatorLab.snp.makeConstraints { (make) in
            make.right.centerY.equalTo(operatorView)
            make.size.equalTo(CGSize.init(width: 50, height: 24))
        }
    }
    
    /// 姓名
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    /// 单价
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var operatorView: UIView = UIView()
    /// 操作
    lazy var operatorLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        
        lab.cornerRadius = kCornerRadius
        lab.borderWidth = klineWidth
        lab.borderColor = kRedFontColor
        
        return lab
    }()
}
