//
//  JSMNeedConmentCell.swift
//  JSMachine
//  需求评价cell
//  Created by gouyz on 2019/4/11.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import Cosmos

class JSMNeedConmentCell: UITableViewCell {

    /// 填充数据
    var dataModel : JSMNeedConmentModel?{
        didSet{
            if let model = dataModel {
                useNameLab.text = model.nickname
                iconView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                ratingView.rating = Double.init(model.pscore!)!
                serviceRatingView.rating = Double.init(model.cscore!)!
                wlRatingView.rating = Double.init(model.wscore!)!

                dateLab.text =  model.pj_time?.getDateTime(format: "yyyy/MM/dd")
                contentLab.text = model.evaluate
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
        contentView.addSubview(iconView)
        contentView.addSubview(useNameLab)
        contentView.addSubview(dateLab)
        contentView.addSubview(ratingView)
        contentView.addSubview(desLab)
        contentView.addSubview(desLab1)
        contentView.addSubview(serviceRatingView)
        contentView.addSubview(desLab2)
        contentView.addSubview(wlRatingView)
        contentView.addSubview(contentLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(useNameLab)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        useNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.right.equalTo(dateLab.snp.left).offset(-kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(50)
        }
        dateLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(useNameLab)
            make.width.equalTo(80)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.top.equalTo(useNameLab.snp.bottom)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(kTitleHeight)
        }
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right).offset(kMargin)
            make.centerY.equalTo(desLab)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom)
        }
        serviceRatingView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab1.snp.right).offset(kMargin)
            make.centerY.equalTo(desLab1)
            make.width.height.equalTo(ratingView)
        }
        desLab2.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(desLab)
            make.top.equalTo(desLab1.snp.bottom)
        }
        wlRatingView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab2.snp.right).offset(kMargin)
            make.centerY.equalTo(desLab2)
            make.width.height.equalTo(ratingView)
        }
        contentLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.top.equalTo(desLab2.snp.bottom).offset(kMargin)
            make.left.equalTo(kMargin)
        }
    }
    /// 用户图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.cornerRadius = 22
        
        return imgView
    }()
    
    /// 用户名称
    lazy var useNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "陈光军"
        
        return lab
    }()
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "2018/12/11"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "商品"
        
        return lab
    }()
    ///星星评分
    lazy var ratingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .full
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 5
        ratingStart.settings.starSize = 30
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "服务"
        
        return lab
    }()
    ///星星评分
    lazy var serviceRatingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .full
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 5
        ratingStart.settings.starSize = 30
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    ///
    lazy var desLab2 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "物流"
        
        return lab
    }()
    ///星星评分
    lazy var wlRatingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .full
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 5
        ratingStart.settings.starSize = 30
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    /// 评价内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
}
