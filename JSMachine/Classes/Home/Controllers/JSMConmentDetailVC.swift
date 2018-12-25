//
//  JSMConmentDetailVC.swift
//  JSMachine
//  客户评价
//  Created by gouyz on 2018/12/19.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import Cosmos
import MBProgressHUD

class JSMConmentDetailVC: GYZBaseVC {
    
    ///订单ID
    var orderId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "客户评价"
        setUpUI()
        
        requestGetConment()
    }
    
    func setUpUI(){
        
        bgView.backgroundColor = kWhiteColor
        view.addSubview(bgView)
        bgView.addSubview(userImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(desLab)
        bgView.addSubview(ratingView)
        bgView.addSubview(lineView)
        bgView.addSubview(contentLab)
        
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.left.right.equalTo(view)
        }
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.top.height.equalTo(userImgView)
            make.right.equalTo(-kMargin)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(ratingView)
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(50)
            make.width.equalTo(220)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(ratingView.snp.bottom).offset(kMargin)
            make.height.equalTo(klineDoubleWidth)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
    }
    
    /// 背景View
    lazy var bgView: UIView = UIView()
    /// 用户头像
    lazy var userImgView : UIImageView = {
        let img = UIImageView()
        img.cornerRadius = 25
        img.borderColor = kWhiteColor
        img.borderWidth = klineDoubleWidth
        
        return img
    }()
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "服务打分"
        
        return lab
    }()
    ///星星评分
    lazy var ratingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.updateOnTouch = false
        ratingStart.settings.fillMode = .full
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 5
        ratingStart.settings.starSize = 40.0
        ratingStart.settings.minTouchRating = 0
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
    
    /// 评价获取
    func requestGetConment(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("engineer/lookEvaluate", parameters: ["id": orderId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                weakSelf?.ratingView.rating = Double.init(data["pj_score"].stringValue) ?? 0
                weakSelf?.contentLab.text = data["pj_jy"].stringValue
                weakSelf?.nameLab.text = data["nickname"].stringValue
                weakSelf?.userImgView.kf.setImage(with: URL.init(string: data["head"].stringValue), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
