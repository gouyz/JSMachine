//
//  JSMSaleServiceConmentVC.swift
//  JSMachine
//  售后申请评价
//  Created by gouyz on 2018/12/19.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import Cosmos
import MBProgressHUD

class JSMSaleServiceConmentVC: GYZBaseVC {

    ///txtView 提示文字
    let placeHolder = "您对我们的商品有什么意见或者建议，商品的有点或者美中不足的地方都可以说说"
    
    //投诉内容
    var noteContent: String = ""
    ///订单ID
    var orderId: String = ""
    /// 评论星级
    var starNum: Double = 5
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    /// 是否评价过
    var isConment: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "服务评价"
        setUpUI()
        
        if isConment {
            contentTxtView.isEditable = false
            ratingView.settings.updateOnTouch = false
            submitBtn.isHidden = true
            
            requestGetConment()
        }else{
            contentTxtView.text = placeHolder
            contentTxtView.delegate = self
            
            ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos
        }
        
    }
    
    func setUpUI(){
        
        bgView.backgroundColor = kWhiteColor
        view.addSubview(bgView)
        bgView.addSubview(desLab)
        bgView.addSubview(ratingView)
        bgView.addSubview(lineView)
        bgView.addSubview(contentTxtView)
        view.addSubview(submitBtn)
        
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.left.right.equalTo(view)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(ratingView)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right)
            make.top.equalTo(kMargin)
            make.height.equalTo(50)
            make.width.equalTo(220)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(ratingView.snp.bottom).offset(kMargin)
            make.height.equalTo(klineDoubleWidth)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(120)
            make.bottom.equalTo(-kMargin)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(bgView.snp.bottom).offset(kTitleHeight)
            make.height.equalTo(kBottomTabbarHeight)
        }
    }
    
    /// 背景View
    lazy var bgView: UIView = UIView()
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
        //        ratingStart.settings.updateOnTouch = false
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
    
    /// 投诉内容
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kGaryFontColor
        
        return txtView
    }()
    
    /// 提交
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提  交", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 评论星级
    func didFinishTouchingCosmos(_ rating: Double) {
        starNum = rating
    }
    /// 提交
    @objc func clickedSubmitBtn(){
        //除去前后空格,防止只输入空格的情况
//        let content = noteContent.trimmingCharacters(in: .whitespaces)
//        if content.isEmpty {
//            MBProgressHUD.showAutoDismissHUD(message: "请输入评论内容")
//            return
//        }
        
        requestConment()
    }
    
    /// 评价提交
    func requestConment(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/evaluate", parameters: ["id": orderId,"pj_score":starNum,"pj_jy":noteContent],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 评价获取
    func requestGetConment(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/clickEvaluate", parameters: ["id": orderId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["data"]
                weakSelf?.ratingView.rating = Double.init(data["pj_score"].stringValue) ?? 0
                weakSelf?.contentTxtView.text = data["pj_jy"].stringValue
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension JSMSaleServiceConmentVC : UITextViewDelegate{
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kBlackFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kGaryFontColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        let text : String = textView.text
        
        noteContent = text
    }
}
