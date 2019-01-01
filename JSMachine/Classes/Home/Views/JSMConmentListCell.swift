//
//  JSMConmentListCell.swift
//  JSMachine
//
//  Created by gouyz on 2019/1/1.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMConmentListCell: UITableViewCell {

    let typeArr: [String] = ["解决问题高效","穿戴工作服","态度友好","准时上门"]
    /// 填充数据
    var dataModel : JSMConmentDetailModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.a_name
                contentLab.text = model.pj_jy
                userImgView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                timeLab.text = model.w_date?.getDateTime(format: "yyyy.MM.dd")
                
                var selectTags: [String] = [String]()
                if model.is_efficient == "1"{
                    selectTags.append("解决问题高效")
                }else{
                    selectTags.append("")
                }
                if model.is_post == "1"{
                    selectTags.append("穿戴工作服")
                }else{
                    selectTags.append("")
                }
                if model.is_manner == "1"{
                    selectTags.append("态度友好")
                }else{
                    selectTags.append("")
                }
                if model.is_time == "1"{
                    selectTags.append("准时上门")
                }else{
                    selectTags.append("")
                }
                tagsView.selectedTags = [selectTags[0],selectTags[1],selectTags[2],selectTags[3]]
                tagsView.reloadData()
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
        bgView.backgroundColor = kWhiteColor
        bgView.addSubview(userImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(timeLab)
        bgView.addSubview(tagsView)
        bgView.addSubview(contentLab)
        
        let height = HXTagsView.getHeightWithTags(typeArr, layout: tagsView.layout, tagAttribute: tagsView.tagAttribute, width: kScreenWidth)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.right.equalTo(timeLab.snp.left).offset(-kMargin)
            make.top.height.equalTo(userImgView)
        }
        timeLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(userImgView)
            make.width.equalTo(100)
        }
        tagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(userImgView.snp.bottom).offset(5)
            make.height.equalTo(height)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(tagsView.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    
    /// 背景View
    lazy var bgView: UIView = UIView()
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
    
    ///
    lazy var tagsView: HXTagsView = {
        
        let view = HXTagsView()
        view.tagAttribute.borderColor = kWhiteColor
        view.tagAttribute.cornerRadius = 5
        view.tagAttribute.normalBackgroundColor = kGrayLineColor
        view.tagAttribute.selectedBackgroundColor = kBlueFontColor
        view.tagAttribute.textColor = kWhiteColor
        view.tagAttribute.titleSize = 12
        view.tagAttribute.tagSpace = 10
        view.tagAttribute.selectedTextColor = kWhiteColor
        /// 显示多行
        view.layout.scrollDirection = .vertical
        view.layout.itemSize = CGSize.init(width: 100, height: 20)
        view.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        view.isMultiSelect = true
        view.backgroundColor = kWhiteColor
        view.isUserInteractionEnabled = false
        view.tags = typeArr
        
        return view
    }()
    
    /// 时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k12Font
        lab.textAlignment = .right
        
        return lab
    }()
    
    ///
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        
        return lab
    }()
}
