//
//  JSMSaleServiceOrderDetailVC.swift
//  JSMachine
//  售后服务详情
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

private let saleServiceDetailCell = "saleServiceDetailCell"
private let saleServiceDetailHeader = "saleServiceDetailHeader"
private let saleServiceDetailStepCell = "saleServiceDetailStepCell"

class JSMSaleServiceOrderDetailVC: GYZBaseVC {
    
    let titleArr: [String] = ["进度","联系人","公司地址","故障详情","备注"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "申请详情"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
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
        table.estimatedRowHeight = 50
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(GYZCommonInfoCell.self, forCellReuseIdentifier: saleServiceDetailCell)
        table.register(JSMSaleServiceDetailHeader.self, forHeaderFooterViewReuseIdentifier: saleServiceDetailHeader)
        table.register(JSMSaleServiceDetailStepCell.self, forCellReuseIdentifier: saleServiceDetailStepCell)
        
        return table
    }()
}
extension JSMSaleServiceOrderDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if section == 3 {
            return 3
        }else if section == 4 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceDetailStepCell) as! JSMSaleServiceDetailStepCell
            
            cell.stepView.auditTitles = ["提交申请", "分配工程师", "上门维修", "维修完成"]
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceDetailCell) as! GYZCommonInfoCell
            var titleStr: String = ""
            var contentStr: String = ""
            if indexPath.section == 1 {
                if indexPath.row == 0{
                    titleStr = "姓名："
                    contentStr = "陈辉"
                }else{
                    titleStr = "电话："
                    contentStr = "13812345678"
                }
            }else if indexPath.section == 2 {
                if indexPath.row == 0{
                    titleStr = "公司地址："
                    contentStr = "常州市"
                }else{
                    titleStr = "具体地址："
                    contentStr = "1111室"
                }
            }else if indexPath.section == 3 {
                if indexPath.row == 0{
                    titleStr = "机械型号："
                    contentStr = "KRV-121-B"
                }else if indexPath.row == 1{
                    titleStr = "故障原因："
                    contentStr = "减速机传动失效"
                }else{
                    titleStr = "申请配件："
                    contentStr = "自购配件"
                }
            }else if indexPath.section == 4 {
                titleStr = "备注说明："
                contentStr = "减速机传动失效减速机传动失效减速机传动失效减速机传动失效减速机传动失效减速机传动失效"
            }
            cell.titleLab.text = titleStr
            cell.titleLab.textColor = kHeightGaryFontColor
            cell.titleLab.snp.updateConstraints { (make) in
                make.width.equalTo(80)
            }
            cell.contentLab.text = contentStr
            cell.contentLab.textAlignment = .left
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: saleServiceDetailHeader) as! JSMSaleServiceDetailHeader
        
        headerView.nameLab.text = titleArr[section]
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
