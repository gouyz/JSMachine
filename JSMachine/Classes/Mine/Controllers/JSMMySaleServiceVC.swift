//
//  JSMMySaleServiceVC.swift
//  JSMachine
//  我的售后
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let saleServiceCell = "saleServiceCell"
private let saleServiceHeader = "saleServiceHeader"
private let saleServiceFooter = "saleServiceFooter"

class JSMMySaleServiceVC: GYZBaseVC {
    
    var dataModel: JSMMySaleServiceModel?
    var isShowMore: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "售后申请"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_service_kefu")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedKeFuBtn))
        
        view.addSubview(applyBtn)
        view.addSubview(tableView)
        applyBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(applyBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        tableView.tableHeaderView = headerView
        headerView.operatorBlock = {[weak self] (tag) in
            self?.dealOperator(index: tag)
        }
        requestApplyDatas()
    }
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(GYZLabArrowCell.self, forCellReuseIdentifier: saleServiceCell)
        table.register(LHSGeneralHeaderView.self, forHeaderFooterViewReuseIdentifier: saleServiceHeader)
        table.register(JSMMySaleServiceFooterView.self, forHeaderFooterViewReuseIdentifier: saleServiceFooter)
        
        return table
    }()
    /// 申请售后服务按钮
    lazy var applyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("申请售后服务", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedApplyBtn), for: .touchUpInside)
        
        return btn
    }()
    lazy var headerView: JSMMySaleServiceHeaderView = JSMMySaleServiceHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100 + kTitleHeight))
    
    ///获取申请售后数据
    func requestApplyDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/indexApply",parameters: ["user_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = JSMMySaleServiceModel.init(dict: data)
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
            
            headerView.dealingView.menuImg.badgeView.text = dataModel?.handingNum
            headerView.dealingView.menuImg.showBadge(animated: false)
            headerView.dealedView.menuImg.badgeView.text = dataModel?.handedNum
            headerView.dealedView.menuImg.showBadge(animated: false)
            
            tableView.reloadData()
        }
    }
    
    /// 客服
    @objc func clickedKeFuBtn(){
        
    }
    /// 申请售后服务
    @objc func clickedApplyBtn(){
        let vc = JSMApplyServiceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 售后服务
    func dealOperator(index : Int){
        let vc = JSMDealSaleServiceOrderVC()
        if index == 2 {
            vc.isDealing = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 更多
    @objc func onClickedShowMore(){
        isShowMore = true
        tableView.reloadData()
    }
}
extension JSMMySaleServiceVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataModel != nil {
            if dataModel?.problemModels.count > 5 && !isShowMore{
                return 5
            }else{
                return (dataModel?.problemModels.count)!
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceCell) as! GYZLabArrowCell
        
        cell.nameLab.text = dataModel?.problemModels[indexPath.row].title
        cell.nameLab.textColor = kBlueFontColor
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: saleServiceHeader) as! LHSGeneralHeaderView
        
        headerView.nameLab.text = "常见问题"
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if isShowMore {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: saleServiceFooter) as! JSMMySaleServiceFooterView
            
            footerView.addOnClickListener(target: self, action: #selector(onClickedShowMore))
            
            return footerView
        }
        return UIView()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isShowMore {
            return 34
        }
        return 0
    }
}
