//
//  JSMNeedDetailVC.swift
//  JSMachine
//  竞标需求详情
//  Created by gouyz on 2019/4/9.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let needDetailCell = "needDetailCell"
private let needDetailUserHeader = "needDetailUserHeader"

class JSMNeedDetailVC: GYZBaseVC {

    var needId : String = ""
    var detailModel: JSMNeedModel?
    /// 是否是客户登录
    var isUser: Bool = true
    /// 选择时间戳
    var selectTime: Int = 0
    var biddingPrices : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "需求详情"
        
        view.addSubview(submitBtn)
        view.addSubview(tableView)
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-20)
            make.height.equalTo(kUIButtonHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(submitBtn.snp.top).offset(-20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
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
        
        table.register(JSMNeedDetailCell.self, forCellReuseIdentifier: needDetailCell)
        table.register(JSMNeedDetailUserHeaderView.self, forHeaderFooterViewReuseIdentifier: needDetailUserHeader)
        
        return table
    }()
    /// 提交按钮
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("竞标", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        
        return btn
    }()
    /// 提交
    @objc func onClickedSubmitBtn(){
        if !isUser {/// 工程师和网点没有权限
            MBProgressHUD.showAutoDismissHUD(message: "请使用用户身份登录")
            return
        }
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            goLogin()
        }else{
            let biddingView = JSMSubmitBiddingView.init(model: detailModel!)
            biddingView.didSubmitBlock = {[weak self] (prices,time) in
                self?.biddingPrices = prices
                self?.selectTime = time
                self?.requestSubmitDatas()
            }
        }
    }
    ///获取详情数据
    func requestProductDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/bidDetials",parameters: ["id":needId],  success: { (response) in
            
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
    /// 登录
    func goLogin(){
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///竞价提交
    func requestSubmitDatas(){

        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        createHUD(message: "加载中...")

        GYZNetWork.requestNetwork("second/bid",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","need_id":needId,"price": biddingPrices,"time":selectTime],  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.clickedBackBtn()

            }

        }, failture: { (error) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }

}

extension JSMNeedDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailModel != nil {
            return (detailModel?.needProductsModels.count)! + 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: needDetailCell) as! JSMNeedDetailCell
        
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
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: needDetailUserHeader) as! JSMNeedDetailUserHeaderView
        
        if detailModel != nil{
            headerView.iconView.kf.setImage(with: URL.init(string: (detailModel?.n_head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
            headerView.useNameLab.text = detailModel?.n_nickname
            headerView.dateLab.text = detailModel?.create_date?.getDateTime(format: "yyyy/MM/dd")
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return kMargin
        }
        return 0.00001
    }
}
