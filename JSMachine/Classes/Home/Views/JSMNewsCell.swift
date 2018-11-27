//
//  JSMNewsCell.swift
//  JSMachine
//  行业资讯cell
//  Created by gouyz on 2018/11/27.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMNewsCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(titleLab)
        contentView.addSubview(timeLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(contentImgView)
        contentView.addSubview(sharedImgView)
        
        contentImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 100, height: 70))
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(contentImgView.snp.right).offset(kMargin)
            make.right.equalTo(sharedImgView.snp.left).offset(-5)
            make.height.equalTo(30)
            make.top.equalTo(contentImgView)
        }
    
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.left.equalTo(titleLab)
            make.top.equalTo(contentLab.snp.bottom)
            make.bottom.equalTo(contentImgView)
        }
        
        sharedImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentImgView)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
    }
    
    /// title
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        lab.text = "《绳锯机的定义》"
        
        return lab
    }()
    
    /// 时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.text = "2018.11.22"
        
        return lab
    }()
    
    ///
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.text = "绳锯机是应用于绳锯机是应用于绳锯机是应用于绳锯机是应用于绳锯机是应用于绳锯机是应用于绳锯机是应用于。"
        
        return lab
    }()
    
    /// 图片
    lazy var contentImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = kCornerRadius
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// 分享图片
    lazy var sharedImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_shared_blue")
        
        return imgView
    }()
}
