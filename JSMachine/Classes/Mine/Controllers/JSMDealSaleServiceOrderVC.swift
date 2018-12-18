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
    
    /// 订单详情
    func goDetailVC(){
        let vc = JSMSaleServiceOrderDetailVC()
        navigationController?.pushViewController(vc, animated: true)
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
        
        if orderStatus == "1" {
            cell.statusNameLab.backgroundColor = UIColor.ColorHex("#a4a8b8")
            cell.statusNameLab.text = "处理中"
            cell.operatorLab.isHidden = true
            cell.operatorLab.snp.updateConstraints { (make) in
                make.right.equalTo(-1)
                make.width.equalTo(0)
            }
        }else{
            cell.statusNameLab.backgroundColor = kRedFontColor
            cell.statusNameLab.text = "已处理"
            cell.operatorLab.isHidden = false
            cell.operatorLab.snp.updateConstraints { (make) in
                make.right.equalTo(-kMargin)
                make.width.equalTo(60)
            }
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
        goDetailVC()
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
