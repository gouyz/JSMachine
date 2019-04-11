//
//  JSMBidderCell.swift
//  JSMachine
//  竞标者cell
//  Created by gouyz on 2019/4/11.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import Cosmos

class JSMBidderCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMBiddingPersonDataModel?{
        didSet{
            if let model = dataModel {
                useNameLab.text = model.nickname
                iconView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                scoreLab.text = "评分：" + model.score!
                ratingView.rating = Double.init(model.score!)!
                
                priceLab.text = "竞标价：￥" + model.b_price!
                finishedDateLab.text = "交货日期：" + (model.b_delivery_time?.getDateTime(format: "yyyy-MM-dd"))!
                phoneLab.text = "联系电话：" + model.phone!
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
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(useNameLab)
        bgView.addSubview(ratingView)
        bgView.addSubview(scoreLab)
        bgView.addSubview(priceLab)
        bgView.addSubview(finishedDateLab)
        bgView.addSubview(phoneLab)
        bgView.addSubview(operatorLab)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.bottom.left.right.equalTo(contentView)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        useNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.right.equalTo(scoreLab.snp.left).offset(-kMargin)
            make.top.equalTo(iconView)
            make.height.equalTo(24)
        }
        scoreLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(useNameLab)
            make.width.equalTo(80)
        }
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(useNameLab)
            make.top.equalTo(useNameLab.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        finishedDateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceLab)
            make.top.equalTo(priceLab.snp.bottom)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceLab)
            make.top.equalTo(finishedDateLab.snp.bottom)
        }
        operatorLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.top.equalTo(phoneLab.snp.bottom).offset(kMargin)
            make.width.equalTo(70)
            make.height.equalTo(24)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
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
    ///星星评分
    lazy var ratingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .precise
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 3
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    /// 评分
    lazy var scoreLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .right
        lab.text = "评分：5"
        
        return lab
    }()
    /// 竞标价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "竞标价：￥500"
        
        return lab
    }()
    /// 交货日期
    lazy var finishedDateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "交货日期：2018-12-28"
        
        return lab
    }()
    /// 联系电话
    lazy var phoneLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "联系电话："
        
        return lab
    }()
    /// 招标
    lazy var operatorLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "招标"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
