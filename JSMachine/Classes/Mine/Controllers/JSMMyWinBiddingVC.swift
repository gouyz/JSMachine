//
//  JSMMyWinBiddingVC.swift
//  JSMachine
//  已中标
//  Created by gouyz on 2019/4/10.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let myWinBiddingCell = "myWinBiddingCell"

class JSMMyWinBiddingVC: GYZBaseVC {

    var orderStatus: String = ""
    var currPage : Int = 1
    var dataList: [JSMJingBiaoModel] = [JSMJingBiaoModel]()
    /// 选择支付凭证
    var selectPayImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        
        requestWinBiddingDatas()
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
        table.separatorStyle = .none
        
        // 设置大概高度
        table.estimatedRowHeight = 120
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(JSMWinBiddingCell.self, forCellReuseIdentifier: myWinBiddingCell)
        
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
    
    ///获取我的竞标列表数据
    func requestWinBiddingDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("second/bidding",parameters: ["page": currPage,"type": orderStatus,"user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMJingBiaoModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无中标信息")
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
        requestWinBiddingDatas()
    }
    
    /// 上拉加载更多
    func loadMore(){
        currPage += 1
        requestWinBiddingDatas()
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
    /// 查看合同
    @objc func onClickedContract(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataList[tag]

        requestGetContractUrl(model: model)
    }
    /// 发货、查看物流单、合同有效
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataList[tag]
        if model.status == "2" {//合同有效
            sureControctAlert(row: tag)
        }else if model.status == "6" {//发货
            selectImg(model: model, row: tag)
        }else{//查看物流单
            requestGetExpressUrl(model: model)
        }
    }
    //合同有效
    func sureControctAlert(row:Int){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确认合同有效吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestSureContract(rowIndex: row)
            }
        }
    }
    /// 查看物流单
    func requestGetExpressUrl(model: JSMJingBiaoModel){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/seeWl", parameters: ["id": model.id ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.goBigPhotos(index: 0, urls: [response["data"]["wl_list"].stringValue])
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 查看合同
    func requestGetContractUrl(model: JSMJingBiaoModel){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("need/see", parameters: ["id": model.id ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.goBigPhotos(index: 0, urls: [response["data"]["contract_img"].stringValue])
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 查看合同
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - urls: 图片路径
    func goBigPhotos(index: Int, urls: [String]){
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: urls))
        browser.initializePageIndex(index)
        //        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
    
    /// 确认合同有效
    func requestSureContract(rowIndex: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/valid", parameters: ["id": dataList[rowIndex].id ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dealResult(status: "3",rowIndex: rowIndex)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 选择物流单图片
    func selectImg(model: JSMJingBiaoModel,row:Int){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: false, finished: { [weak self] (image) in
            
            self?.selectPayImg = image
            self?.requestUpdatePayCert(model: model,row:row)
        })
    }
    /// 上传物流单图片
    func requestUpdatePayCert(model: JSMJingBiaoModel,row:Int){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "wl_list"
        imgParam.fileName = "wl_list.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImageJPEGRepresentation(selectPayImg!, 0.5)
        
        GYZNetWork.uploadImageRequest("second/upShip", parameters: ["id": model.id ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dealResult(status: "4",rowIndex: row)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func dealResult(status: String,rowIndex: Int){
        dataList[rowIndex].status = status
        if orderStatus != "4" {
            dataList.remove(at: rowIndex)
        }
        tableView.reloadData()
        if dataList.count == 0{
            ///显示空页面
            showEmptyView(content: "暂无中标信息")
        }
    }
    /// 查看评价
    @objc func onClickedConment(sender: UITapGestureRecognizer){
        
    }
    /// 查看支付凭证
    @objc func onClickedpayCertLab(sender:UITapGestureRecognizer){
        
        let tag: Int = (sender.view?.tag)!
        requestGetPayCertUrl(needId: dataList[tag].id!)
    }
    /// 查看支付凭证
    func requestGetPayCertUrl(needId: String){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/seeVoucher", parameters: ["id": needId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.goBigPhotos(index: 0, urls: [response["data"]["pay_voucher"].stringValue])
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension JSMMyWinBiddingVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myWinBiddingCell) as! JSMWinBiddingCell
        
        cell.dataModel = dataList[indexPath.row]
        cell.operatorLab.tag = indexPath.row
        cell.operatorLab.addOnClickListener(target: self, action: #selector(onClickedConment(sender:)))

        cell.expressListLab.tag = indexPath.row
        cell.expressListLab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        cell.payCertLab.tag = indexPath.row
        cell.payCertLab.addOnClickListener(target: self, action: #selector(onClickedpayCertLab(sender:)))
        cell.contractLab.tag = indexPath.row
        cell.contractLab.addOnClickListener(target: self, action: #selector(onClickedContract(sender:)))
        
        
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
        let vc = JSMBiddingDetailVC()
        vc.needId = dataList[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
