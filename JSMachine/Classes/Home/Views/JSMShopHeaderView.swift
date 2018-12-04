//
//  JSMShopHeaderView.swift
//  JSMachine
//  商城 header
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMShopHeaderView: UICollectionReusableView {
    
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = kBackgroundColor
        
        addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
