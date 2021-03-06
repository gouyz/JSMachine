//
//  JSMMyFavouriteCell.swift
//  JSMachine
//  我的收藏 cell
//  Created by gouyz on 2018/11/25.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMMyFavouriteCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMFavouriteModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.shop_name
                iconView.kf.setImage(with: URL.init(string: model.img!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                numberLab.text = "\(model.sum!)人关注"
                
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
        contentView.addSubview(nameLab)
        contentView.addSubview(numberLab)
        contentView.addSubview(ziXunLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 150, height: 80))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        ziXunLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.bottom.equalTo(iconView)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
    }
    
    /// 商品图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        imgView.cornerRadius = kCornerRadius
        
        return imgView
    }()
    
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "齿轮减速机"
        
        return lab
    }()
    /// 关注人数
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.text = "122人关注"
        
        return lab
    }()
    /// 咨询
    lazy var ziXunLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "咨询"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kBlueFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
