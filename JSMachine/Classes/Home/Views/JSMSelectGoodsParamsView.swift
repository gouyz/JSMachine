//
//  JSMSelectGoodsParamsView.swift
//  JSMachine
//  商品参数选择
//  Created by gouyz on 2018/12/13.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMSelectGoodsParamsView: UIView {
    
    ///txtView 提示文字
    let placeHolder = "请输入备注"
    // 备注
    var content: String = ""
    // 选择型号
    var selectedType: String = ""
    var selectedTypeIndex: Int = -1
    // 选择传动比
    var selectedRote: String = ""
    var number: Int = 1
    /// 选择时间戳
    var selectTime: Int = 0
    
    /// 选择结果回调
    var resultBlock:((_ paramDic: [String: Any]) -> Void)?
    
    /// 填充数据
    var dataModel : JSMGoodsParamsModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.goodsModel?.shop_name
                
                tagImgView.kf.setImage(with: URL.init(string: model.goodsModel?.img ?? ""), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                speedLab.text = "产品转速:  \((model.goodsModel?.pro_speed)!)"
                
                for item in model.typeList{
                    typeArr.append(item.p_model!)
                }
                if typeArr.count > 0{
                    selectedTypeIndex = 0
                    selectedType = typeArr[selectedTypeIndex]
                    let typeHeight = HXTagsView.getHeightWithTags(typeArr, layout: typeTagsView.layout, tagAttribute: typeTagsView.tagAttribute, width: kScreenWidth)
                    
                    typeTagsView.snp.updateConstraints { (make) in
                        make.height.equalTo(typeHeight)
                    }
                    typeTagsView.tags = typeArr
                    typeTagsView.selectedTags = [selectedType]
                    typeTagsView.reloadData()
                    
                    setRoteTags()
                }

            }
        }
    }
    
    func setRoteTags(){
        let roteArr = dataModel!.typeList[selectedTypeIndex].ratioList
        let roteHeight = HXTagsView.getHeightWithTags(roteArr, layout: roteTagsView.layout, tagAttribute: roteTagsView.tagAttribute, width: kScreenWidth)
        roteTagsView.snp.updateConstraints { (make) in
            make.height.equalTo(roteHeight)
        }
        roteTagsView.tags = roteArr
        roteTagsView.reloadData()
    }
    
    var typeArr: [String] = [String]()

    // MARK: 生命周期方法
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    convenience init(){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.alpha = 0
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        backgroundView.addOnClickListener(target: self, action: #selector(onTapCancle(sender:)))
        
        setupUI()
        
        typeTagsView.completion = {[weak self] (tags,index) in
            self?.selectedTypeIndex = index
            self?.selectedType = tags![0] as! String
            self?.setRoteTags()
        }
        roteTagsView.completion = {[weak self] (tags,index) in
            self?.selectedRote = tags![0] as! String
        }
        dateInputView.textFiled.isEnabled = false
        dateInputView.addOnClickListener(target: self, action: #selector(onClickedSelectedDate))
        minusView.addOnClickListener(target: self, action: #selector(onClickedMinus))
        addView.addOnClickListener(target: self, action: #selector(onClickedAdd))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(bgView)
//        bgView.addOnClickListener(target: self, action: #selector(onBlankClicked))
        
        bgView.addSubview(tagImgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(typeLab)
        contentView.addSubview(typeTagsView)
        contentView.addSubview(speedLab)
        contentView.addSubview(roteLab)
        contentView.addSubview(roteTagsView)
        contentView.addSubview(dateInputView)
        contentView.addSubview(rightIconView)
        contentView.addSubview(buyDesLab)
        contentView.addSubview(minusView)
        contentView.addSubview(buyNumLab)
        contentView.addSubview(addView)
        contentView.addSubview(noteDesLab)
        contentView.addSubview(noteTxtView)
        bgView.addSubview(okBtn)
        
        bgView.frame = CGRect.init(x: 0, y: frame.size.height, width: kScreenWidth, height: kScreenHeight * 0.8)
        tagImgView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(tagImgView)
            make.right.equalTo(-kMargin)
        }
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(tagImgView.snp.bottom).offset(kMargin)
            make.bottom.equalTo(okBtn.snp.top)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        typeLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(contentView)
            make.height.equalTo(30)
        }
        typeTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(typeLab.snp.bottom)
            make.height.equalTo(0)
        }
        speedLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(typeLab)
            make.height.equalTo(kTitleHeight)
            make.top.equalTo(typeTagsView.snp.bottom)
        }
        roteLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(speedLab.snp.bottom)
        }
        roteTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(typeTagsView)
            make.top.equalTo(roteLab.snp.bottom)
            make.height.equalTo(0)
        }
        dateInputView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.height.equalTo(speedLab)
            make.right.equalTo(rightIconView.snp.left)
            make.top.equalTo(roteTagsView.snp.bottom)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(dateInputView)
            make.size.equalTo(rightArrowSize)
        }
        buyDesLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(speedLab)
            make.right.equalTo(minusView.snp.left).offset(-kMargin)
            make.top.equalTo(dateInputView.snp.bottom)
        }
        minusView.snp.makeConstraints { (make) in
            make.centerY.equalTo(buyDesLab)
            make.right.equalTo(buyNumLab.snp.left).offset(-5)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        buyNumLab.snp.makeConstraints { (make) in
            make.right.equalTo(addView.snp.left).offset(-5)
            make.centerY.equalTo(minusView)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        addView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.size.equalTo(minusView)
        }
        noteDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(buyDesLab.snp.bottom)
        }
        noteTxtView.snp.makeConstraints { (make) in
            make.left.right.equalTo(noteDesLab)
            make.top.equalTo(noteDesLab.snp.bottom)
            make.height.equalTo(80)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(kUIButtonHeight)
        }
    }
    
    ///整体背景
    var backgroundView: UIView = UIView()
    /// 背景
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius  = kCornerRadius
        
        return view
    }()
    
    /// scrollView
    lazy var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    
    ///tag图片
    lazy var tagImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        lab.text = "拓石贸易"
        
        return lab
    }()
    ///产品型号
    lazy var typeLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品型号:"
        
        return lab
    }()
    
    /// 产品型号
    lazy var typeTagsView: HXTagsView = {
        
        let view = HXTagsView()
        view.tagAttribute.borderColor = kBlueFontColor
        view.tagAttribute.normalBackgroundColor = kWhiteColor
        view.tagAttribute.selectedBackgroundColor = kBlueFontColor
        view.tagAttribute.textColor = kBlueFontColor
        view.tagAttribute.selectedTextColor = kWhiteColor
        /// 显示多行
        view.layout.scrollDirection = .vertical
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    ///产品转速
    lazy var speedLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "产品转速:"
        
        return lab
    }()
    ///传动比
    lazy var roteLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "传动比:"
        
        return lab
    }()
    
    /// 传动比
    lazy var roteTagsView: HXTagsView = {
        
        let view = HXTagsView()
        view.tagAttribute.borderColor = kBlueFontColor
        view.tagAttribute.normalBackgroundColor = kWhiteColor
        view.tagAttribute.selectedBackgroundColor = kBlueFontColor
        view.tagAttribute.textColor = kBlueFontColor
        view.tagAttribute.selectedTextColor = kWhiteColor
        /// 显示多行
        view.layout.scrollDirection = .vertical
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 交货期
    lazy var dateInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "交货期：", placeHolder: "请选择交货期")
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    ///
    lazy var buyDesLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "我要买:"
        
        return lab
    }()
    /// 减号
    lazy var minusView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_goods_minus"))
    ///
    lazy var buyNumLab: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = kBackgroundColor
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "1"
        
        return lab
    }()
    /// 加号
    lazy var addView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_goods_add"))
    
    ///备注
    lazy var noteDesLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "备注:"
        
        return lab
    }()
    /// 备注
    lazy var noteTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kHeightGaryFontColor
        txtView.borderColor = kGrayLineColor
        txtView.borderWidth = klineWidth
        txtView.text = placeHolder
        
        return txtView
    }()
    
    /// 关闭
    lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kRedFontColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确  定", for: .normal)
        btn.addTarget(self, action: #selector(clickedOkBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 显示
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        addAnimation()
    }
    
    ///添加显示动画
    func addAnimation(){
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)! - (weakSelf?.bgView.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            
            //            weakSelf?.bgView.center = (weakSelf?.center)!
            weakSelf?.backgroundView.alpha = 0.2
            
        }) { (finished) in
            
        }
    }
    
    ///移除动画
    func removeAnimation(){
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            weakSelf?.backgroundView.alpha = 0
            
        }) { (finished) in
            weakSelf?.removeFromSuperview()
        }
    }
    /// 隐藏
    func hide(){
        removeAnimation()
    }
    
    /// 点击空白取消
    @objc func onTapCancle(sender:UITapGestureRecognizer){
        
        hide()
    }
    /// 确定
    @objc func clickedOkBtn(){
        if selectedRote == "" {
            MBProgressHUD.showAutoDismissHUD(message: "请选择传动比")
            return
        }
        if (dateInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请选择交货日期")
            return
        }
        if resultBlock != nil {
            let dic: [String: Any] = ["pro_speed": (dataModel?.goodsModel?.pro_speed)!,"pro_model":selectedType,"drive_ratio":selectedRote,"num":number,"t_data":selectTime,"remark":content]
            resultBlock!(dic)
        }
        hide()
    }
    
    /// 减
    @objc func onClickedMinus(){
        number = Int.init(buyNumLab.text!)!
        if number > 1 {
            number -= 1
        }
        buyNumLab.text = "\(number)"
    }
    /// 加
    @objc func onClickedAdd(){
        number = Int.init(buyNumLab.text!)!
        number += 1
        buyNumLab.text = "\(number)"
    }
    /// 选择日期
    @objc func onClickedSelectedDate(){
        UsefulPickerView.showDatePicker("请选择交货期") { [weak self](date) in
            self?.selectTime = Int(date.timeIntervalSince1970)
            self?.dateInputView.textFiled.text = date.dateToStringWithFormat(format: "yyyy-MM-dd")
        }
    }
}
extension JSMSelectGoodsParamsView : UITextViewDelegate
{
    
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
        
        content = textView.text
    }
}
