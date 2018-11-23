//
//  JSMMineVC.swift
//  JSMachine
//  我的
//  Created by gouyz on 2018/11/21.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let mineCell = "mineCell"

class JSMMineVC: GYZBaseVC {
    
    ///我的模块
    var menuModels: [JSMMineModel] = [JSMMineModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kWhiteColor
        
        ///读取功能模块
        let plistPath : String = Bundle.main.path(forResource: "mineMenuData", ofType: "plist")!
        let menuArr : [[String:String]] = NSArray(contentsOfFile: plistPath) as! [[String : String]]
        
        for item in menuArr {
            let model = JSMMineModel.init(dict: item)
            menuModels.append(model)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            if #available(iOS 11.0, *) {
                make.top.equalTo(-kTitleAndStateHeight)
            }else{
                make.top.equalTo(0)
            }
            make.left.right.bottom.equalTo(view)
//            make.bottom.equalTo(-kBottomTabbarHeight)
        }
        
        tableView.tableHeaderView = userHeaderView
        
        userHeaderView.userHeaderView.addOnClickListener(target: self, action: #selector(onClickedLogin))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefaults.bool(forKey: kIsLoginTagKey) {
            requestMineData()
        }else{
            setEmptyHeaderData()
        }
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = kWhiteColor
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: mineCell)
        
        return table
    }()
    
    lazy var userHeaderView: JSMMineHeaderView = JSMMineHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 0.48 + kStateHeight))
    
    
    /// 获取我的 数据
    func requestMineData(){
//        if !GYZTool.checkNetWork() {
//            return
//        }
//
//        weak var weakSelf = self
//        createHUD(message: "加载中...")
//
//        GYZNetWork.requestNetwork("member_index&op=member_indexkz", parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
//
//            weakSelf?.hud?.hide(animated: true)
//            //            GYZLog(response)
//            if response["code"].intValue == kQuestSuccessTag{//请求成功
//
//                weakSelf?.setHeaderData(data: response["datas"])
//
//
//            }else{
//                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
//            }
//
//        }, failture: { (error) in
//            weakSelf?.hud?.hide(animated: true)
//            GYZLog(error)
//        })
    }
    
    ///
    func setEmptyHeaderData(){
        userHeaderView.nameLab.text = "登录/注册"
        userHeaderView.userHeaderView.image = UIImage.init(named: "icon_header_default")
        
    }
    
    /// 未登录时，点击登录
    @objc func onClickedLogin(){
        
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            goLogin()
        }
        
    }
    /// 登录
    func goLogin(){
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///控制跳转
    func goController(menu: JSMMineModel){
        //1:动态获取命名空间
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            GYZLog("获取命名空间失败")
            return
        }
        
        let cls: AnyClass? = NSClassFromString(name + "." + menu.controller!) //VCName:表示试图控制器的类名
        
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeClass = cls as? GYZBaseVC.Type else {
            GYZLog("cls不能当做UIViewController")
            return
        }
        
        let controller = typeClass.init()
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

extension JSMMineVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mineCell) as! GYZCommonIconArrowCell
        
        let model = menuModels[indexPath.row]
        cell.iconView.image = UIImage.init(named: model.image!)
        cell.nameLab.text = model.title
        
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
        
        goController(menu: menuModels[indexPath.row])
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = kTitleAndStateHeight + kStateHeight - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = "我的"
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
        }
    }
}
