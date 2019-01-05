//
//  JSMPlayVideoVC.swift
//  JSMachine
//  播放视频
//  Created by gouyz on 2019/1/5.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import BMPlayer
import NVActivityIndicatorView
import AVFoundation

class JSMPlayVideoVC: GYZBaseVC {
    
    /// 当前播放的时间
    var currentTime: TimeInterval = 0
    var videoUrl: String = "http://baobab.wdjcdn.com/14525705791193.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(kStateHeight)
            make.left.right.equalTo(view)
            // 注意此处，宽高比 16:9 优先级比 1000 低就行，在因为 iPhone 4S 宽高比不是 16：9
            make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
        }
        resetPlayerManager()
        let asset = BMPlayerResource(url: URL.init(string: videoUrl)!)
        player.setVideo(resource: asset)
        player.delegate = self
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        // If use the slide to back, remember to call this method
        // 使用手势返回的时候，调用下面方法
        player.autoPlay()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        // If use the slide to back, remember to call this method
        // 使用手势返回的时候，调用下面方法
        player.pause(allowAutoPlay: true)
    }

    deinit {
        // 使用手势返回的时候，调用下面方法手动销毁
        player.prepareToDealloc()
    }
    
    /// 播放器
    lazy var player: BMPlayer = BMPlayer(customControlView: BMPlayerControlView())
    
    /// 播放器自定义属性 创建播放器前设定
    func resetPlayerManager() {
        // 是否打印日志，默认false
        BMPlayerConf.allowLog = false
        // 是否自动播放，默认true
//        BMPlayerConf.shouldAutoPlay = false
        // 主体颜色，默认白色
        BMPlayerConf.tintColor = kWhiteColor
        // 顶部返回和标题显示选项，默认.Always，可选.HorizantalOnly、.None
        BMPlayerConf.topBarShowInCase = .always
        // 加载效果，更多请见：https://github.com/ninjaprox/NVActivityIndicatorView
        BMPlayerConf.loaderType  = NVActivityIndicatorType.lineSpinFadeLoader
    }
    
}


extension JSMPlayVideoVC: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        self.player.snp.remakeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kStateHeight)
            if isFullscreen {
                make.bottom.equalTo(view)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    
}
/// mark - UINavigationControllerDelegate
extension JSMPlayVideoVC : UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        /// 首页或课程详情隐藏导航栏
        let isShow = viewController.isKind(of: JSMPlayVideoVC.self)
        self.navigationController?.setNavigationBarHidden(isShow, animated: true)
    }
}
