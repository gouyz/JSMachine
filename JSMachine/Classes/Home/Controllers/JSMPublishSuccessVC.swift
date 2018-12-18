//
//  JSMPublishSuccessVC.swift
//  JSMachine
//  需求发布成功
//  Created by gouyz on 2018/11/27.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMPublishSuccessVC: GYZBaseVC {
    
    var isBuy: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = isBuy ? "申购成功" : "发布成功"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(iconView)
        contentView.addSubview(successLab)
        contentView.addSubview(waitLab)
        contentView.addSubview(publishBtn)
        contentView.addSubview(downLoadBtn)
        contentView.addSubview(desLab)
        contentView.addSubview(tipsLab)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 250, height: 200))
        }
        successLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
        }
        waitLab.snp.makeConstraints { (make) in
            make.top.equalTo(successLab.snp.bottom)
            make.left.right.height.equalTo(successLab)
        }
        publishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.centerX).offset(-kMargin)
            make.top.equalTo(waitLab.snp.bottom).offset(20)
            make.size.equalTo(CGSize.init(width: 100, height: kTitleHeight))
        }
        downLoadBtn.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.centerX).offset(kMargin)
            make.top.size.equalTo(publishBtn)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.width.equalTo(70)
            make.height.equalTo(20)
            make.top.equalTo(publishBtn.snp.bottom).offset(30)
        }
        
        tipsLab.snp.makeConstraints { (make) in
            make.top.equalTo(desLab)
            make.left.equalTo(desLab.snp.right)
            make.right.equalTo(-kMargin)
//            make.height.equalTo(kTitleHeight)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
    }
    
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    /// 图片
    lazy var iconView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_publish_tag")
        
        return imgView
    }()
    
    /// 成功
    lazy var successLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "恭喜您！需求发布成功！"
        
        return lab
    }()
    ///
    lazy var waitLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "请耐心等待五分钟后下载合同"
        
        return lab
    }()
    /// 发布需求按钮
    fileprivate lazy var publishBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("发布需求", for: .normal)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedPublishBtn), for: .touchUpInside)
        btn.borderColor = kBtnClickBGColor
        btn.borderWidth = klineWidth
        
        return btn
    }()
    
    /// 下载合同按钮
    fileprivate lazy var downLoadBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "icon_contract_btn_bg"), for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("下载合同", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedDownLoadBtn), for: .touchUpInside)
        
        return btn
    }()
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "温馨提示："
        
        return lab
    }()
    ///
    lazy var tipsLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        lab.text = "(1)下载合同打印并盖章、签字后上传至平台\n(2)我们将会尽快为您发货，请耐心等待"
        
        return lab
    }()
    
    
    /// 发布需求按钮
    @objc func clickedPublishBtn(){
        
        if isBuy {
            goPublishNeedVC()
        }else{
            clickedBackBtn()
        }
    }
    
    //需求发布
    func goPublishNeedVC(){
        let vc = JSMPublishNeedVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 下载合同按钮
    @objc func onClickedDownLoadBtn(){
        
    }
}
