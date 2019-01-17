//
//  JSMMyPublishNeedCell.swift
//  JSMachine
//  我的发布 cell
//  Created by gouyz on 2018/11/28.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMMyPublishNeedCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMPublishNeedModel?{
        didSet{
            if let model = dataModel {
                
                useNameLab.text = model.needs
                iconView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                dateLab.text = model.create_date?.getDateTime(format: "yyyy/MM/dd")
                
                typeLab.text = "产品型号：\(model.pro_model!)"
//                roteLab.text = "传动比：\(model.drive_ratio!)"
                numberLab.text = "产品数量：\(model.num!)(个)"
                finishedDateLab.text = "交货日期：" + (model.deal_date?.getDateTime(format: "yyyy/MM/dd"))!
                noteLab.text = "用户备注：\(model.remark!)"
                /// 已提交(0已提交未确认有货，只能下载合同。1已确认有货，可以下载合同和上传合同。2已上传合同，还未审核合同是否有效，只能查看合同)。
                /// 未发货(3合同有效未发货，只能查看合同)
                /// 已发货(4已发货，待完成，可以查看合同和确认收货)
                /// 5完成订单,只能查看合同
                let status: String = model.status!
                tuiJianLab.isHidden = false
                tagImgView.isHidden = false
                operatorLab.isHidden = true
                if status == "0"{
                    downLoadBtn.isHidden = false
                    contractLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else if status == "1"{
                    downLoadBtn.isHidden = false
                    contractLab.isHidden = false
                    contractLab.text = "上传合同"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }else if status == "2" {
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    contractLab.text = "查看合同"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }else if status == "3" || status == "5"{
                    tuiJianLab.isHidden = true
                    tagImgView.isHidden = true
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    contractLab.text = "查看合同"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }else if status == "4"{
                    tuiJianLab.isHidden = true
                    tagImgView.isHidden = true
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    operatorLab.isHidden = false
                    contractLab.text = "查看合同"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }
                
                if status == "4" || status == "5"{
                    companyLab.text = "物流公司：" + model.wl_company!
                    expressNoLab.text = "物流单号：" + model.wl_number!
                    
                    companyLab.isHidden = false
                    companyLab.snp.updateConstraints { (make) in
                        make.height.equalTo(30)
                    }
                    expressNoLab.isHidden = false
                    expressNoLab.snp.updateConstraints { (make) in
                        make.height.equalTo(30)
                    }
                }else{
                    companyLab.isHidden = true
                    companyLab.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                    expressNoLab.isHidden = true
                    expressNoLab.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                }
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
        bgView.addSubview(typeLab)
//        bgView.addSubview(roteLab)
        bgView.addSubview(numberLab)
        bgView.addSubview(finishedDateLab)
        bgView.addSubview(companyLab)
        bgView.addSubview(expressNoLab)
        bgView.addSubview(noteLab)
        bgView.addSubview(tagImgView)
        bgView.addSubview(tuiJianLab)
        bgView.addSubview(downLoadBtn)
        bgView.addSubview(contractLab)
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
            make.right.equalTo(dateLab.snp.left).offset(-kMargin)
            make.top.equalTo(iconView)
            make.height.equalTo(kTitleHeight)
        }
        dateLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(useNameLab)
            make.width.equalTo(80)
        }
        typeLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
        }
//        roteLab.snp.makeConstraints { (make) in
//            make.left.right.height.equalTo(typeLab)
//            make.top.equalTo(typeLab.snp.bottom)
//        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(typeLab.snp.bottom)
        }
        finishedDateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(numberLab.snp.bottom)
        }
        companyLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(typeLab)
            make.top.equalTo(finishedDateLab.snp.bottom)
            make.height.equalTo(30)
        }
        expressNoLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(typeLab)
            make.top.equalTo(companyLab.snp.bottom)
            make.height.equalTo(30)
        }
        noteLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(typeLab)
            make.top.equalTo(expressNoLab.snp.bottom).offset(kMargin)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(typeLab)
            make.centerY.equalTo(tuiJianLab)
            make.size.equalTo(CGSize.init(width: 3, height: 15))
        }
        tuiJianLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.equalTo(noteLab.snp.bottom).offset(kMargin)
            make.width.equalTo(80)
            make.height.equalTo(24)
            make.bottom.equalTo(-kMargin)
        }
        downLoadBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contractLab.snp.left).offset(-20)
            make.bottom.height.equalTo(contractLab)
            make.width.equalTo(80)
        }
        operatorLab.snp.makeConstraints { (make) in
            make.right.equalTo(contractLab.snp.left).offset(-20)
            make.bottom.height.equalTo(contractLab)
            make.width.equalTo(80)
        }
        contractLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(80)
            make.height.equalTo(24)
        }
        
        downLoadBtn.set(image: UIImage.init(named: "icon_download"), title: "合同", titlePosition: .right, additionalSpacing: 5, state: .normal)
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
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "2018/11/28"
        
        return lab
    }()
    /// 产品型号
    lazy var typeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品型号：KRV-40E-121-B"
        
        return lab
    }()
    /// 传动比
//    lazy var roteLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k15Font
//        lab.textColor = kHeightGaryFontColor
//        lab.text = "传动比：2.2"
//
//        return lab
//    }()
    /// 产品数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品数量：2（个）"
        
        return lab
    }()
    /// 交货日期
    lazy var finishedDateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "交货日期：2018-12-28"
        
        return lab
    }()
    /// 快递公司
    lazy var companyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()
    /// 快递单号
    lazy var expressNoLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()
    /// 用户备注
    lazy var noteLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.text = "用户备注：0.3kv"
        
        return lab
    }()
    
    /// 推荐品牌
    lazy var tuiJianLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "推荐商品"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    
    /// 下载合同
    lazy var downLoadBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        
        return btn
    }()
    
    /// 查看合同
    lazy var contractLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "查看合同"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
    /// 操作
    lazy var operatorLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "确认收货"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
