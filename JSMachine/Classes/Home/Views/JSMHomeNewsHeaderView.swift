//
//  JSMHomeNewsHeaderView.swift
//  JSMachine
//  行业资讯 header
//  Created by gouyz on 2018/11/22.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMHomeNewsHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(refreshBtn)
        contentView.addSubview(nameLab)
        contentView.addSubview(tagImgView)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 3, height: 20))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(refreshBtn.snp.left).offset(-kMargin)
        }
        
        refreshBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(nameLab)
            make.width.equalTo(100)
        }
        
        refreshBtn.set(image: UIImage.init(named: "icon_home_refresh"), title: "换一换", titlePosition: .left, additionalSpacing: kMargin, state: .normal)
    }
    
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "行业资讯"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    
    /// 换一换
    lazy var refreshBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.addTarget(self, action: #selector(clickedOperateBtn), for: .touchUpInside)
        return btn
    }()
    
    /// 换一换
    @objc func clickedOperateBtn(){
        
    }
}
