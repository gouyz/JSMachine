//
//  JSMMyProfileVC.swift
//  JSMachine
//  个人设置
//  Created by gouyz on 2018/11/23.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let profileCell = "profileCell"

class JSMMyProfileVC: GYZBaseVC {

    /// 选择用户头像
    var selectUserImg: UIImage?
    var userInfoModel: LHSUserInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "个人设置"
        
        view.addSubview(loginOutBtn)
        view.addSubview(tableView)
        loginOutBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(loginOutBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            requestMineData()
        }else{
            userInfoModel = nil
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        table.backgroundColor = kWhiteColor
        
        table.register(GYZMyProfileCell.self, forCellReuseIdentifier: profileCell)
        
        return table
    }()
    
    /// 退出登录按钮
    lazy var loginOutBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kRedFontColor
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedLoginOutBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 获取我的 数据
    func requestMineData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/myInfo", parameters: ["user_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.userInfoModel = LHSUserInfoModel.init(dict: data)
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 选择头像
    func selectHeaderImg(){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [weak self] (image) in
            
            self?.selectUserImg = image
            self?.requestUpdateHeaderImg()
        })
    }
    
    /// 上传头像
    func requestUpdateHeaderImg(){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "head"
        imgParam.fileName = "header.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImageJPEGRepresentation(selectUserImg!, 0.5)
        
        GYZNetWork.uploadImageRequest("my/saveInfo", parameters: ["user_id":userDefaults.string(forKey: "userId") ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.tableView.reloadData()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 退出登录
    @objc func clickedLoginOutBtn(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要退出登录吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.loginOut()
            }
        }
    
    }
    func loginOut(){
        GYZTool.removeUserInfo()
        JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
            
        }, seq: 0)
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改昵称
    func goNickNameVC(){
        let vc = JSMModifyNickNameVC()
        vc.name = (userInfoModel?.nickname)!
        vc.resultBlock = {[weak self] (name) in
            self?.userInfoModel?.nickname = name
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改邮箱
    func goEmailVC(){
        let vc = JSMModifyEmailVC()
        vc.email = (userInfoModel?.email)!
        vc.resultBlock = {[weak self] (email) in
            self?.userInfoModel?.email = email
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改密码
    func goPwdVC(){
        let vc = JSMModifyPwdVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JSMMyProfileVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: profileCell) as! GYZMyProfileCell
        
        cell.desLab.textColor = kGaryFontColor
        cell.userImgView.isHidden = true
        cell.desLab.isHidden = true
        cell.rightIconView.isHidden = false
        
        if indexPath.row == 0 {
            cell.nameLab.text = "头像"
            cell.userImgView.isHidden = false
            if selectUserImg != nil{
                cell.userImgView.image = selectUserImg
            }else{
                cell.userImgView.kf.setImage(with: URL.init(string: userInfoModel?.head ?? ""), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
        } else if indexPath.row == 1{
            cell.nameLab.text = "昵称"
            cell.desLab.isHidden = false
            cell.desLab.text = userInfoModel?.nickname
        }else if indexPath.row == 2{
            cell.nameLab.text = "电话"
            cell.desLab.isHidden = false
            cell.rightIconView.isHidden = true
            cell.desLab.text = userInfoModel?.phone
        }else if indexPath.row == 3{
            cell.nameLab.text = "邮箱"
            cell.desLab.isHidden = false
            cell.desLab.text = userInfoModel?.email
        }else if indexPath.row == 4{
            cell.nameLab.text = "修改密码"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {//选择头像
            selectHeaderImg()
        }else if indexPath.row == 1{//昵称
            goNickNameVC()
        }else if indexPath.row == 3{/// 邮箱
            goEmailVC()
        }else if indexPath.row == 4{/// 修改密码
            goPwdVC()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
