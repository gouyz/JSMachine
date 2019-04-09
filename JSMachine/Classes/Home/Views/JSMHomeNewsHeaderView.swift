//
//  JSMHomeNewsHeaderView.swift
//  JSMachine
//  行业资讯 header
//  Created by gouyz on 2018/11/22.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMHomeNewsHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(nameLab)
//        contentView.addSubview(tagImgView)
//        contentView.addSubview(desLab)
//        contentView.addSubview(rightIconView)
        
//        tagImgView.snp.makeConstraints { (make) in
//            make.left.equalTo(kMargin)
//            make.centerY.equalTo(contentView)
//            make.size.equalTo(CGSize.init(width: 3, height: 20))
//        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(-kMargin)
        }
        
//        desLab.snp.makeConstraints { (make) in
//            make.top.bottom.equalTo(contentView)
//            make.right.equalTo(rightIconView.snp.left).offset(-5)
//            make.width.equalTo(60)
//        }
//        rightIconView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(contentView)
//            make.right.equalTo(contentView).offset(-kMargin)
//            make.size.equalTo(rightArrowSize)
//        }
    }
    
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "需 求 信 息 栏"
        
        return lab
    }()
    
    /// 图片
//    lazy var tagImgView : UIImageView = {
//        let imgView = UIImageView()
//        imgView.image = UIImage.init(named: "icon_vertical_line")
//
//        return imgView
//    }()
//
//    lazy var desLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k13Font
//        lab.textColor = kGaryFontColor
//        lab.textAlignment = .right
//        lab.text = "更多"
//
//        return lab
//    }()
//    /// 右侧箭头图标
//    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
}
