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
        
        if orderStatus == "1" {
            cell.downLoadBtn.isHidden = false
            cell.operatorLab.isHidden = true
            cell.contractLab.text = "上传合同"
        }else if orderStatus == "2" {
            cell.downLoadBtn.isHidden = true
            cell.operatorLab.isHidden = true
            cell.contractLab.text = "查看合同"
        }else {
            cell.downLoadBtn.isHidden = true
            cell.operatorLab.isHidden = false
            cell.contractLab.text = "查看合同"
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
