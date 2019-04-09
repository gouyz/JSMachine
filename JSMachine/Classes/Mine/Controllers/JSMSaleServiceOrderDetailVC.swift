//
//  JSMSaleServiceOrderDetailVC.swift
//  JSMachine
//  售后服务详情
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let saleServiceDetailCell = "saleServiceDetailCell"
private let saleServiceDetailHeader = "saleServiceDetailHeader"
private let saleServiceDetailStepCell = "saleServiceDetailStepCell"

class JSMSaleServiceOrderDetailVC: GYZBaseVC {
    
    let titleArr: [String] = ["进度","联系人","公司地址","故障详情","备注"]
    var applyId: String = ""
    var dataModel: JSMSaleServiceOrderModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "申请详情"
        
        view.addSubview(bottomView)
        view.addSubview(tableView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        bottomView.operatorBlock = {[weak self](tag) in
            if tag == 1 {//电话联系
                GYZTool.callPhone(phone: (self?.dataModel?.w_phone)!)
            }else{
                self?.goWebViewVC(title: "在线联系")
            }
        }
        
        requestDetailData()
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
//        table.estimatedRowHeight = 100
//        // 设置行高为自动适配
//        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(GYZCommonInfoCell.self, forCellReuseIdentifier: saleServiceDetailCell)
        table.register(JSMSaleServiceDetailHeader.self, forHeaderFooterViewReuseIdentifier: saleServiceDetailHeader)
        table.register(JSMSaleServiceDetailStepCell.self, forCellReuseIdentifier: saleServiceDetailStepCell)
        
        return table
    }()
    
    lazy var bottomView: JSMSaleServiceDetailBottomView = JSMSaleServiceDetailBottomView()
    
    /// 获取详情 数据
    func requestDetailData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/detailApply", parameters: ["id": applyId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = JSMSaleServiceOrderModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// webVC
    func goWebViewVC(title: String){
        let vc = JSMWebViewVC()
        vc.url = "http://jsj.0519app.com/service.html"
        vc.webTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
            if dataModel != nil{
                var index = Int.init((dataModel?.status)!)
                if index > 3{
                    index = 3
                }
                cell.stepView.selectedIndex = index!
            }
            
            cell.stepView.auditTitles = ["提交申请", "分配工程师", "上门维修", "维修完成"]
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceDetailCell) as! GYZCommonInfoCell
            
            if dataModel != nil{
                var titleStr: String = ""
                var contentStr: String = ""
                if indexPath.section == 1 {
                    if indexPath.row == 0{
                        titleStr = "姓名："
                        contentStr = (dataModel?.a_name)!
                    }else{
                        titleStr = "电话："
                        contentStr = (dataModel?.a_phone)!
                    }
                }else if indexPath.section == 2 {
                    if indexPath.row == 0{
                        titleStr = "公司地址："
                        contentStr = (dataModel?.c_address)!
                    }else{
                        titleStr = "具体地址："
                        contentStr = (dataModel?.s_address)!
                    }
                }else if indexPath.section == 3 {
                    if indexPath.row == 0{
                        titleStr = "机械型号："
                        contentStr = (dataModel?.model)!
                    }else if indexPath.row == 1{
                        titleStr = "故障原因："
                        contentStr = (dataModel?.f_reason)!
                    }else{
                        titleStr = "申请配件："
                        contentStr = dataModel?.a_part == "0" ? "否" : "是"
                    }
                }else if indexPath.section == 4 {
                    titleStr = "备注说明："
                    contentStr = (dataModel?.a_remark)!
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
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: saleServiceDetailHeader) as! JSMSaleServiceDetailHeader
        
        headerView.nameLab.text = titleArr[section]
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
