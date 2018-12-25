//
//  JSMOrderCell.swift
//  JSMachine
//  订单cell
//  Created by gouyz on 2018/11/25.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMOrderCell: UITableViewCell {
    
    var dataModel : JSMOrderModel?{
        didSet{
            if let model = dataModel {
                
                shopNameLab.text = model.title
                iconView.kf.setImage(with: URL.init(string: model.img!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                nameLab.text = model.shop_name
                guiGeLab.text = model.pro_model
                if model.price == ""{
                    model.price = "0"
                }
                var totalPrice: String = String(format: "%.2f", Double.init(model.price!)!)
                if Int.init(model.num!) > 0{
                    totalPrice = String(format: "%.2f", Double.init(model.price!)! * Double.init(model.num!)!)
                }
                desLab.text = model.pro_speed ?? "" + "  " + model.drive_ratio!
                totalLab.text = "共计\(model.num!)件商品 合计￥\(model.total!)(包含运费￥0.00)"
                /// 已提交(0已提交未确认有货，只能下载合同。1已确认有货，可以下载合同和上传合同。2已上传合同，还未审核合同是否有效，只能查看合同)。
                /// 未发货(3合同有效未发货，只能查看合同)
                /// 已发货(4已发货，待完成，可以查看合同和确认收货)
                /// 5完成订单,只能查看合同
                let status: String = model.status!
                var statusName: String = ""
                var statusDes: String = ""
                var colorBg: UIColor = UIColor.ColorHex("#a4a8b8")
                
                if status == "0"{
                    statusDes = "未确认"
                    statusName = "已提交"
                    contractLab.isHidden = true
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                    operatorLab.text = "下载合同"
                    operatorLab.isHidden = false
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }else if status == "1"{
                    statusDes = "已确认"
                    statusName = "已提交"
                    contractLab.text = "上传合同"
                    contractLab.isHidden = false
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    operatorLab.text = "下载合同"
                    operatorLab.isHidden = false
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }else if status == "2"{
                    statusDes = "未审核"
                    statusName = "已提交"
                    contractLab.text = "查看合同"
                    contractLab.isHidden = false
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    operatorLab.isHidden = true
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else if status == "3"{
                    statusDes = "未发货"
                    statusName = "未发货"
                    contractLab.text = "查看合同"
                    contractLab.isHidden = false
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    operatorLab.isHidden = true
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }else if status == "4"{
                    statusDes = "已发货"
                    statusName = "已发货"
                    colorBg = kRedFontColor
                    contractLab.text = "查看合同"
                    contractLab.isHidden = false
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    operatorLab.isHidden = false
                    operatorLab.text = "确认收货"
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                }else if status == "5"{
                    statusDes = "已完成"
                    statusName = "已完成"
                    colorBg = kBlueFontColor
                    contractLab.text = "查看合同"
                    contractLab.isHidden = false
                    contractLab.snp.updateConstraints { (make) in
                        make.width.equalTo(80)
                    }
                    operatorLab.isHidden = true
                    operatorLab.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                    }
                }
                
                statusNameLab.text = statusName
                stateLab.text = statusDes
                statusNameLab.backgroundColor = colorBg
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
        bgView.addSubview(shopNameLab)
        bgView.addSubview(stateLab)
        bgView.addSubview(lineView)
        bgView.addSubview(iconView)
        bgView.addSubview(nameLab)
        bgView.addSubview(guiGeLab)
        bgView.addSubview(desLab)
        bgView.addSubview(lineView1)
        bgView.addSubview(totalLab)
        bgView.addSubview(contractLab)
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
        shopNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(statusNameLab.snp.right).offset(kMargin)
            make.right.equalTo(stateLab.snp.left).offset(-kMargin)
            make.top.equalTo(bgView)
            make.height.equalTo(kTitleHeight)
        }
        stateLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(shopNameLab)
            make.width.equalTo(80)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(shopNameLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLab)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 70))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        guiGeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(guiGeLab)
            make.top.equalTo(guiGeLab.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
        }
        totalLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(lineView1.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        
        contractLab.snp.makeConstraints { (make) in
            make.right.equalTo(operatorLab.snp.left).offset(-20)
            make.bottom.height.equalTo(operatorLab)
            make.width.equalTo(80)
        }
        operatorLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(80)
            make.height.equalTo(24)
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
        lab.text = "已发货"
        
        return lab
    }()
    /// 商家名称
    lazy var shopNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "国贸减速机"
        
        return lab
    }()
    ///
    lazy var stateLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "待审核"
        
        return lab
    }()
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 商品图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "齿轮减速机"
        
        return lab
    }()
    /// 规格
    lazy var guiGeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "KRV-40E-121-B"
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "70r/min  0.3v"
        
        return lab
    }()
    /// 分割线
    lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 合计
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "共计2件商品 合计￥3000（包含运费￥0.00）"
        
        return lab
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
