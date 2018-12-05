//
//  JSMXunJiaVC.swift
//  JSMachine
//  询价
//  Created by gouyz on 2018/12/5.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

private let xunJiaCell = "xunJiaCell"

class JSMXunJiaVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "询价"
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        
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
    
}

extension JSMXunJiaVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: xunJiaCell) as! JSMXunJiaCell
        
        if indexPath.row == 0 {
            cell.nameLab.textColor = kBlueFontColor
            cell.nameLab.text = "品牌"
            cell.moneyLab.textColor = kBlueFontColor
            cell.moneyLab.text = "单价"
            cell.operatorLab.textColor = kBlueFontColor
            cell.operatorLab.text = "操作"
            cell.operatorLab.borderColor = kBackgroundColor
        }else{
            cell.nameLab.textColor = kHeightGaryFontColor
            cell.nameLab.text = "泰隆"
            cell.moneyLab.textColor = kHeightGaryFontColor
            cell.moneyLab.text = "￥6666.88"
            cell.operatorLab.textColor = kRedFontColor
            cell.operatorLab.text = "询价"
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
