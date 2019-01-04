//
//  JSMNetDotHomeVC.swift
//  JSMachine
//  网点首页
//  Created by gouyz on 2019/1/4.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMNetDotHomeVC: GYZBaseVC {
    let titleArr : [String] = ["待分配","处理中","已完成"]
    
    //订单状态
    let stateValue : [String] = ["1","2","3"]
    var scrollPageView: ScrollPageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = userDefaults.string(forKey: "dotName") ?? "网点主页"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("退出登录", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickedLoginOutBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [JSMEngineerOrderVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = JSMEngineerOrderVC()
            vc.orderStatus = stateValue[index]
            childVC.append(vc)
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
        GYZTool.removeUserInfo()
        
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
