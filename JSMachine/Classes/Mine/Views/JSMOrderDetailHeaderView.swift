//
//  JSMOrderDetailHeaderView.swift
//  JSMachine
//  订单详情 header
//  Created by gouyz on 2018/11/27.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMOrderDetailHeaderView: UITableViewHeaderFooterView {
    
    var dataModel : JSMOrderModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = "供货商：" + model.title!
                iconView.kf.setImage(with: URL.init(string: model.img!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                goodsNameLab.text = model.shop_name
                numberLab.text = "x" + model.num!
                
                
            }
        }
    }
    
    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(nameLab)
        contentView.addSubview(lineView)
        contentView.addSubview(iconView)
        contentView.addSubview(goodsNameLab)
        contentView.addSubview(numberLab)
        contentView.addSubview(lineView1)
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 70))
        }
        goodsNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(goodsNameLab)
            make.top.equalTo(goodsNameLab.snp.bottom)
            make.height.greaterThanOrEqualTo(20)
            make.bottom.equalTo(iconView)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
        }
    }
    
    /// 供货商
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "供货商：国贸减速机"
        
        return lab
    }()
    /// 底部线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 商品图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// 商品名称
    lazy var goodsNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        lab.text = "齿轮减速机"
        
        return lab
    }()
    /// 数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "x1"
        
        return lab
    }()
    /// 底部线
    lazy var lineView1: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}

