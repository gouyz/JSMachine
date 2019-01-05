//
//  JSMSelectedEngineerCell.swift
//  JSMachine
//  选择工程师cell
//  Created by gouyz on 2019/1/5.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMSelectedEngineerCell: UITableViewCell {

    /// 填充数据
    var dataModel : JSMSelectedEngineerModel?{
        didSet{
            if let model = dataModel {
                userImgView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                nameLab.text = "工程师：" + model.real_name!
                statusLab.text = "当前状态：" + model.status!
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
        
        contentView.addSubview(userImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(statusLab)
        contentView.addSubview(operatorLab)
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.right.equalTo(operatorLab.snp.left).offset(-kMargin)
            make.top.equalTo(userImgView)
            make.height.equalTo(24)
        }
        statusLab.snp.makeConstraints { (make) in
            make.right.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(userImgView)
        }
        operatorLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentView)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        
    }
    /// 用户头像
    lazy var userImgView : UIImageView = {
        let img = UIImageView()
        img.cornerRadius = 22
        img.borderColor = kWhiteColor
        img.borderWidth = klineDoubleWidth
        
        return img
    }()
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 状态
    lazy var statusLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 操作
    lazy var operatorLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "分配"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
