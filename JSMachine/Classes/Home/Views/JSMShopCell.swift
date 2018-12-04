//
//  JSMShopCell.swift
//  JSMachine
//  商城 商品cell
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMShopCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.addSubview(tagImgView)
        bgView.addSubview(nameLab)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tagImgView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.centerX.equalTo(bgView)
            make.left.equalTo(2)
            make.right.equalTo(-2)
            make.height.equalTo((kScreenWidth - 100 - 4 - 4) / 2)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(5)
            make.top.equalTo(tagImgView.snp.bottom)
            make.right.equalTo(bgView).offset(-5)
            make.bottom.equalTo(bgView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    ///tag图片
    lazy var tagImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "拓石贸易"
        
        return lab
    }()
}
