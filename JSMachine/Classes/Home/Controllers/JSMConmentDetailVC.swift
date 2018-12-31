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
    let typeArr: [String] = ["解决问题高效","态度友好","准时上门服务","穿戴工作服上岗证"]
    var selectTypeNameArr: [String] = [String]()

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
        bgView.addSubview(tagsView)
        bgView.addSubview(lineView)
        bgView.addSubview(contentLab)
        
        let height = HXTagsView.getHeightWithTags(typeArr, layout: tagsView.layout, tagAttribute: tagsView.tagAttribute, width: kScreenWidth)
        
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
        tagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(height)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(tagsView.snp.bottom).offset(kMargin)
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
    lazy var tagsView: HXTagsView = {
        
        let view = HXTagsView()
        view.tagAttribute.borderColor = kBlueFontColor
        view.tagAttribute.cornerRadius = 10
        view.tagAttribute.normalBackgroundColor = kWhiteColor
        view.tagAttribute.selectedBackgroundColor = kBlueFontColor
        view.tagAttribute.textColor = kBlueFontColor
        view.tagAttribute.selectedTextColor = kWhiteColor
        /// 显示多行
        view.layout.scrollDirection = .vertical
        view.isMultiSelect = true
        view.backgroundColor = kWhiteColor
        view.isUserInteractionEnabled = false
        view.tags = typeArr
        
        return view
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
                
                weakSelf?.contentLab.text = data["pj_jy"].stringValue
                weakSelf?.nameLab.text = data["nickname"].stringValue
                weakSelf?.userImgView.kf.setImage(with: URL.init(string: data["head"].stringValue), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
                if data["is_efficient"].stringValue == "1"{
                    weakSelf?.selectTypeNameArr.append((weakSelf?.typeArr[0])!)
                }else{
                    weakSelf?.selectTypeNameArr.append("")
                }
                if data["is_manner"].stringValue == "1"{
                    weakSelf?.selectTypeNameArr.append((weakSelf?.typeArr[1])!)
                }else{
                    weakSelf?.selectTypeNameArr.append("")
                }
                if data["is_time"].stringValue == "1"{
                    weakSelf?.selectTypeNameArr.append((weakSelf?.typeArr[2])!)
                }else{
                    weakSelf?.selectTypeNameArr.append("")
                }
                if data["is_post"].stringValue == "1"{
                    weakSelf?.selectTypeNameArr.append((weakSelf?.typeArr[3])!)
                }else{
                    weakSelf?.selectTypeNameArr.append("")
                }
                weakSelf?.tagsView.selectedTags = [(weakSelf?.selectTypeNameArr[0])!,(weakSelf?.selectTypeNameArr[1])!,(weakSelf?.selectTypeNameArr[2])!,(weakSelf?.selectTypeNameArr[3])!]
                weakSelf?.tagsView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
