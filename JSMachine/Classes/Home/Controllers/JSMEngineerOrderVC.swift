//
//  JSMEngineerOrderVC.swift
//  JSMachine
//  工程师处理订单
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

private let engineerOrderCell = "engineerOrderCell"

class JSMEngineerOrderVC: GYZBaseVC {

    var currPage : Int = 1
    var orderStatus: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        table.register(JSMSaleServiceOrderCell.self, forCellReuseIdentifier: engineerOrderCell)
        
        //        weak var weakSelf = self
        ///添加下拉刷新
        //        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
        //            weakSelf?.refresh()
        //        })
        //        ///添加上拉加载更多
        //        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
        //            weakSelf?.loadMore()
        //        })
        return table
    }()
    
    /// 订单详情
    func goDetailVC(){
        let vc = JSMSaleServiceOrderDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension JSMEngineerOrderVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: engineerOrderCell) as! JSMSaleServiceOrderCell
        
        if orderStatus == "1" {
            cell.statusNameLab.backgroundColor = kRedFontColor
            cell.statusNameLab.text = "新分配"
            cell.deleteLab.isHidden = true
            cell.deleteLab.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            cell.operatorLab.isHidden = false
            cell.operatorLab.text = "接单"
            cell.operatorLab.snp.updateConstraints { (make) in
                make.right.equalTo(-kMargin)
                make.width.equalTo(60)
            }
        }else if orderStatus == "2"{
            cell.statusNameLab.backgroundColor = UIColor.ColorHex("#a4a8b8")
            cell.statusNameLab.text = "处理中"
            cell.deleteLab.isHidden = false
            cell.deleteLab.snp.updateConstraints { (make) in
                make.width.equalTo(60)
            }
            cell.operatorLab.isHidden = false
            cell.operatorLab.snp.updateConstraints { (make) in
                make.right.equalTo(-kMargin)
                make.width.equalTo(60)
            }
        }else{
            cell.statusNameLab.backgroundColor = kBlueFontColor
            cell.statusNameLab.text = "已完成"
            cell.deleteLab.isHidden = false
            cell.deleteLab.snp.updateConstraints { (make) in
                make.width.equalTo(60)
            }
            cell.operatorLab.isHidden = true
            cell.operatorLab.snp.updateConstraints { (make) in
                make.right.equalTo(-1)
                make.width.equalTo(0)
            }
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
        goDetailVC()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
