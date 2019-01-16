//
//  JSMEngineerOrderVC.swift
//  JSMachine
//  工程师处理订单
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let engineerOrderCell = "engineerOrderCell"

class JSMEngineerOrderVC: GYZBaseVC {

    var currPage : Int = 1
    var orderStatus: String = ""
    var dataList: [JSMSaleServiceOrderModel] = [JSMSaleServiceOrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
//        if !userDefaults.bool(forKey: kIsEngineerLoginTagKey) {
//            dataList.removeAll()
//            tableView.reloadData()
//            refresh()
//        }
        dataList.removeAll()
        tableView.reloadData()
        refresh()
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
        
        table.register(JSMSaleServiceOrderCell.self, forCellReuseIdentifier: engineerOrderCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
        
        return table
    }()
    
    ///获取售后d申请列表数据
    func requestServiceDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("engineer/allot",parameters: ["engineer_id": userDefaults.string(forKey: "userId") ?? "","type":orderStatus],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
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
            weakSelf?.closeRefresh()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestServiceDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
        requestServiceDatas()
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
    
    /// 查看详情
    @objc func onClickedDetail(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = JSMEngineerOrderDetailVC()
        vc.applyId = dataList[tag!].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 维修记录
    @objc func onClickedRecord(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let vc = JSMSaleServiceRecordListVC()
        vc.applyId = dataList[tag!].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 处理、完成、看评价
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        let status: String = model.status!
        if status == "1" {/// 处理
            requestDealOrder(rowIndex: tag!)
        }else if status == "2" {/// 完成
            goFinishedVC(id: model.id!, row: tag!)
        }else{/// 看评价
            goConmentVC(id: model.id!)
        }
    }
    /// 看评价
    func goConmentVC(id: String){
        let vc = JSMConmentDetailVC()
        vc.orderId = id
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 完成
    func goFinishedVC(id: String,row: Int){
        let vc = JSMSaleServiceRecordListVC()
        vc.applyId = id
        vc.resultBlock = {[weak self] (finished) in
            if finished {
                self?.dataList[row].status = "3"
                self?.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
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
    /// 删除申请
    func requestDelete(rowIndex: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("engineer/delAllot", parameters: ["id": dataList[rowIndex].id ?? ""],  success: { (response) in
            
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
    
    /// 处理
    func requestDealOrder(rowIndex: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("engineer/dealAllot", parameters: ["id": dataList[rowIndex].id ?? ""],  success: { (response) in
            
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

extension JSMEngineerOrderVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: engineerOrderCell) as! JSMSaleServiceOrderCell
        
        cell.dataModelEngineer = dataList[indexPath.row]
        
        cell.deleteLab.tag = indexPath.row
        cell.deleteLab.addOnClickListener(target: self, action: #selector(onClickedDelete(sender:)))
        cell.detailLab.tag = indexPath.row
        cell.detailLab.addOnClickListener(target: self, action: #selector(onClickedDetail(sender:)))
        cell.recordLab.tag = indexPath.row
        cell.recordLab.addOnClickListener(target: self, action: #selector(onClickedRecord(sender:)))
        cell.operatorLab.tag = indexPath.row
        cell.operatorLab.addOnClickListener(target: self, action: #selector(onClickedOperator(sender:)))
        
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
