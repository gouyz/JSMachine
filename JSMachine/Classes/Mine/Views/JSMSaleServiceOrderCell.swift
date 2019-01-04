//
//  JSMSaleServiceOrderCell.swift
//  JSMachine
//  售后服务 cell
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMSaleServiceOrderCell: UITableViewCell {
    
    /// 填充数据 客户
    var dataModel : JSMSaleServiceOrderModel?{
        didSet{
            if let model = dataModel {
                
                reasonLab.text = "故障原因：\(model.f_reason!)"
                dateLab.text = model.a_date
                nameLab.text = "联系人：\(model.a_name!)"
                phoneLab.text = "联系电话：\(model.a_phone!)"
                desLab.text = "备注：\(model.a_remark!)"
                /// 处理中状态为0、1、2客户只有查看和删除操作，已处理状态为3时查看、删除、维修记录、评价，为4和5时查看、删除、维修记录操作
                let status: String = model.status!
                var statusName: String = ""
                var statusBgColor: UIColor = kRedFontColor
                if Int.init(status) < 3{
                    statusName = "处理中"
                    statusBgColor = UIColor.ColorHex("#a4a8b8")
                    var stateName: String = ""
                    if status == "0"{
                        stateName = "未分配"
                    }else{
                        stateName = "已分配"
                    }
                    stateLab.text = stateName
                    operatorLab.isHidden = true
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    recordLab.isHidden = true
                    recordLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else{
                    statusName = "已处理"
                    stateLab.text = ""
                    if model.is_pj == "0"{
                        operatorLab.text = "评价"
                    }else{
                        operatorLab.text = "已评价"
                    }
                    operatorLab.isHidden = false
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                    }
                    recordLab.isHidden = false
                    recordLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }
                
                statusNameLab.backgroundColor = statusBgColor
                statusNameLab.text = statusName
            }
        }
    }
    
    /// 填充数据 工程师
    var dataModelEngineer : JSMSaleServiceOrderModel?{
        didSet{
            if let model = dataModelEngineer {
                
                reasonLab.text = "故障原因：\(model.f_reason!)"
                dateLab.text = model.a_date
                nameLab.text = "联系人：\(model.a_name!)"
                phoneLab.text = "联系电话：\(model.a_phone!)"
                desLab.text = "备注：\(model.a_remark!)"
                /// 状态（(1,已分配状态)(2,上门维修)(3,工程师维修完成)（4，客户评价确认完成））
                /// 状态对应的操作显示：1：查看申请单、处理；2：查看申请单、完成 ；3：查看申请单，删除，查看维修单；4：查看申请单，删除，查看维修单；查看用户评价。
                var stateName: String = ""
                if model.first == "1"{
                    stateName = "优先处理"
                }
                stateLab.text = stateName
                
                let status: String = model.status!
                var statusName: String = ""
                var statusBgColor: UIColor = UIColor.ColorHex("#a4a8b8")
                operatorLab.isHidden = false
                operatorLab.snp.updateConstraints { (make) in
                    make.width.equalTo(60)
                    make.right.equalTo(-kMargin)
                }
                
                if status == "1"{
                    statusName = "新分配"
                    statusBgColor = kRedFontColor
                
                    deleteLab.isHidden = true
                    deleteLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    recordLab.isHidden = true
                    recordLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    operatorLab.text = "处理"
                }else if status == "4"{
                    statusName = "已完成"
                    statusBgColor = kBlueFontColor
                    operatorLab.text = "看评价"
                    deleteLab.isHidden = false
                    deleteLab.snp.updateConstraints { (make) in
                        make.width.equalTo(60)
                    }
                    recordLab.isHidden = false
                    recordLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }else{
                    statusName = "处理中"
                    
                    if status == "3"{
                        operatorLab.isHidden = true
                        operatorLab.snp.updateConstraints { (make) in
                            make.width.equalTo(0)
                            make.right.equalTo(-1)
                        }
                        deleteLab.isHidden = false
                        deleteLab.snp.updateConstraints { (make) in
                            make.width.equalTo(60)
                        }
                        recordLab.isHidden = false
                        recordLab.snp.updateConstraints { (make) in
                            make.width.equalTo(80)
                        }
                    }else{
                        
                        operatorLab.text = "维修记录"
                        deleteLab.isHidden = true
                        deleteLab.snp.updateConstraints { (make) in
                            make.width.equalTo(0)
                        }
                        recordLab.isHidden = true
                        recordLab.snp.updateConstraints { (make) in
                            make.width.equalTo(0)
                        }
                    }
                
                }
                
                statusNameLab.backgroundColor = statusBgColor
                statusNameLab.text = statusName
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
        bgView.addSubview(detailLab)
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
            make.right.equalTo(detailLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(operatorLab)
            make.width.equalTo(80)
        }
        detailLab.snp.makeConstraints { (make) in
            make.right.equalTo(operatorLab.snp.left).offset(-kMargin)
            make.bottom.height.equalTo(operatorLab)
            make.width.equalTo(60)
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
        lab.text = ""
        
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
    /// 查看
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "查看"
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
        lab.text = "评价"
        lab.cornerRadius = kCornerRadius
        lab.borderColor = kRedFontColor
        lab.borderWidth = klineWidth
        
        return lab
    }()
}
