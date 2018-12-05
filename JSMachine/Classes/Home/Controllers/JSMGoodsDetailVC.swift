//
//  JSMGoodsDetailVC.swift
//  JSMachine
//  商品详情
//  Created by gouyz on 2018/12/5.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class JSMGoodsDetailVC: GYZBaseVC {
    
    /// header 高度
    var headerViewH: CGFloat = kScreenWidth * 0.6 + kMargin * 2 + kTitleHeight * 3
    
    var url : String = "https://www.baidu.com/"

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        
        setLeftNavItem(imgName: "icon_back_white")
        
        view.addSubview(webView)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        
        headerView.productView.addOnClickListener(target: self, action: #selector(onClickedProductView))
        headerView.tuWenDetailLab.addOnClickListener(target: self, action: #selector(onClickedTuWenDetail))
        headerView.paramsLab.addOnClickListener(target: self, action: #selector(onClickedParamsDetail))
        
        bottomView.operatorBlock = {[weak self] (index) in
            self?.bottomOperator(index: index)
        }
//        webView.loadHTMLString((dataModel?.mobile_body)!.dealFuTextImgSize(), baseURL: nil)
        
        webView.load(URLRequest.init(url: URL.init(string: url)!))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 设置返回键
    func setLeftNavItem(imgName: String){
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
    }
    
    lazy var headerView: JSMGoodsDetailHeaderView = JSMGoodsDetailHeaderView.init(frame: CGRect.init(x: 0, y: -headerViewH, width: kScreenWidth, height: headerViewH))
    
    /// 加载富文本 商品详情
    lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: CGRect.init(x: 0, y: -kTitleAndStateHeight, width: kScreenWidth, height: kScreenHeight + kTitleAndStateHeight - kBottomTabbarHeight))
        ///设置透明背景
        webView.backgroundColor = UIColor.white
        webView.isOpaque = false
        
        webView.scrollView.bouncesZoom = false
        //        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        
        webView.navigationDelegate = self
        
        webView.scrollView.contentInset = UIEdgeInsets.init(top: headerViewH, left: 0, bottom: 0, right: 0)
        webView.scrollView.delegate = self
        
        webView.scrollView.addSubview(headerView)
        
        return webView
    }()
    
    /// 底部View
    lazy var bottomView: JSMGoodsDetailBottomView = JSMGoodsDetailBottomView()
    
    /// 产品参数
    @objc func onClickedProductView(){
//        let paramView = KZGoodsParamsView()
//        paramView.dataModel = dataModel?.attr
//        paramView.show()
    }
    /// 图文详情
    @objc func onClickedTuWenDetail(){
        if !headerView.tuWenDetailLab.isHighlighted {
            headerView.tuWenDetailLab.isHighlighted = true
            headerView.lineView.isHidden = false
            headerView.paramsLab.isHighlighted = false
            headerView.lineView1.isHidden = true
            url = "https://www.baidu.com/"
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }
    }
    /// 参数详情
    @objc func onClickedParamsDetail(){
        if !headerView.paramsLab.isHighlighted {
            headerView.paramsLab.isHighlighted = true
            headerView.lineView1.isHidden = false
            headerView.tuWenDetailLab.isHighlighted = false
            headerView.lineView.isHidden = true
            url = "https://home.firefoxchina.cn/"
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }
    }
    /// 底部操作
    func bottomOperator(index: Int){
        switch index {
        case 1://咨询
            break
        case 2://收藏
            showCancleFavourite()
        case 3://询价
            goXunJiaVC()
        default:
            break
        }
    }
    
    func showCancleFavourite(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "取消收藏", message: "确定要取消收藏吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
               
            }
        }
    }
    
    func showLogin(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "请先登录", cancleTitle: nil, viewController: self, buttonTitles: "去登录") { (index) in
            
            if index != cancelIndex{
                weakSelf?.goLogin()
            }
        }
    }
    func goLogin(){
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 询价
    func goXunJiaVC(){
        let vc = JSMXunJiaVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension JSMGoodsDetailVC : WKNavigationDelegate,UIScrollViewDelegate{
    ///MARK WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取网页title
        //        self.title = self.webView.title
        //        self.hud?.hide(animated: true)
        
        //        tableView.reloadData()
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        //        self.hud?.hide(animated: true)
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = -kScreenWidth * 0.75 - topLayoutGuide.length
        
        
        //navigationBar alpha
        if contentOffsetY > showNavBarOffsetY  {
            
            var navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if navAlpha > 1 {
                navAlpha = 1
            }
            navBarBgAlpha = navAlpha
            self.navigationItem.title = "商品详情"
            setLeftNavItem(imgName: "icon_back")
        }else{
            navBarBgAlpha = 0
            self.navigationItem.title = ""
            setLeftNavItem(imgName: "icon_back_white")
        }
    }
}

