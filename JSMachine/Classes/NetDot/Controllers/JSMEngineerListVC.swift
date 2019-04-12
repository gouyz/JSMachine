//
//  JSMEngineerListVC.swift
//  JSMachine
//  网点工程师列表
//  Created by gouyz on 2019/4/12.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let engineerListCell = "engineerListCell"

class JSMEngineerListVC: GYZBaseVC {
    
    var dataList: [JSMEngineerModel] = [JSMEngineerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "工程师"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("添加", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickedAddBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestEngineerDatas()
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
        
        table.register(JSMEngineerListCell.self, forCellReuseIdentifier: engineerListCell)
        
        return table
    }()
    ///获取工程师列表数据
    func requestEngineerDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("second/engineerList",parameters: ["d_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                weakSelf?.dataList.removeAll()
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMEngineerModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无工程师信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestEngineerDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 离职
    @objc func onClickedOperator(sender: UITapGestureRecognizer){
        
        let tag:Int = (sender.view?.tag)!
        leaveAlert(model: dataList[tag], row: tag)
    }
    //离职
    func leaveAlert(model: JSMEngineerModel,row: Int){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确认员工 \(model.real_name!) 离职吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestLiZhiDatas(engineerId: model.id!, row: row)
            }
        }
    }
    
    ///离职
    func requestLiZhiDatas(engineerId: String,row:Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/leave",parameters: ["d_id":userDefaults.string(forKey: "userId") ?? "","e_id":engineerId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dataList.remove(at: row)
                
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 添加工程师
    @objc func onClickedAddBtn(){
        let vc = JSMAddEngineerVC()
        vc.resultBlock = {[weak self] () in
            self?.requestEngineerDatas()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension JSMEngineerListVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: engineerListCell) as! JSMEngineerListCell
        
        cell.dataModel = dataList[indexPath.row]
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
