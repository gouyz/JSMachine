//
//  JSMAuthenticityVC.swift
//  JSMachine
//  真伪查询
//  Created by gouyz on 2018/11/29.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMAuthenticityVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "真伪查询"
        setupUI()
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(iconView)
        contentView.addSubview(bgView)
        bgView.addSubview(tagImgView)
        bgView.addSubview(desLab)
        bgView.addSubview(lineView)
        bgView.addSubview(typeInputView)
        bgView.addSubview(rightIconView)
        bgView.addSubview(lineView1)
        bgView.addSubview(numberInputView)
        
        contentView.addSubview(submitBtn)
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
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.48)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
            make.height.equalTo(150 + klineDoubleWidth)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab)
            make.size.equalTo(CGSize.init(width: 3, height: 20))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        typeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(bgView)
            make.right.equalTo(rightIconView.snp.left)
            make.height.equalTo(desLab)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(typeInputView)
            make.size.equalTo(rightArrowSize)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(typeInputView.snp.bottom)
            make.height.left.right.equalTo(lineView)
        }
        numberInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom)
            make.left.height.equalTo(typeInputView)
            make.right.equalTo(bgView)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(iconView)
            make.top.equalTo(bgView.snp.bottom).offset(50)
            make.height.equalTo(kUIButtonHeight)
        }
       
        tipsLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(submitBtn)
            make.top.equalTo(submitBtn.snp.bottom).offset(20)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
        typeInputView.textFiled.isEnabled = false
        typeInputView.addOnClickListener(target: self, action: #selector(onClickedSelectedType))
        
    }
    
    /// scrollView
    lazy var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    lazy var contentView: UIView = UIView()
    /// banner
    lazy var iconView:UIImageView = UIImageView.init(image: UIImage.init(named: "icon_authenticity_banner"))
    
    ///
    lazy var bgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "请按提示搜索"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    /// 分割线2
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 减速机品牌
    lazy var typeInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "减速机品牌：", placeHolder: "请选择产品品牌")
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    /// 分割线2
    lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 出厂编号
    lazy var numberInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "出厂编号：", placeHolder: "请输入产品型号")
    
    /// 点击查询按钮
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("点击查询", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        
        return btn
    }()
    
    ///
    lazy var tipsLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.text = "温馨提示：本窗口为减速机制造企业提供原厂真伪识别。有效打击市场假冒伪劣产品，为制造企业减少直接经济损失，提高用户对企业的信任度。"
        
        return lab
    }()
    
    /// 提交按钮
    @objc func onClickedSubmitBtn(){
        
        goResultVC()
    }
    /// 选择品牌
    @objc func onClickedSelectedType(){
        
    }
    /// 查看结果
    func goResultVC(){
        let vc = JSMAuthenticityResultVC()
        vc.isSuccess = false
        navigationController?.pushViewController(vc, animated: true)
    }
}
