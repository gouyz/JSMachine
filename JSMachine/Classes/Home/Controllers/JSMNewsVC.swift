//
//  JSMNewsVC.swift
//  JSMachine
//  行业资讯
//  Created by gouyz on 2018/11/27.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let newsCell = "newsCell"

class JSMNewsVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "行业资讯"
        
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
        table.separatorColor = kGrayLineColor
        
        table.register(JSMNewsCell.self, forCellReuseIdentifier: newsCell)
        
        return table
    }()
    
    /// 分享
    @objc func onclickedShared(sender: UITapGestureRecognizer){
        let cancelBtn = [
            "title": "取消",
            "type": "danger"
        ]
        let mmShareSheet = MMShareSheet.init(title: "分享至", cards: kSharedCards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { [weak self](handler) ->() in
            
            if handler != "cancel" {// 取消
                
            }
        }
        mmShareSheet.present()
    }
}
extension JSMNewsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCell) as! JSMNewsCell
        
        cell.sharedImgView.tag = indexPath.row
        cell.sharedImgView.addOnClickListener(target: self, action: #selector(onclickedShared(sender:)))
        
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
        
        return 90
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
