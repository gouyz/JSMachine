//
//  JSMOrderDetailVC.swift
//  JSMachine
//  订单详情
//  Created by gouyz on 2018/11/27.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let orderDetailCell = "orderDetailCell"
private let orderDetailHeader = "orderDetailHeader"

class JSMOrderDetailVC: GYZBaseVC {
    
    let titleArr: [String] = ["产品型号：","产品转速：","传动比：","交货期：","备注："]
    let infoArr: [String] = ["ZSY160","700R/min","22.4","2018-11-27","无"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "订单详情"
        
        view.addSubview(contractBtn)
        view.addSubview(tableView)
        contractBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(contractBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
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
        table.backgroundColor = kWhiteColor
        
        // 设置大概高度
        table.estimatedRowHeight = kTitleHeight
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(GYZCommonInfoCell.self, forCellReuseIdentifier: orderDetailCell)
        table.register(JSMOrderDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: orderDetailHeader)
        
        return table
    }()
    
    /// 查看合同按钮
    lazy var contractBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("查看合同", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedContractBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 查看合同
    @objc func clickedContractBtn(){
        
    }
}

extension JSMOrderDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: orderDetailCell) as! GYZCommonInfoCell
        
        cell.contentLab.textAlignment = .left
        cell.contentLab.font = k15Font
        cell.lineView.isHidden = true
        
        cell.titleLab.text = titleArr[indexPath.row]
        cell.contentLab.text = infoArr[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderDetailHeader) as! JSMOrderDetailHeaderView
        
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight + 100 + klineDoubleWidth
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
