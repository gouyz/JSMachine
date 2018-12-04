//
//  JSMSaleServiceDetailStepCell.swift
//  JSMachine
//
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMSaleServiceDetailStepCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        contentView.addSubview(stepView)
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(stepView.snp.bottom)
            make.bottom.equalTo(-kMargin)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stepView: GYZStepProgressView = GYZStepProgressView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
    
    /// 底部线
    lazy var lineView: UIView = UIView()
}

