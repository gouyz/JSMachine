//
//  JSMMyPublishNeedVC.swift
//  JSMachine
//  我的发布
//  Created by gouyz on 2018/11/28.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myPublishNeedCell = "myPublishNeedCell"

class JSMMyPublishNeedVC: GYZBaseVC {

    /// 选择合同
    var selectContractImg: UIImage?
    var orderStatus: String = ""
    var currPage : Int = 1
    var dataList: [JSMPublishNeedModel] = [JSMPublishNeedModel]()
    
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
    
    /// 订单详情
//    func goDetailVC(){
//        let vc = JSMOrderDetailVC()
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    ///获取我的发布列表数据
    func requestPublishOrderDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("need/myNeed",parameters: ["user_id": userDefaults.string(forKey: "userId") ?? "","type": orderStatus],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
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
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestPublishOrderDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 推荐商品
    @objc func onClickedTuiJianGoods(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = JSMTuiJianGoodsVC()
        vc.speed = dataList[tag!].pro_speed!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 下载合同
    @objc func onClickedDownContract(sender: UIButton){
        
    }
    /// 查看合同、上传合同
    @objc func onClickedContract(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataList[tag]
        let status: String = model.status!
        if status == "1" {//上传合同
            selectImg(model: model)
        }else{// 查看合同
            
        }
    }
    /// 确认收货
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        requestSureGoods(model: dataList[tag], rowIndex: tag)
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
    func selectImg(model: JSMPublishNeedModel){
        
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: false, finished: { [weak self] (image) in
            
            self?.selectContractImg = image
            self?.requestUpdateContract(model: model)
        })
    }
    /// 上传合同
    func requestUpdateContract(model: JSMPublishNeedModel){
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
            showEmptyView(content: "暂无发布需求信息")
        }
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
        
        cell.dataModel = dataList[indexPath.row]
        cell.tuiJianLab.tag = indexPath.row
        cell.tuiJianLab.addOnClickListener(target: self, action: #selector(onClickedTuiJianGoods(sender:)))
        cell.downLoadBtn.tag = indexPath.row
        cell.downLoadBtn.addTarget(self, action: #selector(onClickedDownContract(sender:)), for: .touchUpInside)
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
//        goDetailVC()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
