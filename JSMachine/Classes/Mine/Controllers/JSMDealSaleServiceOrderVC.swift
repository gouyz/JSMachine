//
//  JSMDealSaleServiceOrderVC.swift
//  JSMachine
//  处理售后服务
//  Created by gouyz on 2018/12/3.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

private let saleServiceOrderCell = "saleServiceOrderCell"

class JSMDealSaleServiceOrderVC: GYZBaseVC {

    var currPage : Int = 1
    var isDealing: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isDealing {
            self.navigationItem.title = "处理中"
        }else{
            self.navigationItem.title = "已处理"
        }
        
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
        
        table.register(JSMSaleServiceOrderCell.self, forCellReuseIdentifier: saleServiceOrderCell)
        
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
//        let vc = JSMOrderDetailVC()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension JSMDealSaleServiceOrderVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: saleServiceOrderCell) as! JSMSaleServiceOrderCell
        
        if isDealing {
            cell.statusNameLab.backgroundColor = UIColor.ColorHex("#a4a8b8")
            cell.statusNameLab.text = "处理中"
            cell.operatorLab.isHidden = true
            cell.operatorLab.snp.updateConstraints { (make) in
                make.right.equalTo(-1)
                make.width.equalTo(0)
            }
        }else{
            cell.statusNameLab.backgroundColor = kRedFontColor
            cell.statusNameLab.text = "已处理"
            cell.operatorLab.isHidden = false
            cell.operatorLab.snp.updateConstraints { (make) in
                make.right.equalTo(-kMargin)
                make.width.equalTo(60)
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
