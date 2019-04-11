//
//  JSMMyPublishNeedVC.swift
//  JSMachine
//  我的发布
//  Created by gouyz on 2018/11/28.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let myPublishNeedCell = "myPublishNeedCell"

class JSMMyPublishNeedVC: GYZBaseVC {

    /// 选择合同
    var selectContractImg: UIImage?
    var orderStatus: String = ""
    var currPage : Int = 1
    var dataList: [JSMPublishNeedModel] = [JSMPublishNeedModel]()
    /// 下载合同url
    var downLoadUrl:String = ""
    /// 选择s支付凭证
    var selectPayCertImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        
        requestPublishOrderDatas()
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
        
        table.register(JSMMyPublishNeedCell.self, forCellReuseIdentifier: myPublishNeedCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        //        ///添加上拉加载更多
        //        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
        //            weakSelf?.loadMore()
        //        })
        return table
    }()
    
    ///获取我的发布列表数据
    func requestPublishOrderDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("need/myNeed",parameters: ["user_id": userDefaults.string(forKey: "userId") ?? "","type": orderStatus],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMPublishNeedModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无发布需求信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestPublishOrderDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
        requestPublishOrderDatas()
    }
    
    //    /// 上拉加载更多
    //    func loadMore(){
    //        currPage += 1
    //        requestOrderDatas()
    //    }
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            dataList.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }
        //        else if tableView.mj_footer.isRefreshing{//上拉加载更多
        //            GYZTool.endLoadMore(scorllView: tableView)
        //        }
    }
    /// 推荐商品
    @objc func onClickedTuiJianGoods(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = JSMTuiJianGoodsVC()
        vc.proModel = dataList[tag!].pro_model!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 下载合同
    @objc func onClickedDownContract(sender: UIButton){
        showTips()
    }
    
    func showTips(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "下载合同", message: "确定要下载合同吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestGetDownLoadURL()
            }
        }
    }
    /// 查看合同、上传合同
    @objc func onClickedContract(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataList[tag]
        let status: String = model.status!
        if status == "1" {//上传合同
            selectImg(model: model,rowIndex: tag)
        }else{// 查看合同
            requestGetContractUrl(model: model)
        }
    }
    /// 确认收货、上传支付凭证、评价
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataList[tag]
        let status: String = model.status!
        if status == "3" {//上传支付凭证
            selectImg(model: model,rowIndex: tag)
        }else if status == "4"{// 确认收货
            requestSureGoods(model: dataList[tag], rowIndex: tag)
        }else if status == "5"{// 评价
            goConmentVC(rowIndex: tag)
        }
    }
    // 评价
    func goConmentVC(rowIndex: Int){
        let vc = JSMConmentVC()
        vc.needId = dataList[rowIndex].id!
        vc.resultBlock = { [weak self] () in
            self?.dataList[rowIndex].status = "7"
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 查看合同
    func requestGetContractUrl(model: JSMPublishNeedModel){
        
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
    
    /// 确认收货
    func requestSureGoods(model: JSMPublishNeedModel,rowIndex: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("need/ureceipt", parameters: ["id": model.id ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dealResult(status: "5",rowIndex: rowIndex)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 选择合同图片
    func selectImg(model: JSMPublishNeedModel,rowIndex: Int){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: false, finished: { [weak self] (image) in
            
            if model.status == "3"{
                self?.selectPayCertImg = image
                self?.requestUpdatePayCert(model: model,rowIndex: rowIndex)
            }else{
                self?.selectContractImg = image
                self?.requestUpdateContract(model: model,rowIndex: rowIndex)
            }
            
        })
    }
    /// 上传合同
    func requestUpdateContract(model: JSMPublishNeedModel,rowIndex: Int){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "contract_img"
        imgParam.fileName = "contract_img.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImageJPEGRepresentation(selectContractImg!, 0.5)
        
        GYZNetWork.uploadImageRequest("need/upContract", parameters: ["id": model.id ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dealResult(status: "2", rowIndex: rowIndex)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 上传支付凭证
    func requestUpdatePayCert(model: JSMPublishNeedModel,rowIndex: Int){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "voucher"
        imgParam.fileName = "voucher.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImageJPEGRepresentation(selectPayCertImg!, 0.5)
        
        GYZNetWork.uploadImageRequest("second/upVoucher", parameters: ["id": model.id ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dealResult(status: "6", rowIndex: rowIndex)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func dealResult(status: String,rowIndex: Int){
        dataList[rowIndex].status = status
        if orderStatus != "1" {
            dataList.remove(at: rowIndex)
        }
        tableView.reloadData()
        if dataList.count == 0{
            ///显示空页面
            showEmptyView(content: "暂无发布需求信息")
        }
    }
    
    /// 获取下载合同url
    func requestGetDownLoadURL(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("index/download",  success: { (response) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.downLoadUrl = response["data"]["content"].stringValue
                GYZTool.openSafari(url: (weakSelf?.downLoadUrl)!)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 下载合同
    func requestDownLoadContract(){
        weak var weakSelf = self
//        "http://www.hangge.com/blog/images/logo.png"
        GYZNetWork.downLoadRequest( downLoadUrl, success: { (response) in
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: "下载成功")
        }) { (error) in
            GYZLog(error)
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: "下载失败，请重新下载")
        }
    }
    /// 查看竞标者
    @objc func onClickedBidding(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        if (dataList[tag].b_name?.isEmpty)! {
            let vc = JSMSelectBiddingPersonVC()
            vc.needId = dataList[tag].id!
            vc.resultBlock = {[weak self] (name) in
                self?.dataList[tag].b_name = name
                self?.dataList[tag].status = "1"
                self?.tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    /// 查看支付凭证
    @objc func onClickedpayCertLab(sender:UITapGestureRecognizer){
        
        let tag: Int = (sender.view?.tag)!
        requestGetPayCertUrl(needId: dataList[tag].id!)
    }
    /// 查看物流单
    @objc func onClickedExpress(sender:UITapGestureRecognizer){
        
        let tag: Int = (sender.view?.tag)!
        requestGetExpressUrl(needId: dataList[tag].id!)
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
    /// 查看物流单
    func requestGetExpressUrl(needId: String){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/seeWl", parameters: ["id": needId],  success: { (response) in
            
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
}

extension JSMMyPublishNeedVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myPublishNeedCell) as! JSMMyPublishNeedCell
        
        let model = dataList[indexPath.row]
        cell.dataModel = model
        if (model.b_name?.isEmpty)! {
            cell.biddingLab.text = "查看竞标者"
            cell.biddingLab.textColor = kBlueFontColor
            cell.bidImgView.isHighlighted = false
        }else{
            cell.biddingLab.text = "中标者：" + model.b_name!
            cell.biddingLab.textColor = kHeightGaryFontColor
            cell.bidImgView.isHighlighted = true
        }
        cell.biddingLab.tag = indexPath.row
        cell.biddingLab.addOnClickListener(target: self, action: #selector(onClickedBidding(sender:)))
        
        cell.tuiJianLab.tag = indexPath.row
        cell.tuiJianLab.addOnClickListener(target: self, action: #selector(onClickedTuiJianGoods(sender:)))
        cell.downLoadBtn.tag = indexPath.row
        cell.downLoadBtn.addTarget(self, action: #selector(onClickedDownContract(sender:)), for: .touchUpInside)
        cell.operatorLab.tag = indexPath.row
        cell.operatorLab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        cell.contractLab.tag = indexPath.row
        cell.contractLab.addOnClickListener(target: self, action: #selector(onClickedContract(sender:)))
        
        cell.expressListLab.tag = indexPath.row
        cell.expressListLab.addOnClickListener(target: self, action: #selector(onClickedExpress(sender:)))
        cell.payCertLab.tag = indexPath.row
        cell.payCertLab.addOnClickListener(target: self, action: #selector(onClickedpayCertLab(sender:)))
        
        
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
