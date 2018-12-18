//
//  JSMSaleServiceDetailBottomView.swift
//  JSMachine
//  售后详情 bottom
//  Created by gouyz on 2018/12/18.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMSaleServiceDetailBottomView: UIView {

    /// 闭包回调
    public var operatorBlock: ((_ tag: Int) ->())?
    
    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(phoneView)
        phoneView.addSubview(phoneBtn)
        self.addSubview(lineView)
        self.addSubview(onLineView)
        onLineView.addSubview(onLineBtn)
        
        phoneView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(onLineView)
        }
        phoneBtn.snp.makeConstraints { (make) in
            make.center.equalTo(phoneView)
            make.size.equalTo(CGSize.init(width: 80, height: 34))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(phoneView.snp.right)
            make.centerY.equalTo(phoneView)
            make.size.equalTo(CGSize.init(width: klineDoubleWidth, height: 34))
        }
        onLineView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(phoneView)
            make.left.equalTo(lineView.snp.right)
            make.right.equalTo(self)
            make.width.equalTo(phoneView)
        }
        
        onLineBtn.snp.makeConstraints { (make) in
            make.center.equalTo(onLineView)
            make.size.equalTo(phoneBtn)
        }
        
        phoneBtn.set(image: UIImage.init(named: "icon_link_phone"), title: "电话联系", titlePosition: .right, additionalSpacing: kMargin, state: .normal)
        onLineBtn.set(image: UIImage.init(named: "icon_link_kefu"), title: "在线联系", titlePosition: .right, additionalSpacing: kMargin, state: .normal)
    }
    
    lazy var phoneView: UIView = UIView()
    /// 联系电话
    lazy var phoneBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    lazy var onLineView: UIView = UIView()
    /// 在线联系
    lazy var onLineBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    ///操作
    @objc func clickedOperateBtn(btn : UIButton){
        let tag = btn.tag - 100
        
        if operatorBlock != nil {
            operatorBlock!(tag)
        }
    }
}
