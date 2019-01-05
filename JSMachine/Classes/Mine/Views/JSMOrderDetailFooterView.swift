//
//  JSMOrderDetailFooterView.swift
//  JSMachine
//  订单物流footer
//  Created by gouyz on 2019/1/5.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMOrderDetailFooterView: UITableViewHeaderFooterView {

    var dataModel : JSMOrderModel?{
        didSet{
            if let model = dataModel {
                
                companyLab.text = "物流公司：" + model.wl_company!
                iconView.kf.setImage(with: URL.init(string: model.wl_list!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                numberLab.text = "物流单号：" + model.wl_number!
                
                
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
        
        contentView.addSubview(iconView)
        contentView.addSubview(companyLab)
        contentView.addSubview(numberLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 100, height: 80))
        }
        companyLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(40)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(companyLab)
            make.top.equalTo(companyLab.snp.bottom)
            make.bottom.equalTo(iconView)
        }
    }
    
    /// 物流单图片
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// 物流公司
    lazy var companyLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 物流单号
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
}
