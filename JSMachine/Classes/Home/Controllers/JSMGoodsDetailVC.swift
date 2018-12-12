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
    var headerViewH: CGFloat = kScreenWidth * 0.6 + kMargin + kTitleHeight * 2
    
    var detailModel: JSMGoodsDetailModel?
    var goodsId : String = ""

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
        headerView.tuWenDetailLab.addOnClickListener(target: self, action: #selector(onClickedTuWenDetail))
        headerView.paramsLab.addOnClickListener(target: self, action: #selector(onClickedParamsDetail))
        
        bottomView.operatorBlock = {[weak self] (index) in
            self?.bottomOperator(index: index)
        }
        requestDetailDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///获取商品详情数据
    func requestDetailDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("shop/shopInfo",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","id":goodsId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.detailModel = JSMGoodsDetailModel.init(dict: data)
                weakSelf?.setData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func setData(){
        if detailModel != nil {
            headerView.adsImgView.setUrlsGroup((detailModel?.goodImgList)!)
            headerView.nameLab.text = detailModel?.goodsModel?.shop_name
            
            bottomView.favouriteBtn.isSelected = detailModel?.follow == "1"
            
            loadContent(url: (detailModel?.image_text_url)!)
        }
        
    }
    
    /// 加载
    func loadContent(url : String){
        
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            //            webView.load(URLRequest.init(url: URL.init(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60))
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }else{
            webView.loadHTMLString(url.dealFuTextImgSize(), baseURL: nil)
        }
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
    
    /// 图文详情
    @objc func onClickedTuWenDetail(){
        if !headerView.tuWenDetailLab.isHighlighted {
            headerView.tuWenDetailLab.isHighlighted = true
            headerView.lineView.isHidden = false
            headerView.paramsLab.isHighlighted = false
            headerView.lineView1.isHidden = true
            loadContent(url: (detailModel?.image_text_url)!)
        }
    }
    /// 参数详情
    @objc func onClickedParamsDetail(){
        if !headerView.paramsLab.isHighlighted {
            headerView.paramsLab.isHighlighted = true
            headerView.lineView1.isHidden = false
            headerView.tuWenDetailLab.isHighlighted = false
            headerView.lineView.isHidden = true
            loadContent(url: (detailModel?.parameter_url)!)
        }
    }
    /// 底部操作
    func bottomOperator(index: Int){
        switch index {
        case 1://咨询
            goOnLineVC()
        case 2://收藏
            dealFavourite()
        case 3://询价
            goXunJiaVC()
        default:
            break
        }
    }
    
    func dealFavourite(){
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            showLogin()
            return
        }
        // 是否收藏
        if detailModel?.follow == "0" {
            requestFavouriteGoods()
        }else{
            showCancleFavourite()
        }
    }
    //技术在线
    func goOnLineVC(){
        let vc = JSMTechnologyOnlineVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCancleFavourite(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "取消收藏", message: "确定要取消收藏吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
               weakSelf?.requestCancleFavouriteGoods()
            }
        }
    }
    ///商品收藏
    func requestFavouriteGoods(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("shop/follow",parameters: ["id":goodsId,"user_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                MBProgressHUD.showAutoDismissHUD(message: "收藏成功")
                weakSelf?.detailModel?.follow = "1"
               weakSelf?.bottomView.favouriteBtn.isSelected = true
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///商品取消收藏
    func requestCancleFavouriteGoods(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("shop/cancelFollow",parameters: ["id":goodsId,"user_id": userDefaults.string(forKey: "userId") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.detailModel?.follow = "0"
                weakSelf?.bottomView.favouriteBtn.isSelected = false
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
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
        vc.goodsId = goodsId
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

