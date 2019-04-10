//
//  JSMBiddingDetailVC.swift
//  JSMachine
//  竞标详情
//  Created by gouyz on 2019/4/10.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let biddingDetailCell = "biddingDetailCell"
private let biddingDetailInfoCell = "biddingDetailInfoCell"
private let biddingDetailImgCell = "biddingDetailImgCell"
private let biddingDetailUserHeader = "biddingDetailUserHeader"
private let biddingDetailInfoHeader = "biddingDetailInfoHeader"


class JSMBiddingDetailVC: GYZBaseVC {

    var needId : String = ""
    var detailModel: JSMNeedModel?
    let titleArr: [String] = ["中标者","竞标价","预发货日期","联系电话"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "竞标详情"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestProductDatas()
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        // 设置大概高度
        table.estimatedRowHeight = 120
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(JSMNeedDetailCell.self, forCellReuseIdentifier: biddingDetailCell)
        table.register(GYZLabAndFieldCell.self, forCellReuseIdentifier: biddingDetailInfoCell)
        table.register(JSMBiddingDetailImgCell.self, forCellReuseIdentifier: biddingDetailImgCell)
        table.register(JSMNeedDetailUserHeaderView.self, forHeaderFooterViewReuseIdentifier: biddingDetailUserHeader)
        table.register(JSMNeedDetailInfoHeader.self, forHeaderFooterViewReuseIdentifier: biddingDetailInfoHeader)
        
        return table
    }()
    ///获取详情数据
    func requestProductDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/biddingDetails",parameters: ["id":needId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.detailModel = JSMNeedModel.init(dict: data)
                weakSelf?.tableView.reloadData()
                
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

extension JSMBiddingDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if detailModel != nil {
            let status = detailModel?.status
            if status == "4" || status == "5" || status == "6" || status == "7"{
                return 3
            }else if status == "0"{
                return 1
            }
        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 4
        }else if section == 0 {
            if detailModel != nil {
                return (detailModel?.needProductsModels.count)! + 1
            }else{
                return 0
            }
        }else{
            if detailModel != nil {
                let status = detailModel?.status
                if status == "4" || status == "5" || status == "7"{
                    return 2
                }else if status == "6"{
                    return 1
                }
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: biddingDetailCell) as! JSMNeedDetailCell
            
            if indexPath.row == detailModel?.needProductsModels.count {// 交货日期
                cell.typeLab.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
                cell.typeLab.isHidden = true
                cell.numberLab.isHidden = true
                cell.noteLab.text = "交货日期：" + (detailModel?.deal_date?.getDateTime(format: "yyyy-MM-dd"))!
            }else{
                cell.typeLab.snp.updateConstraints { (make) in
                    make.height.equalTo(30)
                }
                cell.typeLab.isHidden = false
                cell.numberLab.isHidden = false
                let model = detailModel?.needProductsModels[indexPath.row]
                cell.typeLab.text = "产品型号：" + (model?.pro_model)!
                cell.numberLab.text = "产品数量：" + (model?.num)!
                cell.noteLab.text = "用户备注：" + (model?.remark)!
            }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: biddingDetailInfoCell) as! GYZLabAndFieldCell
            
            cell.textFiled.isEnabled = false
            cell.desLab.text = titleArr[indexPath.row]
            cell.desLab.textColor = kHeightGaryFontColor
            if detailModel != nil{
                if indexPath.row == 0 {
                    cell.textFiled.text = detailModel?.nickname
                }else if indexPath.row == 1{
                    cell.textFiled.text = "￥" + (detailModel?.price)!
                }else if indexPath.row == 2{
                    cell.textFiled.text = detailModel?.time?.getDateTime(format: "yyyy-MM-dd")
                }else if indexPath.row == 3{
                    cell.textFiled.text = detailModel?.phone
                }
            }
            
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: biddingDetailImgCell) as! JSMBiddingDetailImgCell
            
            if detailModel != nil{
                if indexPath.row == 0 {
                    cell.iconView.kf.setImage(with: URL.init(string: (detailModel?.pay_voucher)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                }else if indexPath.row == 1{
                    cell.iconView.kf.setImage(with: URL.init(string: (detailModel?.wl_list)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: biddingDetailUserHeader) as! JSMNeedDetailUserHeaderView
            
            if detailModel != nil{
                headerView.iconView.kf.setImage(with: URL.init(string: (detailModel?.n_head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
                headerView.useNameLab.text = detailModel?.n_nickname
                headerView.dateLab.text = detailModel?.create_date?.getDateTime(format: "yyyy/MM/dd")
            }
            
            return headerView
        }else if section == 1{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: biddingDetailInfoHeader) as! JSMNeedDetailInfoHeader
            
            return headerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0{
                goBigPhotos(index: 0, urls: [(detailModel?.pay_voucher)!])
            }else{
                goBigPhotos(index: 0, urls: [(detailModel?.wl_list)!])
            }
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 1 {
            return 0.00001
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return kMargin
        }
        return 0.00001
    }
}
