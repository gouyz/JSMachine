//
//  JSMHomeNewsCell.swift
//  JSMachine
//  首页行业资讯cell
//  Created by gouyz on 2018/11/22.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMHomeNewsCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMNewsModel?{
        didSet{
            if let model = dataModel {
            
                titleLab.text = model.title
                contentLab.text = model.subtitle
                contentImgView.kf.setImage(with: URL.init(string: model.img!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                timeLab.text = model.add_time?.getDateTime(format: "yyyy-MM-dd")
            }
        }
    }

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
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(timeLab.snp.left).offset(-5)
            make.height.equalTo(40)
            make.top.equalTo(contentView)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(titleLab)
            make.width.equalTo(70)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(titleLab.snp.bottom)
        }
        contentImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLab)
            make.top.equalTo(contentLab.snp.bottom).offset(5)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.27)
            make.bottom.equalTo(-kMargin)
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
        lab.font = k12Font
        lab.textAlignment = .right
        lab.text = "2018.11.22"
        
        return lab
    }()
    
    ///
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
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
}
