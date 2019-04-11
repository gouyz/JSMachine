//
//  JSMDynamicVC.swift
//  JSMachine
//  曝光台
//  Created by gouyz on 2019/1/8.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let dynamicCell = "dynamicCell"

class JSMDynamicVC: GYZBaseVC {

    var type: String = "1"
    var currPage : Int = 1
    
    var dataList: [JSMNewsModel] = [JSMNewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestNewsDatas()
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(JSMNewsCell.self, forCellReuseIdentifier: dynamicCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        ///添加上拉加载更多
        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
            weakSelf?.loadMore()
        })
        
        return table
    }()
    ///获取资讯列表数据
    func requestNewsDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("second/exposure",parameters: ["p": currPage,"count": kPageSize,"type":type],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMNewsModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无曝光信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(error)
            
            if weakSelf?.currPage == 1{//第一次加载失败，显示加载错误页面
                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                    weakSelf?.refresh()
                    weakSelf?.hiddenEmptyView()
                })
            }
        })
    }
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
        requestNewsDatas()
    }
    
    /// 上拉加载更多
    func loadMore(){
        currPage += 1
        requestNewsDatas()
    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            dataList.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }else if tableView.mj_footer.isRefreshing{//上拉加载更多
            GYZTool.endLoadMore(scorllView: tableView)
        }
    }
    /// 分享
    @objc func onclickedShared(sender: UITapGestureRecognizer){
        let cancelBtn = [
            "title": "取消",
            "type": "danger"
        ]
        let mmShareSheet = MMShareSheet.init(title: "分享至", cards: kSharedCards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { [weak self](handler) ->() in
            
            if handler != "cancel" {// 取消
                if handler == kWXFriendShared || handler == kWXMomentShared{/// 微信分享
                    self?.weChatShared(tag: handler)
                }else{// QQ
                    self?.qqShared(tag: handler)
                }
            }
        }
        mmShareSheet.present()
    }
    /// 微信分享
    func weChatShared(tag: String){
        //发送给好友还是朋友圈（默认好友）
        var scene = WXSceneSession
        if tag == kWXMomentShared {//朋友圈
            scene = WXSceneTimeline
        }
        
        WXApiManager.shared.sendLinkURL(kSharedUrl, title: "闲力邦传动云平台", description: "技术、采购、售前、售中、售后一站式平台，赶紧来下载！", thumbImage: UIImage.init(named: "icon_logo")!, scene: scene,sender: self)
    }
    /// qq 分享
    func qqShared(tag: String){
        
        if !GYZTencentShare.shared.isQQInstall() {
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "QQ未安装", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            return
        }
        //发送给好友还是QQ空间（默认好友）
        var scene: GYZTencentFlag = .QQ
        if tag == kQZoneShared {//QQ空间
            scene = .QZone
        }
        let imgData = UIImageJPEGRepresentation(UIImage.init(named: "icon_logo")!, 0.6)
        GYZTencentShare.shared.shareNews(URL.init(string: kSharedUrl)!, preUrl: nil, preImage: imgData, title: "闲力邦传动云平台", description: "技术、采购、售前、售中、售后一站式平台，赶紧来下载！", flag: scene) { (success, description) in
            
        }
    }
    
    /// webVC
    func goWebViewVC(title: String, url: String){
        let vc = JSMWebViewVC()
        vc.url = url
        vc.webTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension JSMDynamicVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: dynamicCell) as! JSMNewsCell
        
        cell.sharedImgView.tag = indexPath.row
        cell.sharedImgView.addOnClickListener(target: self, action: #selector(onclickedShared(sender:)))
        
        cell.dataModel = dataList[indexPath.row]
        
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
        
        let model = dataList[indexPath.row]
        goWebViewVC(title: model.title!, url: model.url!)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
