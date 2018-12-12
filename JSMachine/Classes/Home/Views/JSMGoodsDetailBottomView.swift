//
//  JSMGoodsDetailBottomView.swift
//  JSMachine
//  商品详情 底部View
//  Created by gouyz on 2018/12/5.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMGoodsDetailBottomView: UIView {

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
        self.addSubview(shopView)
        shopView.addSubview(ziXunBtn)
        self.addSubview(favouriteView)
        favouriteView.addSubview(favouriteBtn)
        self.addSubview(buyBtn)
        
        shopView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(favouriteView)
        }
        ziXunBtn.snp.makeConstraints { (make) in
            make.center.equalTo(shopView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        favouriteView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(shopView)
            make.left.equalTo(shopView.snp.right)
            make.width.equalTo(buyBtn)
        }
        
        buyBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(shopView)
            make.left.equalTo(favouriteView.snp.right)
            make.right.equalTo(self)
            make.width.equalTo(shopView)
        }
        
        favouriteBtn.snp.makeConstraints { (make) in
            make.center.equalTo(favouriteView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        
        ziXunBtn.set(image: UIImage.init(named: "icon_shop_question"), title: "咨询", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        favouriteBtn.set(image: UIImage.init(named: "icon_shop_favourite"), title: "关注", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        favouriteBtn.set(image: UIImage.init(named: "icon_shop_favourite_selected"), title: "关注", titlePosition: .bottom, additionalSpacing: 5, state: .selected)
    }
    
    lazy var shopView: UIView = UIView()
    /// 咨询
    lazy var ziXunBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k10Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    lazy var favouriteView: UIView = UIView()
    /// 收藏
    lazy var favouriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k10Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 询价
    lazy var buyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kRedFontColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("询价", for: .normal)
        btn.tag = 103
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
