//
//  JSMOrderVC.swift
//  JSMachine
//  订单
//  Created by gouyz on 2018/11/25.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let orderCell = "orderCell"

class JSMOrderVC: GYZBaseVC {

    var orderStatus: String = ""
    var currPage : Int = 1
    /// 选择合同
    var selectContractImg: UIImage?
    var dataList: [JSMOrderModel] = [JSMOrderModel]()
    /// 下载合同url
    var downLoadUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestOrderDatas()
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
        
        table.register(JSMOrderCell.self, forCellReuseIdentifier: orderCell)
        
//        weak var weakSelf = self
        ///添加下拉刷新
//        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
//            weakSelf?.refresh()
//        })
        //        ///添加上拉加载更多
        //        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
        //            weakSelf?.loadMore()
        //        })
        return table
    }()
    
    
    ///获取我的订单列表数据
    func requestOrderDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("my/myOrder",parameters: ["user_id": userDefaults.string(forKey: "userId") ?? "","type": orderStatus],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMOrderModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无订单信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestOrderDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 查看合同、上传合同
    @objc func onClickedContract(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataList[tag]
        let status: String = model.status!
        if status == "1" {//上传合同
            selectImg(model: model)
        }else{// 查看合同
            requestGetContractUrl(model: model)
        }
    }
    /// 确认收货、下载合同
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataList[tag]
        let status: String = model.status!
        if status == "4" {//确认收货
            requestSureGoods(model: dataList[tag], rowIndex: tag)
        }else{// 下载合同
            requestGetDownLoadURL()
        }
        
    }
    /// 查看合同
    func requestGetContractUrl(model: JSMOrderModel){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/see", parameters: ["code": model.code ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.goBigPhotos(index: 0, urls: [response["data"]["pic"].stringValue])
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
    func requestSureGoods(model: JSMOrderModel,rowIndex: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/ureceipt", parameters: ["code": model.code ?? ""],  success: { (response) in
            
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
    func selectImg(model: JSMOrderModel){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: false, finished: { [weak self] (image) in
            
            self?.selectContractImg = image
            self?.requestUpdateContract(model: model)
        })
    }
    /// 上传合同
    func requestUpdateContract(model: JSMOrderModel){
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "pic"
        imgParam.fileName = "pic.jpg"
        imgParam.mimeType = "image/jpg"
        imgParam.data = UIImageJPEGRepresentation(selectContractImg!, 0.5)
        
        GYZNetWork.uploadImageRequest("upContract", parameters: ["code": model.code ?? ""], uploadParam: [imgParam], success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            GYZLog(response)
            //            if response["status"].intValue == kQuestSuccessTag{//请求成功
            //
            //            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func dealResult(status: String,rowIndex: Int){
        dataList[rowIndex].status = status
        if orderStatus != "1" {
            if status == "5"{
                dataList.remove(at: rowIndex)
            }
        }
        tableView.reloadData()
        if dataList.count == 0{
            ///显示空页面
            showEmptyView(content: "暂无订单信息")
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
    
    /// 订单详情
    func goDetailVC(model: JSMOrderModel){
        let vc = JSMOrderDetailVC()
        vc.orderCode = model.code!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension JSMOrderVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCell) as! JSMOrderCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.operatorLab.tag = indexPath.row
        cell.operatorLab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
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
        goDetailVC(model: dataList[indexPath.row])
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight * 3 + 90
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
