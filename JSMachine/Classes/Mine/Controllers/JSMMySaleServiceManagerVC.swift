//
//  JSMMySaleServiceManagerVC.swift
//  JSMachine
//  我的售后
//  Created by gouyz on 2018/12/18.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

class JSMMySaleServiceManagerVC: GYZBaseVC {

    let titleArr : [String] = ["处理中","已处理","所有申请"]
    
    //订单状态
    let stateValue : [String] = ["1","2","0"]
    var scrollPageView: ScrollPageView?
    /// 当前索引
    var currIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的快修申请"
        
        setScrollView()
        if currIndex > 0 {
            scrollPageView?.selectedIndex(currIndex, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [JSMDealSaleServiceOrderVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = JSMDealSaleServiceOrderVC()
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
}
