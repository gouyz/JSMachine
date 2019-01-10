//
//  JSMEngineerHomerVC.swift
//  JSMachine
//  工程师主页
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMEngineerHomerVC: GYZBaseVC {

    let titleArr : [String] = ["首页","新分配","处理中","已完成"]
    
    //订单状态
    let stateValue : [String] = ["","1","2","3"]
    var scrollPageView: ScrollPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "工作台"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_engineer_header")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedProfileBtn))
        
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
                let vc = JSMEngineerOrderVC()
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
    /// 个人中心
    @objc func clickedProfileBtn(){
        let vc = JSMEngineerProfileVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 极光推送，跳转指定页面
    ///
    /// - Parameter noti:
    @objc func refreshJPushView(noti:NSNotification){
        
        GYZLog(noti.userInfo)
        let userInfo = noti.userInfo!
        
        // 角色（1、用户2、工程师3、网点）
        let role = userInfo["role"] as! String
        if role == "2" {
            let type = userInfo["p_type"] as! String
            //消息类型(1我的发布2我的订单3我的售后4工程师首页（新分配）5网点首页（待分配）)
            if type == "4" {//工程师首页（新分配）
                
                scrollPageView?.selectedIndex(1, animated: true)
            }
        }
        
    }
}
