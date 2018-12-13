//
//  JSMXunJiaVC.swift
//  JSMachine
//  询价
//  Created by gouyz on 2018/12/5.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let xunJiaCell = "xunJiaCell"

class JSMXunJiaVC: GYZBaseVC {
    
    var goodsId : String = ""
    var dataList: [JSMXunJiaModel] = [JSMXunJiaModel]()
    /// 申购参数
    var paramsDic: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "询价"
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
        table.separatorStyle = .none
        
        table.register(JSMXunJiaCell.self, forCellReuseIdentifier: xunJiaCell)
        
        return table
    }()
    ///获取询价列表数据
    func requestProductDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("shop/inquiry",parameters: ["id":goodsId],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMXunJiaModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无商品询价信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestProductDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 申购
    @objc func onClickedBuy(sender:UITapGestureRecognizer){
        let tag = sender.view?.tag
        if tag == 0 {
            return
        }
        showBuy(tag: tag!)
    }
    
    func showBuy(tag: Int){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "申购", message: "确定要申购吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                let model = weakSelf?.dataList[tag - 1]
                weakSelf?.requestSubmitDatas(model: model!)
            }
        }
    }
    
    ///申购提交
    func requestSubmitDatas(model: JSMXunJiaModel){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        paramsDic["shop_id"] = goodsId
        paramsDic["user_id"] = userDefaults.string(forKey: "userId") ?? ""
        paramsDic["price"] = model.price ?? ""
        paramsDic["brand"] = model.title ?? ""
        
        GYZNetWork.requestNetwork("shop/applyBuy",parameters: paramsDic,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.goSuccessVC()
                
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 申购成功
    func goSuccessVC(){
        let vc = JSMPublishSuccessVC()
        vc.isBuy = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JSMXunJiaVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: xunJiaCell) as! JSMXunJiaCell
        
        cell.operatorLab.tag = indexPath.row
        cell.operatorLab.addOnClickListener(target: self, action: #selector(onClickedBuy(sender:)))
        
        if indexPath.row == 0 {
            cell.nameLab.textColor = kBlueFontColor
            cell.nameLab.text = "品牌"
            cell.moneyLab.textColor = kBlueFontColor
            cell.moneyLab.text = "单价"
            cell.operatorLab.textColor = kBlueFontColor
            cell.operatorLab.text = "操作"
            cell.operatorLab.borderColor = kBackgroundColor
        }else{
            let model = dataList[indexPath.row - 1]
            cell.nameLab.textColor = kHeightGaryFontColor
            cell.nameLab.text = model.title
            cell.moneyLab.textColor = kHeightGaryFontColor
            cell.moneyLab.text = "￥\(model.price!)"
            cell.operatorLab.textColor = kRedFontColor
            cell.operatorLab.text = "申购"
            cell.operatorLab.borderColor = kRedFontColor
        }
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = kBackgroundColor
        }else{
            cell.contentView.backgroundColor = kWhiteColor
        }
        
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
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
