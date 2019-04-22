//
//  JSMEngineerListCell.swift
//  JSMachine
//  工程师列表cell
//  Created by gouyz on 2019/4/12.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMEngineerListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMEngineerModel?{
        didSet{
            if let model = dataModel {
                iconView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                useNameLab.text = model.real_name
                numberLab.text = "工号：" + model.code!
                dateLab.text = "入职时间：" + (model.date?.getDateTime(format: "yyyy-MM-dd"))!
                phoneLab.text = "联系方式：" + model.phone!
                workTypeLab.text = "工作类型：" + model.position!
                addressLab.text = "所在地点：" + model.address!
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(useNameLab)
        bgView.addSubview(dateLab)
        bgView.addSubview(phoneLab)
        bgView.addSubview(numberLab)
        bgView.addSubview(workTypeLab)
        bgView.addSubview(addressLab)
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
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconView)
            make.height.equalTo(kTitleHeight)
        }
        numberLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconView.snp.bottom)
            make.left.equalTo(kMargin)
            make.height.equalTo(30)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberLab)
             make.top.equalTo(numberLab.snp.bottom)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberLab)
            make.top.equalTo(dateLab.snp.bottom)
        }
        workTypeLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberLab)
            make.top.equalTo(phoneLab.snp.bottom)
        }
        addressLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberLab)
            make.top.equalTo(workTypeLab.snp.bottom)
        }
        
        operatorLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(70)
            make.height.equalTo(0)
            make.top.equalTo(addressLab.snp.bottom)
//            make.height.equalTo(24)
//            make.top.equalTo(addressLab.snp.bottom).offset(kMargin)
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
    /// 工号
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "工号："
        
        return lab
    }()
    /// 入职时间
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "入职时间："
        
        return lab
    }()
    /// 联系方式
    lazy var phoneLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "联系方式："
        
        return lab
    }()
    /// 工作类型
    lazy var workTypeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "工作类型："
        
        return lab
    }()
    /// 所在地点
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.text = "所在地点："
        
        return lab
    }()
    
    /// 操作
    lazy var operatorLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "离职"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        lab.isHidden = true
        
        return lab
    }()
}
