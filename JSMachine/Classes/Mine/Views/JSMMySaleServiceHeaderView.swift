//
//  JSMMySaleServiceHeaderView.swift
//  JSMachine
//  我的售后 header
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMMySaleServiceHeaderView: UIView {
    
    /// 闭包回调
    public var operatorBlock: ((_ tag: Int) ->())?

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
        
        dealedView.menuImg.badgeView.text = "2"
        dealedView.menuImg.showBadge(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(bgView)
        bgView.addSubview(desLab)
        bgView.addSubview(lineView)
        bgView.addSubview(dealingView)
        bgView.addSubview(dealedView)
        bgView.addSubview(allView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(bgView)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        dealingView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.bottom.equalTo(-20)
            make.width.equalTo(dealedView)
        }
        dealedView.snp.makeConstraints { (make) in
            make.left.equalTo(dealingView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(dealingView)
            make.width.equalTo(allView)
        }
        allView.snp.makeConstraints { (make) in
            make.left.equalTo(dealedView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(dealingView)
            make.right.equalTo(-kMargin)
            make.width.equalTo(dealingView)
        }
    }
    
    /// 背景
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = 10
        return view
    }()
    lazy var desLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "我的申请售后"
        
        return lab
    }()
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    lazy var dealingView: GYZImgAndTxtBtnView = {
        let view = GYZImgAndTxtBtnView()
        view.imgSize = CGSize.init(width: 22, height: 24)
        view.menuImg.image = UIImage.init(named: "icon_service_dealing")
        view.menuTitle.text = "处理中"
        view.tag = 101
        view.addOnClickListener(target: self, action: #selector(clickedOperateBtn(sender:)))
        return view
    }()
    lazy var dealedView: GYZImgAndTxtBtnView = {
        let view = GYZImgAndTxtBtnView()
        view.imgSize = CGSize.init(width: 22, height: 24)
        view.menuImg.image = UIImage.init(named: "icon_service_dealed")
        view.menuTitle.text = "已处理"
        view.tag = 102
        view.addOnClickListener(target: self, action: #selector(clickedOperateBtn(sender:)))
        return view
    }()
    lazy var allView: GYZImgAndTxtBtnView = {
        let view = GYZImgAndTxtBtnView()
        view.imgSize = CGSize.init(width: 22, height: 24)
        view.menuImg.image = UIImage.init(named: "icon_service_all")
        view.menuTitle.text = "所有申请"
        view.tag = 103
        view.addOnClickListener(target: self, action: #selector(clickedOperateBtn(sender:)))
        return view
    }()
    
    ///操作
    @objc func clickedOperateBtn(sender : UITapGestureRecognizer){
        let tag = (sender.view?.tag)! - 100
        
        if operatorBlock != nil {
            operatorBlock!(tag)
        }
    }
}
