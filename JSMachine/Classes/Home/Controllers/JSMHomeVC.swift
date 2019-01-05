//
//  JSMHomeVC.swift
//  JSMachine
//  首页
//  Created by gouyz on 2018/11/21.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let homeNewsCell = "homeNewsCell"
private let homeNewsHeader = "homeNewsHeader"

class JSMHomeVC: GYZBaseVC {
    
    let headerHeight: CGFloat = (kScreenWidth - kMargin * 2) * 0.47 + kStateHeight + (kScreenWidth - kMargin * 3) * 0.52 + 190
    
    var homeModel: JSMHomeModel?
    /// 热点
    lazy var hotLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
//        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
            make.left.right.bottom.equalTo(view)
        }
        
        tableView.tableHeaderView = headerView
        
        headerView.operatorBlock = {[weak self] (tag) in
            self?.dealOperator(index: tag)
        }
        headerView.funcModelBlock = {[weak self] (tag) in
            self?.dealFuncModel(index: tag)
        }
        headerView.adsImgView.didSelectedItem = {[weak self] (tag) in
            self?.playVideo(index: tag)
        }
        
        requestHomeDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        // 设置大概高度
        table.estimatedRowHeight = 120
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(JSMHomeNewsCell.self, forCellReuseIdentifier: homeNewsCell)
        table.register(JSMHomeNewsHeaderView.self, forHeaderFooterViewReuseIdentifier: homeNewsHeader)
        
        return table
    }()
    
    lazy var headerView: JSMHomeHeaderView = JSMHomeHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: headerHeight))
    
    ///获取首页数据
    func requestHomeDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("index/appIndex",parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.homeModel = JSMHomeModel.init(dict: data)
                weakSelf?.setData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func setData(){
        
        if homeModel != nil {
            
            if homeModel?.bannerModels.count > 0{
                var imgUrlArr: [String] = [String]()
                for imgUrl in (homeModel?.bannerModels)! {
                    imgUrlArr.append(imgUrl.img!)
                }
                headerView.adsImgView.setUrlsGroup(imgUrlArr)
            }
            if homeModel?.hotModels.count > 0{
//                var hotTitleArr: [String] = [String]()
                var hotContent: String = ""
                for item in (homeModel?.hotModels)! {
//                    hotTitleArr.append(item.content!)
                    hotContent += item.content! + "    "
                }
                hotLab.text = hotContent
                headerView.hotTxtView.contentView = hotLab
//                headerView.hotTxtView.setTitlesGroup(hotTitleArr)
            }
            
            tableView.reloadData()
        }
    }
    /// 播放视频
    func playVideo(index : Int){
        let vc = JSMPlayVideoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 技术在线、快修申请、需求发布、在线商城
    func dealOperator(index : Int){
        switch index {
        case 1://技术在线
            goOnLineVC()
        case 2://快修申请
            goApplyVC()
        case 3://快购发布
            goPublishNeedVC()
        case 4://在线商城
            goShopVC()
        default:
            break
        }
    }
    func dealFuncModel(index : Int){
        switch index {
        case 1://平台介绍
            goWebViewVC(title: "平台介绍", url: homeModel?.platform_url ?? "")
        case 2://真伪查询
            goAuthenticityVC()
        case 3://招商加盟
            goWebViewVC(title: "招商加盟", url: homeModel?.join_url ?? "")
        case 4://合作伙伴
            goPartnerVC()
        default:
            break
        }
    }
    //技术在线
    func goOnLineVC(){
        let vc = JSMTechnologyOnlineVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    //快购发布
    func goPublishNeedVC(){
        let vc = JSMPublishNeedVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    //快修申请
    func goApplyVC(){
        
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            goLogin()
        }else{
            let vc = JSMMySaleServiceVC()
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    /// 登录
    func goLogin(){
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    //在线商城
    func goShopVC(){
        let vc = JSMShopsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// webVC
    func goWebViewVC(title: String, url: String){
        let vc = JSMWebViewVC()
        vc.url = url
        vc.webTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
    //合作伙伴
    func goPartnerVC(){
        let vc = JSMPartnerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    //真伪查询
    func goAuthenticityVC(){
        let vc = JSMAuthenticityVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 行业资讯
    @objc func onClickedNews(){
        let vc = JSMNewsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JSMHomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeModel == nil {
            return 0
        }
        return (homeModel?.newModels.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: homeNewsCell) as! JSMHomeNewsCell
        
        cell.dataModel = homeModel?.newModels[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: homeNewsHeader) as! JSMHomeNewsHeaderView
        
        headerView.addOnClickListener(target: self, action: #selector(onClickedNews))
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = homeModel?.newModels[indexPath.row]
        goWebViewVC(title: (model?.title)!, url: (model?.url)!)
    }
    ///MARK : UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleAndStateHeight + kStateHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = "首页"
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
        }
    }
}
extension JSMHomeVC{
    /// 获取App Store版本信息
    func requestVersion(){
        
        weak var weakSelf = self
        
        GYZNetWork.requestVersionNetwork("http://itunes.apple.com/cn/lookup?id=\(APPID)", success: { (response) in
            
            //            GYZLog(response)
            if response["resultCount"].intValue == 1{//请求成功
                let data = response["results"].arrayValue
                
                var version: String = GYZUpdateVersionTool.getCurrVersion()
                var content: String = ""
                if data.count > 0{
                    version = data[0]["version"].stringValue//版本号
                    content = data[0]["releaseNotes"].stringValue//更新内容
                }
                
                weakSelf?.checkVersion(newVersion: version, content: content)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    /// 检测APP更新
    func checkVersion(newVersion: String,content: String){
        
        let type: UpdateVersionType = GYZUpdateVersionTool.compareVersion(newVersion: newVersion)
        switch type {
        case .noUpdate:
            break
        default:
            updateVersion(version: newVersion, content: content)
            break
        }
    }
    /**
     * //不强制更新
     * @param version 版本名称
     * @param content 更新内容
     */
    func updateVersion(version: String,content: String){
        
        GYZAlertViewTools.alertViewTools.showAlert(title:"发现新版本\(version)", message: content, cancleTitle: "残忍拒绝", viewController: self, buttonTitles: "立即更新", alertActionBlock: { (index) in
            
            if index == 0{//立即更新
                GYZUpdateVersionTool.goAppStore()
            }
        })
    }
}

