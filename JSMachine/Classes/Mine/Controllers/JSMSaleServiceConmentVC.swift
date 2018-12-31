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
    
    let typeArr: [String] = ["解决问题高效","态度友好","准时上门服务","穿戴工作服上岗证"]
    var selectTypeArr: [String] = ["0","0","0","0"]
    var selectTypeNameArr: [String] = [String]()
    //投诉内容
    var noteContent: String = ""
    ///订单ID
    var orderId: String = ""
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
            tagsView.isUserInteractionEnabled = false
            submitBtn.isHidden = true
            
            requestGetConment()
        }else{
            contentTxtView.text = placeHolder
            contentTxtView.delegate = self
            tagsView.completion = {[weak self] (tags,index) in
                self?.selectTypeArr[index] = "1"
                self?.selectTypeNameArr = tags as! [String]
            }
        }
        
    }
    
    func setUpUI(){
        
        bgView.backgroundColor = kWhiteColor
        view.addSubview(bgView)
        bgView.addSubview(desLab)
        bgView.addSubview(desLab1)
        bgView.addSubview(lineView)
        bgView.addSubview(tagsView)
        bgView.addSubview(contentTxtView)
        view.addSubview(submitBtn)
        
        let height = HXTagsView.getHeightWithTags(typeArr, layout: tagsView.layout, tagAttribute: tagsView.tagAttribute, width: kScreenWidth)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.left.right.equalTo(view)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
            make.right.equalTo(-kMargin)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(desLab1.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        tagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.height.equalTo(height)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(tagsView.snp.bottom).offset(20)
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
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "维修已完成"
        
        return lab
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "请评价一下为您维修的工程师吧"
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
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
        view.tags = typeArr
        
        return view
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
        
        GYZNetWork.requestNetwork("my/evaluate", parameters: ["id": orderId,"pj_jy":noteContent,"is_efficient":selectTypeArr[0],"is_manner":selectTypeArr[1],"is_time":selectTypeArr[2],"is_post":selectTypeArr[3]],  success: { (response) in
            
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
