//
//  JSMConmentVC.swift
//  JSMachine
//  评价
//  Created by gouyz on 2019/4/11.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController
import Cosmos

class JSMConmentVC: GYZBaseVC {

    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    ///txtView 提示文字
    let placeHolder = "您对我们的商品有什么意见或者建议，商品的有点或者美中不足的地方都可以说说"
    /// 选择的图片
    var selectImgs: [UIImage] = []
    /// 最大选择图片数量
    var maxImgCount: Int = kMaxSelectCount
    // 内容
    var content: String = ""
    var needId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        self.navigationItem.title = "商品评价"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        
        contentTxtView.delegate = self
        contentTxtView.text = placeHolder
        ratingView.didFinishTouchingCosmos = { rating in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(goodImgView)
        contentView.addSubview(desLab)
        contentView.addSubview(ratingView)
        contentView.addSubview(lineView)
        
        contentView.addSubview(contentTxtView)
        contentView.addSubview(addPhotosView)
        
        contentView.addSubview(lineView1)
        contentView.addSubview(tagImgView)
        contentView.addSubview(desLab1)
        contentView.addSubview(desLab2)
        contentView.addSubview(serviceRatingView)
        contentView.addSubview(desLab3)
        contentView.addSubview(wlRatingView)
        
        addPhotosView.delegate = self
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.equalTo(goodImgView.snp.right).offset(kMargin)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(50)
        }
        goodImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(desLab)
            make.left.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        ratingView.snp.makeConstraints { (make) in
            make.centerY.equalTo(desLab)
            make.left.equalTo(desLab.snp.right)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
            make.height.equalTo(120)
        }
        addPhotosView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentTxtView)
            make.top.equalTo(contentTxtView.snp.bottom).offset(kMargin)
            make.height.equalTo(kPhotosImgHeight)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(addPhotosView.snp.bottom).offset(kMargin)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.top.equalTo(lineView1.snp.bottom)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(goodImgView)
            make.centerY.equalTo(desLab1)
            make.size.equalTo(CGSize.init(width: 19, height: 16))
        }
        desLab2.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(desLab1.snp.bottom)
            make.width.equalTo(desLab)
            make.height.equalTo(desLab)
        }
        serviceRatingView.snp.makeConstraints { (make) in
            make.centerY.equalTo(desLab2)
            make.left.equalTo(desLab2.snp.right)
            make.width.height.equalTo(ratingView)
        }
        desLab3.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(desLab2)
            make.top.equalTo(desLab2.snp.bottom)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        wlRatingView.snp.makeConstraints { (make) in
            make.centerY.equalTo(desLab3)
            make.left.equalTo(desLab3.snp.right)
            make.width.height.equalTo(ratingView)
        }
    }
    
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    lazy var goodImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_logo_circle"))
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "商品"
        
        return lab
    }()
    ///星星评分
    lazy var ratingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.fillMode = .full
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 5
        ratingStart.settings.starSize = 30
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 描述
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kGaryFontColor
        
        return txtView
    }()
    /// 添加照片View
    lazy var addPhotosView: LHSAddPhotoView = LHSAddPhotoView.init(frame: CGRect.zero, maxCount: maxImgCount)
    
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    lazy var tagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_service_tag"))
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "商家服务"
        
        return lab
    }()
    ///
    lazy var desLab2 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "服务"
        
        return lab
    }()
    ///星星评分
    lazy var serviceRatingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.fillMode = .full
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 5
        ratingStart.settings.starSize = 30
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    ///
    lazy var desLab3 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "物流"
        
        return lab
    }()
    ///星星评分
    lazy var wlRatingView: CosmosView = {
        
        let ratingStart = CosmosView()
        ratingStart.settings.fillMode = .full
        ratingStart.settings.filledColor = kRedFontColor
        ratingStart.settings.emptyBorderColor = kRedFontColor
        ratingStart.settings.filledBorderColor = kRedFontColor
        ratingStart.settings.starMargin = 5
        ratingStart.settings.starSize = 30
        ratingStart.rating = 5
        
        return ratingStart
        
    }()
    ///打开相机
    func openCamera(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            MBProgressHUD.showAutoDismissHUD(message: "该设备无摄像头")
            return
        }
        
        GYZOpenCameraPhotosTool.shareTool.checkCameraPermission { (granted) in
            if granted{
                let photo = UIImagePickerController()
                photo.delegate = self
                photo.sourceType = .camera
                photo.allowsEditing = true
                self.present(photo, animated: true, completion: nil)
            }else{
                GYZOpenCameraPhotosTool.shareTool.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许访问你的摄像头",controller : self)
            }
        }
        
    }
    
    ///打开相册
    func openPhotos(){
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = maxImgCount
        
        weak var weakSelf = self
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            var count = 0
            for item in assets {
                item.fetchFullScreenImage(completeBlock: { (image, info) in
                    weakSelf?.selectImgs.append(image!)
                    weakSelf?.maxImgCount = kMaxSelectCount - (weakSelf?.selectImgs.count)!
                    
                    count += 1
                    if count == assets.count{
                        weakSelf?.resetAddImgView()
                    }
                })
            }
        }
        
        self.present(pickerController, animated: true) {}
    }
    
    /// 发表
    @objc func onClickRightBtn(){
        
        requestUpdateImg()
    }
    
    /// 提交评价
    func requestUpdateImg(){
        if !GYZTool.checkNetWork() {
            return
        }
        createHUD(message: "加载中...")
        weak var weakSelf = self
        
        var imgParams: [ImageFileUploadParam] = [ImageFileUploadParam]()
        if selectImgs.count > 0 {
            for (index,img) in selectImgs.enumerated(){
                let imgParam: ImageFileUploadParam = ImageFileUploadParam()
                imgParam.name = "image[]"
                imgParam.fileName = "image\(index).jpg"
                imgParam.mimeType = "image/jpg"
                imgParam.data = UIImageJPEGRepresentation(img, 0.5)
                imgParams.append(imgParam)
            }
        }
        
        GYZNetWork.uploadImageRequest("second/evaluate",parameters :["id": needId,"pscore": String.init(Int.init(ratingView.rating)),"cscore": String.init(Int.init(serviceRatingView.rating)),"wscore": String.init(Int.init(wlRatingView.rating)),"evaluate": content], uploadParam: imgParams, success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                if weakSelf?.resultBlock != nil {
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
}

extension JSMConmentVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            
            if self?.selectImgs.count == kMaxSelectCount{
                MBProgressHUD.showAutoDismissHUD(message: "最多只能上传\(kMaxSelectCount)张图片")
                return
            }
            self?.selectImgs.append(image)
            self?.maxImgCount -= 1
            self?.resetAddImgView()
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    /// 选择图片后重新设置图片显示
    func resetAddImgView(){
        var rowIndex = ceil(CGFloat.init(selectImgs.count) / 4.0)//向上取整
        /// 预留出增加按钮位置
        if selectImgs.count < kMaxSelectCount && selectImgs.count % 4 == 0 {
            rowIndex += 1
        }
        let height = kPhotosImgHeight * rowIndex + kMargin * (rowIndex - 1)
        
        addPhotosView.snp.updateConstraints({ (make) in
            make.height.equalTo(height)
        })
        addPhotosView.selectImgs = selectImgs
    }
}

extension JSMConmentVC : UITextViewDelegate,LHSAddPhotoViewDelegate
{
    ///MARK LHSAddPhotoViewDelegate
    ///添加图片
    func didClickAddImage(photoView: LHSAddPhotoView) {
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择照片", message: nil, cancleTitle: "取消", titleArray: ["拍照","从相册选取"], viewController: self) { [weak self](index) in
            
            if index == 0{//拍照
                self?.openCamera()
            }else if index == 1 {//从相册选取
                self?.openPhotos()
            }
        }
    }
    
    func didClickDeleteImage(index: Int, photoView: LHSAddPhotoView) {
        selectImgs.remove(at: index)
        maxImgCount += 1
        resetAddImgView()
    }
    
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
