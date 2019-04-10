//
//  JSMWinBiddingCell.swift
//  JSMachine
//  已中标cell
//  Created by gouyz on 2019/4/10.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMWinBiddingCell: UITableViewCell {
    /// 填充数据
    var dataModel : JSMJingBiaoModel?{
        didSet{
            if let model = dataModel {
                
                useNameLab.text = model.nickname
                iconView.kf.setImage(with: URL.init(string: model.head!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                dateLab.text = model.create_date?.getDateTime(format: "yyyy/MM/dd")
                
                typeLab.text = "产品型号：\(model.pro_model!)"
                numberLab.text = "产品数量：\(model.num!)"
                finishedDateLab.text = "交货日期：" + (model.deal_date?.getDateTime(format: "yyyy-MM-dd"))!
                noteLab.text = "用户备注：\(model.remark!)"
                priceLab.text = "竞标价：￥\(model.price!)"
                sendDateLab.text = "预发货日期：" + (model.time?.getDateTime(format: "yyyy-MM-dd"))!
                /// status=1:等待上传合同,没有操作功能；status=2:查看合同功能，确认合同有效功能
                /// status=3:等待上传打款凭证,只有查看合同功能；status=6:查看合同功能，查看打款凭证功能，发货功能；
                /// status=4:等待用户收货,只有查看合同和查看打款凭证、查看物流单功能；status=5:用户已确认收货，但是未评价，只有查看合同和查看打款凭证、查看物流单功能；status=7：用户已评价，查看合同和查看打款凭证和查看评价、查看物流单功能
                let status: String = model.status!
                if status == "2"{
                    contractLab.isHidden = false
                    payCertLab.isHidden = true
                    expressListLab.isHidden = false
                    operatorLab.isHidden = true
                    expressListLab.text = "合同有效"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                        make.height.equalTo(24)
                    }
                    payCertLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    expressListLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                    }
                }else if status == "3" {
                    contractLab.isHidden = false
                    payCertLab.isHidden = true
                    expressListLab.isHidden = true
                    operatorLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                        make.height.equalTo(24)
                    }
                    payCertLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    expressListLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else if status == "4" || status == "5" || status == "6"{
                    contractLab.isHidden = false
                    payCertLab.isHidden = false
                    expressListLab.isHidden = false
                    operatorLab.isHidden = true
                    if status == "6"{
                        expressListLab.text = "发货"
                    }else{
                        expressListLab.text = "查看物流单"
                    }
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                        make.height.equalTo(24)
                    }
                    payCertLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    expressListLab.snp.updateConstraints { (make) in
                        make.width.equalTo(70)
                    }
                }else if status == "7"{
                    contractLab.isHidden = false
                    payCertLab.isHidden = false
                    expressListLab.isHidden = false
                    operatorLab.isHidden = false
                    expressListLab.text = "查看物流单"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                        make.height.equalTo(24)
                    }
                    payCertLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                    }
                    expressListLab.snp.updateConstraints { (make) in
                        make.width.equalTo(70)
                    }
                }else{
                    contractLab.isHidden = true
                    payCertLab.isHidden = true
                    expressListLab.isHidden = true
                    operatorLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                        make.height.equalTo(0)
                    }
                    payCertLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    expressListLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
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
        bgView.addSubview(numberLab)
        bgView.addSubview(finishedDateLab)
        bgView.addSubview(noteLab)
        bgView.addSubview(tagView)
        bgView.addSubview(tagLab)
        bgView.addSubview(priceLab)
        bgView.addSubview(sendDateLab)
        bgView.addSubview(payCertLab)
        bgView.addSubview(expressListLab)
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
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(typeLab.snp.bottom)
        }
        finishedDateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(numberLab.snp.bottom)
        }
        noteLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(typeLab)
            make.top.equalTo(finishedDateLab.snp.bottom).offset(kMargin)
        }
        tagView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(tagLab)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        tagLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagView.snp.right).offset(kMargin)
            make.top.equalTo(noteLab.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        priceLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(tagLab.snp.bottom)
        }
        sendDateLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(priceLab.snp.bottom)
        }
        operatorLab.snp.makeConstraints { (make) in
            make.right.equalTo(expressListLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(contractLab)
            make.width.equalTo(60)
        }
        expressListLab.snp.makeConstraints { (make) in
            make.right.equalTo(payCertLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(contractLab)
            make.width.equalTo(70)
        }
        payCertLab.snp.makeConstraints { (make) in
            make.right.equalTo(contractLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(contractLab)
            make.width.equalTo(80)
        }
        contractLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.top.equalTo(sendDateLab.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(24)
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
    /// 用户备注
    lazy var noteLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.text = "用户备注：0.3kv"
        
        return lab
    }()
    /// 图标
    lazy var tagView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_jingbiao_tag")
        
        return imgView
    }()
    
    /// 名称
    lazy var tagLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "竞标信息"
        
        return lab
    }()
    /// 竞标价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "竞标价：￥500"
        
        return lab
    }()
    /// 发货日期
    lazy var sendDateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "发货日期：2018-12-28"
        
        return lab
    }()
    /// 查看合同
    lazy var contractLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "查看合同"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
    /// 查看支付凭证
    lazy var payCertLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "查看支付凭证"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
    /// 查看物流单
    lazy var expressListLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "查看物流单"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
    /// 操作
    lazy var operatorLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "查看评价"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
