//
//  JSMBiddingDetailImgCell.swift
//  JSMachine
//  图片 cell
//  Created by gouyz on 2019/4/10.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMBiddingDetailImgCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(iconView)
        // 布局子控件
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.height.equalTo(kScreenWidth  * 0.3)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
        }
    }
    
    /// 图片
    lazy var iconView : UIImageView = {
        let imgview = UIImageView()
        imgview.backgroundColor = kBackgroundColor
        
        return imgview
    }()
}

