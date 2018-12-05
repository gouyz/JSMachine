//
//  JSMGoodsDetailHeaderView.swift
//  JSMachine
//  商品详情 header
//  Created by gouyz on 2018/12/5.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMGoodsDetailHeaderView: UIView {

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(nameLab)
        bgView.addSubview(sharedBtn)
        
        self.addSubview(productView)
        productView.addSubview(productLab)
        productView.addSubview(rightIconView)
        
        self.addSubview(tabView)
        tabView.addSubview(tuWenDetailLab)
        tabView.addSubview(lineView)
        tabView.addSubview(paramsLab)
        tabView.addSubview(lineView1)
        tabView.addSubview(lineView2)
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(kScreenWidth * 0.6 + kTitleHeight)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(kScreenWidth * 0.6)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(iconView.snp.bottom)
            make.right.equalTo(sharedBtn.snp.left).offset(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        sharedBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(34)
        }
        
        productView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(bgView.snp.bottom).offset(kMargin)
            make.height.equalTo(kTitleHeight)
        }
        productLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(productView)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(productView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(rightArrowSize)
        }
        
        tabView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.top.equalTo(productView.snp.bottom).offset(kMargin)
        }
        tuWenDetailLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(tabView)
            make.bottom.equalTo(lineView2.snp.top)
            make.width.equalTo(paramsLab)
        }
        paramsLab.snp.makeConstraints { (make) in
            make.left.equalTo(tuWenDetailLab.snp.right).offset(kMargin)
            make.top.bottom.width.equalTo(tuWenDetailLab)
            make.right.equalTo(-kMargin)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(tabView)
            make.centerX.equalTo(tuWenDetailLab)
            make.size.equalTo(CGSize.init(width: 60, height: klineDoubleWidth))
        }
        lineView1.snp.makeConstraints { (make) in
            make.bottom.size.equalTo(lineView)
            make.centerX.equalTo(paramsLab)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(tabView)
            make.height.equalTo(klineWidth)
        }
        
    }
    
    /// 广告轮播图
    //    lazy var adsImgView: ZCycleView = {
    //        let adsView = ZCycleView()
    //        //        adsView.placeholderImage = UIImage.init(named: "icon_home_ads_default")
    //        adsView.setImagesGroup([#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner")])
    //        adsView.pageControlAlignment = .center
    //        adsView.pageControlIndictirColor = kWhiteColor
    //        adsView.pageControlCurrentIndictirColor = kBlueFontColor
    //        adsView.scrollDirection = .horizontal
    //
    //        return adsView
    //    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
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
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        lab.text = "齿轮减速机，GFA77-Y1.1KW齿轮减速箱"
        
        return lab
    }()
    
    /// 分享
    lazy var sharedBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_shared_blue"), for: .normal)
        
        return btn
    }()
    
    /// 产品参数
    lazy var productView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    ///
    lazy var productLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品详细参数"
        
        return lab
    }()
    
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 
    lazy var tabView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    lazy var tuWenDetailLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "图文详情"
        lab.textAlignment = .center
        lab.highlightedTextColor = kBlueFontColor
        lab.isHighlighted = true
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        return line
    }()
    lazy var paramsLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品参数"
        lab.textAlignment = .center
        lab.highlightedTextColor = kBlueFontColor
        
        return lab
    }()
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        line.isHidden = true
        return line
    }()
    
    
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
