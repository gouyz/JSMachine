//
//  JSMOrderVC.swift
//  JSMachine
//  订单
//  Created by gouyz on 2018/11/25.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let orderCell = "orderCell"

class JSMOrderVC: GYZBaseVC {

    var orderStatus: String = ""
    var currPage : Int = 1
    
    var dataList: [JSMOrderModel] = [JSMOrderModel]()
    
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
    
    /// 订单详情
    func goDetailVC(){
        let vc = JSMOrderDetailVC()
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
        
        if orderStatus == "2" {
            cell.statusNameLab.backgroundColor = UIColor.ColorHex("#a4a8b8")
        }else{
            cell.statusNameLab.backgroundColor = kRedFontColor
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
