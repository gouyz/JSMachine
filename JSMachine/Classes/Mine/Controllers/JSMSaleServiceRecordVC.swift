//
//  JSMSaleServiceRecordVC.swift
//  JSMachine
//  售后维修记录
//  Created by gouyz on 2018/12/19.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let saleServiceRecordCell = "saleServiceRecordCell"
private let saleServiceRecordImgsCell = "saleServiceRecordImgsCell"
private let saleServiceRecordHeader = "saleServiceRecordHeader"

class JSMSaleServiceRecordVC: GYZBaseVC {

    let titleArr: [String] = ["故障详情","维修备注"]
    var applyId: String = ""
    
    var dataModel: JSMSaleServiceRecordModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "维修记录"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestDetailData()
    }
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        // 设置大概高度
        table.estimatedRowHeight = 50
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(GYZCommonInfoCell.self, forCellReuseIdentifier: saleServiceRecordCell)
        table.register(JSMServiceRecordImgsCell.self, forCellReuseIdentifier: saleServiceRecordImgsCell)
        table.register(JSMSaleServiceDetailHeader.self, forHeaderFooterViewReuseIdentifier: saleServiceRecordHeader)
        
        return table
    }()
    
    /// 获取详情 数据
    func requestDetailData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("engineer/submitlAllot", parameters: ["id": applyId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = JSMSaleServiceRecordModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension JSMSaleServiceRecordVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceRecordImgsCell) as! JSMServiceRecordImgsCell
            if dataModel != nil{
                cell.dataModel = dataModel?.imgList
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceRecordCell) as! GYZCommonInfoCell
            
            if dataModel != nil{
                var titleStr: String = ""
                var contentStr: String = ""
                if indexPath.section == 0 {
                    if indexPath.row == 0{
                        titleStr = "机械型号："
                        contentStr = (dataModel?.w_model)!
                    }else if indexPath.row == 1{
                        titleStr = "故障原因："
                        contentStr = (dataModel?.w_reason)!
                    }
                }else if indexPath.section == 1 {
                    titleStr = "备注说明："
                    contentStr = (dataModel?.w_remark)!
                }
                cell.titleLab.text = titleStr
                cell.titleLab.textColor = kHeightGaryFontColor
                cell.titleLab.snp.updateConstraints { (make) in
                    make.width.equalTo(80)
                }
                cell.contentLab.text = contentStr
                cell.contentLab.textAlignment = .left
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: saleServiceRecordHeader) as! JSMSaleServiceDetailHeader
        
        headerView.nameLab.text = titleArr[section]
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
