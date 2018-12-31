//
//  JSMEngineerFinishedVC.swift
//  JSMachine
//  维修记录提交
//  Created by gouyz on 2018/12/19.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import DKImagePickerController

class JSMEngineerFinishedVC: GYZBaseVC {
    
    /// 选择的图片
    var selectImgs: [UIImage] = []
    /// 最大选择图片数量
    var maxImgCount: Int = kMaxSelectCount
    ///订单ID
    var orderId: String = ""
    ///是否完成
    var isFinished: String = "0"
    /// 选择结果回调
    var resultBlock:(() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "维修记录"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setupUI()
        addPhotosView.delegate = self
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(detailBgView)
        detailBgView.addSubview(desLab)
        detailBgView.addSubview(tagImgView)
        detailBgView.addSubview(lineView)
        detailBgView.addSubview(typeInputView)
        detailBgView.addSubview(lineView1)
        detailBgView.addSubview(reasonInputView)
        
        contentView.addSubview(noteBgView)
        noteBgView.addSubview(tagImgView1)
        noteBgView.addSubview(desLab1)
        noteBgView.addSubview(lineView2)
        noteBgView.addSubview(noteInputView)
        noteBgView.addSubview(lineView3)
        noteBgView.addSubview(addPhotosView)
        
        contentView.addSubview(finishBgView)
        finishBgView.addSubview(finishLab)
        finishBgView.addSubview(switchView)
        
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
        detailBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(kMargin)
            make.height.equalTo(150 + klineDoubleWidth)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab)
            make.size.equalTo(CGSize.init(width: 3, height: 20))
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.equalTo(detailBgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(detailBgView)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        typeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(detailBgView)
            make.height.equalTo(desLab)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(typeInputView.snp.bottom)
            make.height.left.right.equalTo(lineView)
        }
        reasonInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom)
            make.right.left.height.equalTo(typeInputView)
        }
        
        noteBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(detailBgView)
            make.top.equalTo(detailBgView.snp.bottom).offset(kMargin)
        }
        tagImgView1.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(desLab1)
            make.size.equalTo(tagImgView)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView1.snp.right).offset(5)
            make.top.equalTo(noteBgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(noteBgView)
            make.top.equalTo(desLab1.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        noteInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom)
            make.right.left.equalTo(lineView2)
            make.height.equalTo(50)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView2)
            make.top.equalTo(noteInputView.snp.bottom)
        }
        addPhotosView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom).offset(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kPhotosImgHeight)
            make.bottom.equalTo(-kMargin)
        }
        
        finishBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(noteBgView.snp.bottom).offset(kMargin)
            make.height.equalTo(kTitleHeight)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        finishLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(finishBgView)
            make.left.equalTo(kMargin)
            make.right.equalTo(switchView.snp.left).offset(-kMargin)
        }
        switchView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(finishBgView)
        }
        
    }
    
    /// scrollView
    lazy var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    lazy var contentView: UIView = UIView()
    
    ///
    lazy var detailBgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "故障详情"
        
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
    /// 机械型号
    lazy var typeInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "机械型号：", placeHolder: "请输入机械型号")
    /// 分割线2
    lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 故障原因
    lazy var reasonInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "故障原因：", placeHolder: "请输入故障原因")
    ///
    lazy var noteBgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "维修备注"
        
        return lab
    }()
    
    /// 图片
    lazy var tagImgView1 : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_vertical_line")
        
        return imgView
    }()
    /// 分割线2
    lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 备注说明
    lazy var noteInputView : GYZLabAndFieldView = GYZLabAndFieldView(desName: "备注说明：", placeHolder: "请输入现场备注说明")
    /// 分割线2
    lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 添加照片View
    lazy var addPhotosView: LHSAddPhotoView = LHSAddPhotoView.init(frame: CGRect.zero, maxCount: maxImgCount)
    
    ///
    lazy var finishBgView : UIView = {
        let line = UIView()
        line.backgroundColor = kWhiteColor
        return line
    }()
    lazy var finishLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "是否完成"
        
        return lab
    }()
    /// 开关
    lazy var switchView: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(onClickedFinish(sender:)), for: .valueChanged)
        return sw
    }()
    @objc func onClickedFinish(sender: UISwitch){
        isFinished = sender.isOn ? "1" : "0"
        GYZLog(isFinished)
    }
    
    /// 提交按钮
    @objc func onClickedSubmitBtn(){
        
        if (typeInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入型号")
            return
        }
        if (reasonInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入故障原因")
            return
        }
        if (noteInputView.textFiled.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入备注")
            return
        }
        
        requestSubmitDatas()
    }
    
    ///提交
    func requestSubmitDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var imgsParam: [ImageFileUploadParam] = [ImageFileUploadParam]()
        for (index,imgItem) in selectImgs.enumerated() {
            let imgParam: ImageFileUploadParam = ImageFileUploadParam()
            imgParam.name = "pic[]"
            imgParam.fileName = "pic\(index).jpg"
            imgParam.mimeType = "image/jpg"
            imgParam.data = UIImageJPEGRepresentation(imgItem, 0.5)
            
            imgsParam.append(imgParam)
        }
        
        GYZNetWork.uploadImageRequest("engineer/submitlAllot", parameters: ["id":orderId,"w_model":typeInputView.textFiled.text!,"w_reason":reasonInputView.textFiled.text!,"w_remark":noteInputView.textFiled.text ?? "","is_finish": isFinished], uploadParam: imgsParam, success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
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
}
extension JSMEngineerFinishedVC : LHSAddPhotoViewDelegate{
    
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
                GYZOpenCameraPhotosTool.shareTool.showPermissionAlert(content: "请在iPhone的“设置-隐私”选项中，允许懒人社访问你的摄像头",controller : self)
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
}
extension JSMEngineerFinishedVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate
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
