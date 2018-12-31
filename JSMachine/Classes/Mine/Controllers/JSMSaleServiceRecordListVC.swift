//
//  JSMSaleServiceRecordListVC.swift
//  JSMachine
//  维修记录列表
//  Created by gouyz on 2018/12/30.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let saleServiceRecordListCell = "saleServiceRecordListCell"

class JSMSaleServiceRecordListVC: GYZBaseVC {
    
    var applyId: String = ""
    var dataModel: JSMSaleServiceRecordListModel?
    /// 选择结果回调
    var resultBlock:((_ isFinished: Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "维修记录"
        
        view.addSubview(finishedBtn)
        view.addSubview(tableView)
        finishedBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(finishedBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        requestDetailData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        // 设置大概高度
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(JSMRecordListCell.self, forCellReuseIdentifier: saleServiceRecordListCell)
        
        return table
    }()
    
    /// 完成按钮
    lazy var finishedBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("添加维修记录", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedAddRecordBtn), for: .touchUpInside)
        
        return btn
    }()
    override func clickedBackBtn() {
        if resultBlock != nil {
            resultBlock!(dataModel?.status != "2")
        }
        super.clickedBackBtn()
    }
    /// 获取详情 数据
    func requestDetailData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("engineer/lookRecord", parameters: ["id": applyId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = JSMSaleServiceRecordListModel.init(dict: data)
                weakSelf?.dealData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 添加维修记录
    @objc func clickedAddRecordBtn(){
        let vc = JSMEngineerFinishedVC()
        vc.orderId = applyId
        vc.resultBlock = {[weak self] () in
            self?.requestDetailData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func dealData(){
        if dataModel != nil {
            if dataModel?.status == "2"{// 未完成
                if userDefaults.bool(forKey: kIsEngineerLoginTagKey){//工程师登录
                    finishedBtn.backgroundColor = kBtnClickBGColor
                    finishedBtn.setTitle("添加维修记录", for: .normal)
                    finishedBtn.isEnabled = true
                }else{
                    finishedBtn.backgroundColor = kBtnNoClickBGColor
                    finishedBtn.setTitle("维修中", for: .normal)
                    finishedBtn.isEnabled = false
                }
            }else{
                finishedBtn.backgroundColor = kBtnNoClickBGColor
                finishedBtn.setTitle("维修已完成", for: .normal)
                finishedBtn.isEnabled = false
            }
            
            tableView.reloadData()
        }
    }
    
    func goDetail(index: Int ){
        let vc = JSMSaleServiceRecordVC()
        vc.applyId = applyId
        vc.listId = (dataModel?.recordList[index].list_id)!
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension JSMSaleServiceRecordListVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataModel != nil {
            return (dataModel?.recordList.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceRecordListCell) as! JSMRecordListCell
        
        let model = dataModel?.recordList[indexPath.row]
        cell.dataModel = model
        
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
        goDetail(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
