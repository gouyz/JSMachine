//
//  JSMHomeNewsCell.swift
//  JSMachine
//  首页 需求信息cell
//  Created by gouyz on 2018/11/22.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMHomeNewsCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMNeedModel?{
        didSet{
            if let model = dataModel {

                titleLab.text = model.pro_model
                numberLab.text = "x" + model.num!
                dateLab.text = model.create_date?.getDateTime(format: "yyyy-MM-dd")
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
        contentView.addSubview(dateLab)
        contentView.addSubview(numberLab)
        contentView.addSubview(detailLab)
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(dateLab.snp.left).offset(-5)
            make.top.equalTo(contentView)
            make.height.equalTo(30)
        }
        dateLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(titleLab)
            make.width.equalTo(120)
        }
        numberLab.snp.makeConstraints { (make) in
            make.right.equalTo(detailLab.snp.left).offset(-kMargin)
            make.top.equalTo(titleLab.snp.bottom)
            make.left.height.equalTo(titleLab)
        }
        detailLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(numberLab)
            make.size.equalTo(CGSize.init(width: 60, height: 24))
        }
        
    }
    
    /// title
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.text = "TDY500_71_TDY500"
        
        return lab
    }()
    ///
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.textAlignment = .right
        lab.text = "2019-04-22"
        
        return lab
    }()
    
    /// 数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k13Font
        lab.text = "5555台"
        
        return lab
    }()
    
    ///
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.backgroundColor = kBtnClickBGColor
        lab.cornerRadius = kCornerRadius
        lab.textAlignment = .center
        lab.text = "详情"
        
        return lab
    }()
    
}
