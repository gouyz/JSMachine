//
//  JSMMyWinBiddingManagerVC.swift
//  JSMachine
//  已中标
//  Created by gouyz on 2019/4/10.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMMyWinBiddingManagerVC: GYZBaseVC {

    let titleArr : [String] = ["待确认","未发货","已发货","所有订单"]
    
    //订单状态
    let stateValue : [String] = ["1","2","3","4"]
    var scrollPageView: ScrollPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "已中标"
        
        setScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [UIViewController] {
        
        var childVC : [JSMMyWinBiddingVC] = []
        for index in 0 ..< titleArr.count{
            
            let vc = JSMMyWinBiddingVC()
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
