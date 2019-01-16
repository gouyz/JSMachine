//
//  JSMEngineerProfileVC.swift
//  JSMachine
//  工程师个人中心
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let engineerProfileCell = "engineerProfileCell"

class JSMEngineerProfileVC: GYZBaseVC {

    /// 选择用户头像
    var selectUserImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "个人信息"
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        table.backgroundColor = kWhiteColor
        
        table.register(GYZMyProfileCell.self, forCellReuseIdentifier: engineerProfileCell)
        
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
    
    /// 选择头像
    func selectHeaderImg(){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: true, finished: { [weak self] (image) in
            
            self?.selectUserImg = image
            self?.tableView.reloadData()
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
        
        GYZNetWork.uploadImageRequest("engineer/editInfo", parameters: ["engineer_id":userDefaults.string(forKey: "userId") ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                userDefaults.set(response["data"]["head"].stringValue, forKey: "head")//用户头像
                weakSelf?.tableView.reloadData()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 退出登录
    @objc func clickedLoginOutBtn(){
        GYZTool.removeUserInfo()
        
        JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
            
        }, seq: 0)
        for i in 0..<(navigationController?.viewControllers.count)!{
            
            if navigationController?.viewControllers[i].isKind(of: JSMEngineerHomerVC.self) == true {
                
                let vc = navigationController?.viewControllers[i] as! JSMEngineerHomerVC
                vc.scrollPageView?.selectedIndex(0, animated: true)
                _ = navigationController?.popToViewController(vc, animated: true)
                
                break
            }
        }
        
//        let vc = JSMLoginVC()
//        navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改密码
    func goPwdVC(){
        let vc = JSMModifyPwdVC()
        vc.isEngineer = true
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 客户评价
    func goConmentVC(){
        let vc = JSMEngineerConmentVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 登录
    func goLogin(){
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JSMEngineerProfileVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: engineerProfileCell) as! GYZMyProfileCell
        
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
            
                cell.userImgView.kf.setImage(with: URL.init(string: userDefaults.string(forKey: "head") ?? ""), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
        } else if indexPath.row == 1{
            cell.nameLab.text = "姓名"
            cell.desLab.isHidden = false
            cell.rightIconView.isHidden = true
            cell.desLab.text = userDefaults.string(forKey: "realName")
        }else if indexPath.row == 2{
            cell.nameLab.text = "工号"
            cell.desLab.isHidden = false
            cell.rightIconView.isHidden = true
            cell.desLab.text = userDefaults.string(forKey: "code")
        }else if indexPath.row == 3{
            cell.nameLab.text = "性别"
            cell.rightIconView.isHidden = true
            cell.desLab.isHidden = false
            cell.desLab.text = userDefaults.string(forKey: "sex") == "1" ? "男" : "女"
        }else if indexPath.row == 4{
            cell.nameLab.text = "手机号"
            cell.rightIconView.isHidden = true
            cell.desLab.isHidden = false
            cell.desLab.text = userDefaults.string(forKey: "phone")
        }else if indexPath.row == 5{
            cell.nameLab.text = "修改密码"
        }else if indexPath.row == 6{
            cell.nameLab.text = "我的客户评价"
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
            if !userDefaults.bool(forKey: kIsLoginTagKey) {
                goLogin()
            }else{
                selectHeaderImg()
            }
        }else if indexPath.row == 5{/// 修改密码
            if !userDefaults.bool(forKey: kIsLoginTagKey) {
                goLogin()
            }else{
                goPwdVC()
            }
        }else if indexPath.row == 6{/// 客户评价
            goConmentVC()
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
