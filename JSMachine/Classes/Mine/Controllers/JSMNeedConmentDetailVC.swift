//
//  JSMNeedConmentDetailVC.swift
//  JSMachine
//
//  Created by gouyz on 2019/4/11.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SKPhotoBrowser

private let needConmentDetailCell = "needConmentDetailCell"
private let needConmentDetailImgCell = "conmentDetailImgCell"

class JSMNeedConmentDetailVC: GYZBaseVC {
    
    var dataModel: JSMNeedConmentModel?
    var needId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "查看评价"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestJingBiaoDatas()
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        // 设置大概高度
        table.estimatedRowHeight = 200
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(JSMNeedConmentCell.self, forCellReuseIdentifier: needConmentDetailCell)
        table.register(JSMBiddingDetailImgCell.self, forCellReuseIdentifier: needConmentDetailImgCell)
        
        return table
    }()
    ///获取评价数据
    func requestJingBiaoDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/lookEvaluate",parameters: ["id":needId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.dataModel = JSMNeedConmentModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///查看大图
    /// - Parameters:
    ///   - index: 索引
    func goBigPhotos(index: Int){
        let browser = SKPhotoBrowser(photos: GYZTool.createWebPhotos(urls: dataModel?.imgList))
        browser.initializePageIndex(index)
        //        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
}
extension JSMNeedConmentDetailVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return dataModel == nil ? 0 : (dataModel?.imgList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: needConmentDetailCell) as! JSMNeedConmentCell
            
            cell.dataModel = dataModel
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: needConmentDetailImgCell) as! JSMBiddingDetailImgCell
            
            cell.iconView.kf.setImage(with: URL.init(string: (dataModel?.imgList[indexPath.row])!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            goBigPhotos(index: indexPath.row)
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
