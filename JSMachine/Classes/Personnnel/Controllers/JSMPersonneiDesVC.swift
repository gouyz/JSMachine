//
//  JSMPersonneiDesVC.swift
//  JSMachine
//  人才库说明
//  Created by gouyz on 2018/12/28.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class JSMPersonneiDesVC: GYZBaseVC {
    /// url
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "人才库说明"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(webView)
        view.addSubview(bottomView)
        bottomView.addSubview(joinBtn)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(90)
        }
        joinBtn.snp.makeConstraints { (make) in
            make.center.equalTo(bottomView)
            make.size.equalTo(CGSize.init(width: kScreenWidth * 0.5, height: kTitleHeight))
        }
        webView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        requestGetURL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        ///设置透明背景
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.bouncesZoom = false
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.navigationDelegate = self
        
        return webView
    }()
    lazy var bottomView: UIView = {
        let btView = UIView()
        btView.backgroundColor = kBackgroundColor
        
        return btView
    }()
    /// 加入按钮
    lazy var joinBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("我想加入", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.cornerRadius = 22
        
        btn.addTarget(self, action: #selector(clickedJoinBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 获取url
    func requestGetURL(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my/explain",  success: { (response) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.url = response["data"]["url"].stringValue
                weakSelf?.loadContent()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 加载
    func loadContent(){
        
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            //            webView.load(URLRequest.init(url: URL.init(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60))
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }else{
            webView.loadHTMLString(url.dealFuTextImgSize(), baseURL: nil)
        }
    }
    ///加入
    @objc func clickedJoinBtn(){
        let vc = JSMPersonnelVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension JSMPersonneiDesVC : WKNavigationDelegate{
    ///MARK WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        createHUD(message: "加载中...")
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取网页title
        //        self.title = self.webView.title
        self.hud?.hide(animated: true)
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.hud?.hide(animated: true)
    }
}
