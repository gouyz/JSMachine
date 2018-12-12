//
//  JSMMyFavouriteVC.swift
//  JSMachine
//  我的收藏
//  Created by gouyz on 2018/11/25.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myFavouriteCell = "myFavouriteCell"

class JSMMyFavouriteVC: GYZBaseVC {
    
    var dataList: [JSMFavouriteModel] = [JSMFavouriteModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的收藏"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestFavouriteDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(JSMMyFavouriteCell.self, forCellReuseIdentifier: myFavouriteCell)
        
        return table
    }()
    
    ///获取我的收藏列表数据
    func requestFavouriteDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("my/myFocus",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMFavouriteModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无收藏信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestFavouriteDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 询价
    @objc func onClickedXunJia(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        let model = dataList[tag!]
        
        let vc = JSMXunJiaVC()
        vc.goodsId = model.shop_id!
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 咨询
    @objc func onClickedZiXun(sender:UITapGestureRecognizer){
        goOnLineVC()
    }
    //技术在线
    func goOnLineVC(){
        let vc = JSMTechnologyOnlineVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension JSMMyFavouriteVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myFavouriteCell) as! JSMMyFavouriteCell
        
        cell.dataModel = dataList[indexPath.row]
        cell.xunJiaLab.tag = indexPath.row
        cell.xunJiaLab.addOnClickListener(target: self, action: #selector(onClickedXunJia(sender:)))
        cell.ziXunLab.tag = indexPath.row
        cell.ziXunLab.addOnClickListener(target: self, action: #selector(onClickedZiXun(sender:)))
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
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
