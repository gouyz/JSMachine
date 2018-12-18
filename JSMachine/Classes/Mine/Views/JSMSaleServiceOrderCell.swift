//
//  JSMSaleServiceOrderCell.swift
//  JSMachine
//  售后服务 cell
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMSaleServiceOrderCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : JSMSaleServiceOrderModel?{
        didSet{
            if let model = dataModel {
                
                reasonLab.text = "故障原因：\(model.f_reason!)"
                dateLab.text = model.a_date
                nameLab.text = "联系人：\(model.a_name!)"
                phoneLab.text = "联系电话：\(model.a_phone!)"
                desLab.text = "备注：\(model.a_remark!)"
                /// 已提交(0已提交未确认有货，只能下载合同。1已确认有货，可以下载合同和上传合同。2已上传合同，还未审核合同是否有效，只能查看合同)。
                /// 未发货(3合同有效未发货，只能查看合同)
                /// 已发货(4已发货，待完成，可以查看合同和确认收货)
                /// 5完成订单,只能查看合同
//                let status: String = model.status!
//                tuiJianLab.isHidden = false
//                tagImgView.isHidden = false
//                operatorLab.isHidden = true
//                if status == "0"{
//                    downLoadBtn.isHidden = false
//                    contractLab.isHidden = true
//                    contractLab.snp.updateConstraints { (make) in
//                        make.width.equalTo(0)
//                    }
//                }else if status == "1"{
//                    downLoadBtn.isHidden = false
//                    contractLab.isHidden = false
//                    contractLab.text = "上传合同"
//                    contractLab.snp.updateConstraints { (make) in
//                        make.width.equalTo(80)
//                    }
//                }else if status == "2" {
//                    downLoadBtn.isHidden = true
//                    contractLab.isHidden = false
//                    contractLab.text = "查看合同"
//                    contractLab.snp.updateConstraints { (make) in
//                        make.width.equalTo(80)
//                    }
//                }else if status == "3" || status == "5"{
//                    tuiJianLab.isHidden = true
//                    tagImgView.isHidden = true
//                    downLoadBtn.isHidden = true
//                    contractLab.isHidden = false
//                    contractLab.text = "查看合同"
//                    contractLab.snp.updateConstraints { (make) in
//                        make.width.equalTo(80)
//                    }
//                }else if status == "4"{
//                    tuiJianLab.isHidden = true
//                    tagImgView.isHidden = true
//                    downLoadBtn.isHidden = true
//                    contractLab.isHidden = false
//                    operatorLab.isHidden = false
//                    contractLab.text = "查看合同"
//                    contractLab.snp.updateConstraints { (make) in
//                        make.width.equalTo(80)
//                    }
//                }
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
        bgView.addSubview(statusNameLab)
        bgView.addSubview(reasonLab)
        bgView.addSubview(stateLab)
        bgView.addSubview(lineView)
        bgView.addSubview(dateLab)
        bgView.addSubview(nameLab)
        bgView.addSubview(phoneLab)
        bgView.addSubview(desLab)
        bgView.addSubview(deleteLab)
        bgView.addSubview(recordLab)
        bgView.addSubview(operatorLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(contentView)
        }
        statusNameLab.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(bgView)
            make.width.equalTo(30)
        }
        reasonLab.snp.makeConstraints { (make) in
            make.left.equalTo(statusNameLab.snp.right).offset(kMargin)
            make.right.equalTo(stateLab.snp.left).offset(-kMargin)
            make.top.equalTo(bgView).offset(kMargin)
//            make.height.equalTo(30)
        }
        stateLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(reasonLab)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        dateLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(reasonLab)
            make.top.equalTo(reasonLab.snp.bottom)
            make.height.equalTo(30)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(dateLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(dateLab.snp.bottom).offset(kMargin)
            make.height.equalTo(klineWidth)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(reasonLab)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.right.equalTo(phoneLab.snp.left).offset(kMargin)
            make.height.equalTo(reasonLab)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.right.equalTo(lineView)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(180)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.bottom.equalTo(operatorLab.snp.top).offset(-kMargin)
        }
        deleteLab.snp.makeConstraints { (make) in
            make.right.equalTo(recordLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(operatorLab)
            make.width.equalTo(60)
        }
        recordLab.snp.makeConstraints { (make) in
            make.right.equalTo(operatorLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(operatorLab)
            make.width.equalTo(80)
        }
        operatorLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = 15
        
        return view
    }()
    /// 状态
    lazy var statusNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.backgroundColor = kRedFontColor
        lab.numberOfLines = 0
        lab.text = "处理中"
        
        return lab
    }()
    /// 故障原因
    lazy var reasonLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "故障原因：减速机传动失效"
        
        return lab
    }()
    ///
    lazy var stateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "已分配..."
        
        return lab
    }()
    /// 时间
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "2018/12/02 12:33"
        
        return lab
    }()
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    /// 联系人
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "联系人：陈赫"
        
        return lab
    }()
    /// 联系电话
    lazy var phoneLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "联系电话：13812345678"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "备注：减速机传动失效"
        
        return lab
    }()
    
    
    /// 删除
    lazy var deleteLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "删除"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kHeightGaryFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
    /// 维修记录
    lazy var recordLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "维修记录"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kHeightGaryFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
    /// 操作
    lazy var operatorLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .center
        lab.text = "完成"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
