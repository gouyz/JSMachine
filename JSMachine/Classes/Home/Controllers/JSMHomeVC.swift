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
    
    /// 技术在线、申请售后、需求发布、在线商城
    func dealOperator(index : Int){
        switch index {
        case 1://技术在线
            break
        case 2://申请售后
            break
        case 3://需求发布
            break
        case 4://在线商城
            break
        default:
            break
        }
    }
}

extension JSMHomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: homeNewsCell) as! JSMHomeNewsCell
        
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: homeNewsHeader) as! JSMHomeNewsHeaderView
        
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

