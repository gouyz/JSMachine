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
                numberLab.text = "产品数量：\(model.num!)(个)"
                finishedDateLab.text = "交货日期：" + (model.deal_date?.getDateTime(format: "yyyy/MM/dd"))!
                noteLab.text = "用户备注：\(model.remark!)"
                /// 已提交(0已提交未确认有货，只能下载合同。1已确认有货，可以下载合同和上传合同。2已上传合同，还未审核合同是否有效，只能查看合同)。
                /// 未发货(3合同有效未发货，只能查看合同、上传支付凭证)
                /// 已发货(4已发货，待完成，可以查看合同、确认收货、查看支付凭证、查看物流单)
                /// 5完成订单,只能查看合同、查看支付凭证、查看物流单、评价
                /// 6,只能查看合同、查看支付凭证、查看物流单
                /// 7,只能查看合同、查看支付凭证、查看物流单
                let status: String = model.status!
                tuiJianLab.isHidden = false
                tagImgView.isHidden = false
                if status == "0"{
                    downLoadBtn.isHidden = false
                    contractLab.isHidden = true
                    payCertLab.isHidden = true
                    expressListLab.isHidden = true
                    operatorLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
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
                }else if status == "1"{
                    downLoadBtn.isHidden = false
                    contractLab.isHidden = false
                    contractLab.text = "上传合同"
                    payCertLab.isHidden = true
                    expressListLab.isHidden = true
                    operatorLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
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
                }else if status == "2" {
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    contractLab.text = "查看合同"
                    payCertLab.isHidden = true
                    expressListLab.isHidden = true
                    operatorLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
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
                }else if status == "3"{
                    tuiJianLab.isHidden = true
                    tagImgView.isHidden = true
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    contractLab.text = "查看合同"
                    payCertLab.isHidden = true
                    expressListLab.isHidden = true
                    operatorLab.isHidden = false
                    operatorLab.text = "上传支付凭证"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                    }
                    payCertLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    expressListLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else if status == "4"{
                    tuiJianLab.isHidden = true
                    tagImgView.isHidden = true
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    contractLab.text = "查看合同"
                    payCertLab.isHidden = false
                    expressListLab.isHidden = false
                    operatorLab.isHidden = false
                    operatorLab.text = "确认收货"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
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
                }else if status == "5"{
                    tuiJianLab.isHidden = true
                    tagImgView.isHidden = true
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    contractLab.text = "查看合同"
                    payCertLab.isHidden = false
                    expressListLab.isHidden = false
                    operatorLab.isHidden = false
                    operatorLab.text = "评价"
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
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
                }else if status == "6" || status == "7"{
                    tuiJianLab.isHidden = true
                    tagImgView.isHidden = true
                    downLoadBtn.isHidden = true
                    contractLab.isHidden = false
                    contractLab.text = "查看合同"
                    payCertLab.isHidden = false
                    expressListLab.isHidden = false
                    operatorLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
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
        bgView.addSubview(bidImgView)
        bgView.addSubview(biddingLab)
        bgView.addSubview(tagImgView)
        bgView.addSubview(tuiJianLab)
        bgView.addSubview(downLoadBtn)
        bgView.addSubview(contractLab)
        bgView.addSubview(payCertLab)
        bgView.addSubview(expressListLab)
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
        bidImgView.snp.makeConstraints { (make) in
            make.left.equalTo(typeLab)
            make.centerY.equalTo(biddingLab)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        biddingLab.snp.makeConstraints { (make) in
            make.left.equalTo(bidImgView.snp.right).offset(5)
            make.top.equalTo(noteLab.snp.bottom).offset(kMargin)
            make.right.equalTo(kScreenWidth * 0.5)
            make.height.equalTo(30)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(typeLab)
            make.centerY.equalTo(tuiJianLab)
            make.size.equalTo(CGSize.init(width: 3, height: 15))
        }
        tuiJianLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.equalTo(biddingLab.snp.bottom)
            make.width.equalTo(80)
            make.height.equalTo(24)
            make.bottom.equalTo(-kMargin)
        }
        downLoadBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contractLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(contractLab)
            make.width.equalTo(80)
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
            make.width.equalTo(60)
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
    /// 产品数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
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
    /// 查看竞标者
    lazy var biddingLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "查看竞标者"
        
        return lab
    }()
    
    /// 图片
    lazy var bidImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_jingbiao_tag")
        imgView.highlightedImage = UIImage.init(named: "icon_jingbiao_tag_gray")
        
        return imgView
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
        lab.text = "确认收货"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
