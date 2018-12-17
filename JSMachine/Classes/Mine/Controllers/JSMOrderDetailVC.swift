//
//  JSMOrderDetailVC.swift
//  JSMachine
//  订单详情
//  Created by gouyz on 2018/11/27.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let orderDetailCell = "orderDetailCell"
private let orderDetailHeader = "orderDetailHeader"

class JSMOrderDetailVC: GYZBaseVC {
    
    let titleArr: [String] = ["产品型号：","产品转速：","传动比：","交货期：","备注："]
    var infoArr: [String] = [String]()
    var orderCode: String = ""
    var dataModel: JSMOrderModel?

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
        requestOrderDetailData()
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
    
    /// 获取订单详情 数据
    func requestOrderDetailData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/orderDetail", parameters: ["code": orderCode],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = JSMOrderModel.init(dict: data)

                weakSelf?.setData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func setData(){
        if dataModel != nil {
            if dataModel?.status == "0" || dataModel?.status == "1"{
                contractBtn.isHidden = true
                contractBtn.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }
            infoArr.append((dataModel?.pro_model)!)
            infoArr.append((dataModel?.pro_speed)!)
            infoArr.append((dataModel?.drive_ratio)!)
            infoArr.append((dataModel?.t_data?.getDateTime(format: "yyyy-MM-dd"))!)
            infoArr.append((dataModel?.remark)!)
            tableView.reloadData()
        }
    }
    
    /// 查看合同
    @objc func clickedContractBtn(){
        requestGetContractUrl()
    }
    
    /// 查看合同
    func requestGetContractUrl(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/see", parameters: ["code": orderCode],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.goBigPhotos(index: 0, urls: [response["data"]["pic"].stringValue])
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 查看合同
    ///
    /// - Parameters:
    ///   - index: 索引
    ///   - urls: 图片路径
    func goBigPhotos(index: Int, urls: [String]){
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: urls))
        browser.initializePageIndex(index)
        //        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
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
        if dataModel != nil {
            cell.contentLab.text = infoArr[indexPath.row]
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderDetailHeader) as! JSMOrderDetailHeaderView
        
        headerView.dataModel = dataModel
        
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
