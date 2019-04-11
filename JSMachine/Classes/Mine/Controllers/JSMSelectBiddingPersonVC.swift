//
//  JSMSelectBiddingPersonVC.swift
//  JSMachine
//  选择竞标者
//  Created by gouyz on 2019/4/11.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let selectBiddingPersonCell = "selectBiddingPersonCell"

class JSMSelectBiddingPersonVC: GYZBaseVC {

    /// 选择结果回调
    var resultBlock:((_ name: String) -> Void)?
    var dataModel: JSMBiddingPersonModel?
    var needId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "竞标者"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestJingBiaoDatas()
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        // 设置大概高度
        table.estimatedRowHeight = 200
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(JSMBidderCell.self, forCellReuseIdentifier: selectBiddingPersonCell)
        
        return table
    }()
    ///获取竞标中列表数据
    func requestJingBiaoDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("second/bidderIndex",parameters: ["id":needId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = JSMBiddingPersonModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataModel?.personList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无竞标者信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestJingBiaoDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 招标
    @objc func onClickedBidding(sender: UITapGestureRecognizer){
        let tag: Int = (sender.view?.tag)!
        let model = dataModel?.personList[tag]
        biddingAlert(model: model!)
    }
    //招标
    func biddingAlert(model: JSMBiddingPersonDataModel){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确认要招标吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestBidder(model: model)
            }
        }
    }
    
    /// 招标
    func requestBidder(model: JSMBiddingPersonDataModel){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/tendering", parameters: ["id": needId,"b_id": model.b_id!,"bidder_id": model.bidder_id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                if weakSelf?.resultBlock != nil {
                    weakSelf?.resultBlock!(model.nickname!)
                }
                weakSelf?.clickedBackBtn()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension JSMSelectBiddingPersonVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel == nil ? 0 : (dataModel?.personList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: selectBiddingPersonCell) as! JSMBidderCell
        
        cell.dataModel = dataModel?.personList[indexPath.row]
        cell.operatorLab.tag = indexPath.row
        cell.operatorLab.addOnClickListener(target: self, action: #selector(onClickedBidding(sender:)))
        
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
