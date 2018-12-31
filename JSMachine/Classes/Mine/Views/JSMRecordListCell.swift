//
//  JSMRecordListCell.swift
//  JSMachine
//  维修记录列表list
//  Created by gouyz on 2018/12/30.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMRecordListCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMSaleServiceRecordModel?{
        didSet{
            if let model = dataModel {
                reasonLab.text = "故障原因：" +  model.w_reason!
                remarkLab.text = "备注：" + model.w_remark!
                if model.imgList.count > 0 {
                    imgViews.isHidden = false
                    imgViews.selectImgUrls = model.imgList
                    /// 如果图片张数超出最大限制数，只取最大限制数的图片
                    var imgCount : Int = model.imgList.count
                    if imgCount > kMaxSelectCount {
                        imgCount = kMaxSelectCount
                    }
                    let rowIndex = ceil(CGFloat.init(imgCount) / 4.0)//向上取整
                    imgViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(kPhotosImgHeight * rowIndex + kMargin * (rowIndex - 1))
                    })
                }else{
                    imgViews.isHidden = true
                    imgViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
                dateLab.text = model.w_date?.getDateTime(format: "yyyy.MM.dd")
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.backgroundColor = kBackgroundColor
        contentView.addSubview(bgView)
        bgView.addSubview(reasonLab)
        bgView.addSubview(remarkLab)
        bgView.addSubview(imgViews)
        bgView.addSubview(dateLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        reasonLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.height.greaterThanOrEqualTo(kTitleHeight)
        }
        remarkLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(reasonLab)
            make.top.equalTo(reasonLab.snp.bottom).offset(kMargin)
        }
        
        imgViews.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(remarkLab.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(0)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(remarkLab)
            make.top.equalTo(imgViews.snp.bottom)
            make.height.equalTo(kTitleHeight)
            make.bottom.equalTo(-1)
        }
    }
    ///
    lazy var bgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var reasonLab : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
    ///备注
    lazy var remarkLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        lab.text = "备注："
        
        return lab
    }()
    /// 九宫格图片显示
    lazy var imgViews: GYZPhotoView = GYZPhotoView()
    ///日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        
        return lab
    }()
}
