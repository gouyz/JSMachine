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
        adsImgView.addSubview(playImgView)
        playImgView.isHidden = true
        self.addSubview(chatBtn)
        self.addSubview(saleBtn)
        self.addSubview(publishBtn)
        self.addSubview(shopBtn)
        
        self.addSubview(bgView)
        bgView.addSubview(ptjsImgView)
        ptjsImgView.addSubview(saleLab)
        bgView.addSubview(zwcxImgView)
        zwcxImgView.addSubview(publishLab)
        bgView.addSubview(zsjmImgView)
        zsjmImgView.addSubview(chatLab)
        bgView.addSubview(hzhbImgView)
        hzhbImgView.addSubview(smallLab)
        bgView.addSubview(pgtImgView)
        pgtImgView.addSubview(pgtLab)
        
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
        playImgView.snp.makeConstraints { (make) in
            make.center.equalTo(adsImgView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
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
        saleLab.snp.makeConstraints { (make) in
            make.center.height.equalTo(ptjsImgView)
            make.width.equalTo(120)
        }
        zwcxImgView.snp.makeConstraints { (make) in
            make.left.equalTo(ptjsImgView.snp.right).offset(kMargin)
            make.top.height.width.equalTo(ptjsImgView)
            make.right.equalTo(-kMargin)
        }
        publishLab.snp.makeConstraints { (make) in
            make.center.height.equalTo(zwcxImgView)
            make.width.equalTo(saleLab)
        }
        zsjmImgView.snp.makeConstraints { (make) in
            make.left.height.equalTo(ptjsImgView)
            make.width.equalTo(hzhbImgView)
            make.top.equalTo(ptjsImgView.snp.bottom).offset(kMargin)
        }
        chatLab.snp.makeConstraints { (make) in
            make.center.height.equalTo(zsjmImgView)
            make.width.equalTo(saleLab)
        }
        hzhbImgView.snp.makeConstraints { (make) in
            make.left.equalTo(zsjmImgView.snp.right).offset(kMargin)
            make.top.height.width.equalTo(zsjmImgView)
            make.right.equalTo(-kMargin)
        }
        smallLab.snp.makeConstraints { (make) in
            make.center.height.equalTo(hzhbImgView)
            make.width.equalTo(saleLab)
        }
        pgtImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.centerY.equalTo(ptjsImgView.snp.bottom).offset(5)
            make.size.equalTo(CGSize.init(width: 190, height: 190))
        }
        pgtLab.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(pgtImgView)
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
        
        chatBtn.set(image: UIImage.init(named: "icon_home_ptjs"), title: "平台介绍", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        saleBtn.set(image: UIImage.init(named: "icon_home_hzhb"), title: "合作伙伴", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        publishBtn.set(image: UIImage.init(named: "icon_home_news_center"), title: "新闻中心", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        shopBtn.set(image: UIImage.init(named: "icon_home_zwcx"), title: "真伪查询", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
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
    /// 播放图片
    lazy var playImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_video_play"))
    /// 技术在线VS平台介绍
    lazy var chatBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 申请售后VS合作伙伴
    lazy var saleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 需求发布VS新闻中心
    lazy var publishBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 在线商城VS真伪查询
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
    
    /// 售后申请
    lazy var ptjsImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_sale"))
        imgView.tag = 201
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// title
    lazy var saleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.numberOfLines = 2
        lab.textAlignment = .center
        lab.text = "售后申请\nAFTER-SALES"
        lab.tag = 201
        lab.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return lab
    }()
    /// 需求发布
    lazy var zwcxImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_publish"))
        imgView.tag = 202
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// title
    lazy var publishLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.numberOfLines = 2
        lab.textAlignment = .center
        lab.text = "需求发布\nDEMAND"
        lab.tag = 202
        lab.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return lab
    }()
    /// 技术在线
    lazy var zsjmImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_chat"))
        imgView.tag = 203
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// title
    lazy var chatLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.numberOfLines = 2
        lab.textAlignment = .center
        lab.text = "技术在线\nTECHNOLOGY"
        lab.tag = 203
        lab.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return lab
    }()
    /// 辅件商城
    lazy var hzhbImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_small"))
        imgView.tag = 204
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// title
    lazy var smallLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.numberOfLines = 2
        lab.textAlignment = .center
        lab.text = "辅件商城\nMALL"
        lab.tag = 204
        lab.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return lab
    }()
    /// 曝光台
    lazy var pgtImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_home_center"))
        imgView.tag = 205
        imgView.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return imgView
    }()
    /// title
    lazy var pgtLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k15Font
        lab.numberOfLines = 3
        lab.textAlignment = .center
        lab.text = "曝\n光\n台"
        lab.tag = 205
        lab.addOnClickListener(target: self, action: #selector(onClickedFuncModel(sender:)))
        
        return lab
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
