//
//  JSMServiceRecordImgsCell.swift
//  JSMachine
//  维修记录 图片显示cell
//  Created by gouyz on 2018/12/19.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMServiceRecordImgsCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : [String]?{
        didSet{
            if let model = dataModel {
                
                if model.count > 0 {
                    imgViews.isHidden = false
                    imgViews.selectImgUrls = model
                    /// 如果图片张数超出最大限制数，只取最大限制数的图片
                    var imgCount : Int = model.count
                    if imgCount > kMaxSelectCount {
                        imgCount = kMaxSelectCount
                    }
                    let rowIndex = ceil(CGFloat.init(imgCount) / 3.0)//向上取整
                    imgViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(kPhotosImgHeight * rowIndex + kMargin * (rowIndex - 1))
                    })
                }else{
                    imgViews.isHidden = true
                    imgViews.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
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
        contentView.backgroundColor = kWhiteColor
        contentView.addSubview(imgViews)
        
        imgViews.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(5)
            make.right.equalTo(-kMargin)
            make.height.equalTo(0)
        }
    }
    
    /// 九宫格图片显示
    lazy var imgViews: GYZPhotoView = GYZPhotoView()
}
