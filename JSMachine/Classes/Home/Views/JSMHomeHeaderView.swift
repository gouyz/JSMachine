//
//  JSMHomeHeaderView.swift
//  JSMachine
//  home header
//  Created by gouyz on 2018/11/22.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMHomeHeaderView: UIView {

    /// 闭包回调
    public var operatorBlock: ((_ tag: Int) ->())?
    /// 闭包回调
    public var funcModelBlock: ((_ tag: Int) ->())?
    
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
        self.addSubview(adsImgView)
        self.addSubview(chatBtn)
        self.addSubview(saleBtn)
        self.addSubview(publishBtn)
        self.addSubview(shopBtn)
        
        self.addSubview(bgView)
        bgView.addSubview(ptjsImgView)
        bgView.addSubview(zwcxImgView)
        bgView.addSubview(zsjmImgView)
        bgView.addSubview(hzhbImgView)
        
        self.addSubview(hotBgView)
        hotBgView.addSubview(hotTagView)
        hotBgView.addSubview(line)
        hotBgView.addSubview(labaTagView)
        hotBgView.addSubview(hotTxtView)
        
        adsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kStateHeight)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.47)
        }
        chatBtn.snp.makeConstraints { (make) in
            make.left.equalTo(adsImgView)
            make.top.equalTo(adsImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(90)
            make.width.equalTo(saleBtn)
        }
        saleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(chatBtn.snp.right)
            make.top.height.equalTo(chatBtn)
            make.width.equalTo(publishBtn)
        }
        publishBtn.snp.makeConstraints { (make) in
            make.top.height.equalTo(chatBtn)
            make.left.equalTo(saleBtn.snp.right)
            make.width.equalTo(shopBtn)
        }
        shopBtn.snp.makeConstraints { (make) in
            make.top.height.equalTo(chatBtn)
            make.left.equalTo(publishBtn.snp.right)
            make.right.equalTo(adsImgView)
            make.width.equalTo(chatBtn)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(chatBtn.snp.bottom).offset(kMargin)
            make.height.equalTo((kScreenWidth - kMargin * 3) * 0.52 + kMargin * 3 )
        }
        ptjsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.width.equalTo(zwcxImgView)
            make.height.equalTo((kScreenWidth - kMargin * 3) * 0.26)
        }
        zwcxImgView.snp.makeConstraints { (make) in
            make.left.equalTo(ptjsImgView.snp.right).offset(kMargin)
            make.top.height.width.equalTo(ptjsImgView)
            make.right.equalTo(-kMargin)
        }
        zsjmImgView.snp.makeConstraints { (make) in
            make.left.height.equalTo(ptjsImgView)
            make.width.equalTo(hzhbImgView)
            make.top.equalTo(ptjsImgView.snp.bottom).offset(kMargin)
        }
        hzhbImgView.snp.makeConstraints { (make) in
            make.left.equalTo(zsjmImgView.snp.right).offset(kMargin)
            make.top.height.width.equalTo(zsjmImgView)
            make.right.equalTo(-kMargin)
        }
        
        hotBgView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(bgView.snp.bottom)
        }
        hotTagView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(hotBgView)
            make.size.equalTo(CGSize.init(width: 35, height: 15))
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(hotTagView.snp.right).offset(5)
            make.centerY.height.equalTo(hotTagView)
            make.width.equalTo(klineDoubleWidth)
        }
        labaTagView.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.right).offset(5)
            make.centerY.height.equalTo(hotTagView)
            make.width.equalTo(17)
        }
        hotTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(labaTagView.snp.right).offset(5)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.right.equalTo(-kMargin)
        }
        
        chatBtn.set(image: UIImage.init(named: "icon_home_chat"), title: "技术在线", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        saleBtn.set(image: UIImage.init(named: "icon_home_sale"), title: "快修申请", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        publishBtn.set(image: UIImage.init(named: "icon_home_publish"), title: "快购发布", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        shopBtn.set(image: UIImage.init(named: "icon_home_shop"), title: "在线商城", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
    }
    
    /// 广告轮播图
    lazy var adsImgView: ZCycleView = {
        let adsView = ZCycleView()
        adsView.placeholderImage = UIImage.init(named: "icon_home_banner")
//        adsView.setImagesGroup([#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner")])
        adsView.pageControlAlignment = .center
        adsView.pageControlIndictirColor = kWhiteColor
        adsView.pageControlCurrentIndictirColor = kBlueFontColor
        adsView.scrollDirection = .horizontal
        
        return adsView
    }()
    /// 技术在线
    lazy var chatBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 申请售后
    lazy var saleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 需求发布
    lazy var publishBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 在线商城
    lazy var shopBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 104
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    
    /// 平台介绍
    lazy var ptjsImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_ptjs"))
        imgView.tag = 201
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// 真伪查询
    lazy var zwcxImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_zwcx"))
        imgView.tag = 202
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// 招商加盟
    lazy var zsjmImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_zsjm"))
        imgView.tag = 203
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// 合作伙伴
    lazy var hzhbImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_hzhb"))
        imgView.tag = 204
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    
    lazy var hotBgView: UIView = UIView()
    /// 热点 图片
    lazy var hotTagView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_hot"))
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = kBlackColor
        
        return view
    }()
    /// 喇叭 图片
    lazy var labaTagView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_laba"))
    /// 热点轮播
    lazy var hotTxtView: JXMarqueeView = {
        let hotView = JXMarqueeView()
        hotView.backgroundColor = kWhiteColor
        hotView.marqueeType = .left
        
        return hotView
    }()

//    lazy var hotTxtView: ZCycleView = {
//        let adsView = ZCycleView()
//        adsView.scrollDirection = .horizontal
//        adsView.titleBackgroundColor = kWhiteColor
//        adsView.titleColor = kBlackFontColor
//        adsView.titleFont = k15Font
//        adsView.setTitlesGroup(["热烈欢迎泰隆减速机有限公司入驻本平台","热烈欢迎AAAA减速机有限公司入驻本平台","热烈欢迎XX减速机有限公司入驻本平台"])
//
//        return adsView
//    }()
    
    ///操作
    @objc func clickedOperateBtn(btn : UIButton){
        let tag = btn.tag - 100
        
        if operatorBlock != nil {
            operatorBlock!(tag)
        }
    }
    
    ///平台介绍等操作
    @objc func onClickedFuncModel(sender: UITapGestureRecognizer){
        let tag = (sender.view?.tag)! - 200
        
        if funcModelBlock != nil {
            funcModelBlock!(tag)
        }
    }
}
