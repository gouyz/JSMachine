//
//  JSMNetDotHomeVC.swift
//  JSMachine
//  网点首页
//  Created by gouyz on 2019/1/4.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMNetDotHomeVC: GYZBaseVC {
    let titleArr : [String] = ["首页","待分配","处理中","已完成"]
    
    //订单状态
    let stateValue : [String] = ["","1","2","3"]
    var scrollPageView: ScrollPageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = userDefaults.string(forKey: "dotName") ?? "网点主页"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("退出登录", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 80, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickedLoginOutBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("工程师", for: .normal)
        leftBtn.titleLabel?.font = k13Font
        leftBtn.setTitleColor(kBlackFontColor, for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight)
        leftBtn.addTarget(self, action: #selector(onClickedEngineerBtn), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        
        setScrollView()
        
        /// 极光推送跳转指定页面
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJPushView(noti:)), name: NSNotification.Name(rawValue: kJPushRefreshData), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Dealloc
    deinit{
        ///移除通知
        NotificationCenter.default.removeObserver(self)
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [GYZBaseVC] = []
        for index in 0 ..< titleArr.count{
            if index == 0{
                let homeVC = JSMHomeVC()
                homeVC.isUser = false
                childVC.append(homeVC)
            }else{
                let vc = JSMNetDotListVC()
                vc.orderStatus = stateValue[index]
                childVC.append(vc)
            }
        }
        
        return childVC
    }
    
    /// 设置scrollView
    func setScrollView(){
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 滚动条
        style.showLine = true
        style.scrollTitle = false
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 滚动条颜色
        style.scrollLineColor = kBlueFontColor
        style.normalTitleColor = kHeightGaryFontColor
        style.selectedTitleColor = kBlueFontColor
        /// 显示角标
        style.showBadge = false
        
        scrollPageView = ScrollPageView.init(frame: CGRect.init(x: 0, y: kTitleAndStateHeight, width: kScreenWidth, height: self.view.frame.height - kTitleAndStateHeight), segmentStyle: style, titles: titleArr, childVcs: setChildVcs(), parentViewController: self)
        view.addSubview(scrollPageView!)
    }
    /// 退出登录
    @objc func onClickedLoginOutBtn(){
        
//        let vc = JSMLoginVC()
//        navigationController?.pushViewController(vc, animated: true)
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要退出登录吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.loginOut()
            }
        }
        
    }
    func loginOut(){
        GYZTool.removeUserInfo()
        
        JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
            
        }, seq: 0)
        
//        scrollPageView?.selectedIndex(0, animated: true)
        KeyWindow.rootViewController = GYZMainTabBarVC()
    }
    
    /// 极光推送，跳转指定页面
    ///
    /// - Parameter noti:
    @objc func refreshJPushView(noti:NSNotification){
        
        GYZLog(noti.userInfo)
        let userInfo = noti.userInfo!
        
        // 角色（1、用户2、工程师3、网点）
        let role = userInfo["role"] as! String
        if role == "3" {
            let type = userInfo["p_type"] as! String
            //消息类型(1我的发布2我的订单3我的售后4工程师首页（新分配）5网点首页（待分配）)
            if type == "5" {//网点首页（待分配
                
                scrollPageView?.selectedIndex(1, animated: true)
            }
        }
        
    }
    /// 工程师
    @objc func onClickedEngineerBtn(){
        let vc = JSMEngineerListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
