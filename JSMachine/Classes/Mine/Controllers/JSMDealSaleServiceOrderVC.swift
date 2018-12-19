//
//  JSMDealSaleServiceOrderVC.swift
//  JSMachine
//  处理售后服务
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let saleServiceOrderCell = "saleServiceOrderCell"

class JSMDealSaleServiceOrderVC: GYZBaseVC {

    var currPage : Int = 1
    var orderStatus: String = ""
    var dataList: [JSMSaleServiceOrderModel] = [JSMSaleServiceOrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if orderStatus == "1" {
            self.navigationItem.title = "处理中"
        }else if orderStatus == "2"{
            self.navigationItem.title = "已处理"
        }else if orderStatus == "0"{
            self.navigationItem.title = "所有申请"
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestServiceDatas()
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
        table.estimatedRowHeight = 210
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        table.register(JSMSaleServiceOrderCell.self, forCellReuseIdentifier: saleServiceOrderCell)
        
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
    
    ///获取售后d申请列表数据
    func requestServiceDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        var method: String = "my/handingApply"
        if orderStatus == "2" {
            method = "my/handledApply"
        }else if orderStatus == "0"{
            method = "my/allApply"
        }
        
        GYZNetWork.requestNetwork(method,parameters: ["user_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMSaleServiceOrderModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无售后申请信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestServiceDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 删除
    @objc func onClickedDelete(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "删除", message: "确定要删除该售后申请吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestDelete(rowIndex: tag!)
            }
        }
    }
    /// 查看详情
    @objc func onClickedDetail(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = JSMSaleServiceOrderDetailVC()
        vc.applyId = dataList[tag!].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 维修记录
    @objc func onClickedRecord(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = JSMSaleServiceRecordVC()
        vc.applyId = dataList[tag!].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 评价
    @objc func onClickedConment(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        if model.is_pj == "0" {//未评价
            goConmentVC(id: model.id!,row: tag!,isConment: false)
        }else{//  已评价
            goConmentVC(id: model.id!,row: tag!,isConment: true)
        }
    }
    /// 评价
    func goConmentVC(id: String,row: Int,isConment: Bool){
        let vc = JSMSaleServiceConmentVC()
        vc.orderId = id
        vc.isConment = isConment
        if !isConment {
            vc.resultBlock = {[weak self] () in
                self?.dataList[row].is_pj = "1"
                self?.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 删除申请
    func requestDelete(rowIndex: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/delApply", parameters: ["id": dataList[rowIndex].id ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dataList.remove(at: rowIndex)
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count == 0{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无售后申请信息")
                }
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension JSMDealSaleServiceOrderVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceOrderCell) as! JSMSaleServiceOrderCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.deleteLab.tag = indexPath.row
        cell.deleteLab.addOnClickListener(target: self, action: #selector(onClickedDelete(sender:)))
        cell.detailLab.tag = indexPath.row
        cell.detailLab.addOnClickListener(target: self, action: #selector(onClickedDetail(sender:)))
        cell.recordLab.tag = indexPath.row
        cell.recordLab.addOnClickListener(target: self, action: #selector(onClickedRecord(sender:)))
        cell.operatorLab.tag = indexPath.row
        cell.operatorLab.addOnClickListener(target: self, action: #selector(onClickedConment(sender:)))
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    ///MARK : UITableViewDelegate
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 210
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
