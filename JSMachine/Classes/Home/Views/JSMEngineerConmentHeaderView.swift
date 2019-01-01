//
//  JSMEngineerConmentHeaderView.swift
//  JSMachine
//  客户评价header 
//  Created by gouyz on 2019/1/1.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

class JSMEngineerConmentHeaderView: UIView {
    
    /// 填充数据
    var dataModel : JSMConmentModel?{
        didSet{
            if let model = dataModel {
                let efficientStr: String = model.efficient!
                efficentNumLab.text = efficientStr
                if efficientStr.count > 0{
                    let efficient: Double = Double.init(efficientStr.subString(start: 0, length: efficientStr.count - 1))!
                    efficientView.progress = CGFloat(efficient/100)
                }
                let mannerStr: String = model.manner!
                mannerNumLab.text = mannerStr
                if mannerStr.count > 0{
                    let manner: Double = Double.init(mannerStr.subString(start: 0, length: mannerStr.count - 1))!
                    mannerView.progress = CGFloat(manner/100)
                }
                let postStr: String = model.post!
                postNumLab.text = postStr
                if postStr.count > 0{
                    let post: Double = Double.init(postStr.subString(start: 0, length: postStr.count - 1))!
                    postView.progress = CGFloat(post/100)
                }
                let timeStr: String = model.time!
                timeNumLab.text = timeStr
                if timeStr.count > 0{
                    let time: Double = Double.init(timeStr.subString(start: 0, length: timeStr.count - 1))!
                    timeView.progress = CGFloat(time/100)
                }
            }
        }
    }

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(efficientView)
        efficientView.addSubview(efficentLab)
        efficientView.addSubview(efficentNumLab)
        self.addSubview(mannerView)
        mannerView.addSubview(mannerLab)
        mannerView.addSubview(mannerNumLab)
        
        self.addSubview(postView)
        postView.addSubview(postLab)
        postView.addSubview(postNumLab)
        self.addSubview(timeView)
        timeView.addSubview(timeLab)
        timeView.addSubview(timeNumLab)
//        efficientView.snp.makeConstraints { (make) in
//            make.centerX.equalTo(kScreenWidth * 0.25)
//            make.top.equalTo(kMargin)
//            make.size.equalTo(CGSize.init(width: 110, height: 110))
//        }
        efficentLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(efficientView.snp.centerY)
            make.height.equalTo(20)
        }
        efficentNumLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(efficentLab)
            make.top.equalTo(efficentLab.snp.bottom)
            make.height.equalTo(40)
        }
        mannerLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(mannerView.snp.centerY)
            make.height.equalTo(20)
        }
        mannerNumLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(mannerLab)
            make.top.equalTo(mannerLab.snp.bottom)
            make.height.equalTo(40)
        }
        postLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(postView.snp.centerY)
            make.height.equalTo(20)
        }
        postNumLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(postLab)
            make.top.equalTo(postLab.snp.bottom)
            make.height.equalTo(40)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(timeView.snp.centerY)
            make.height.equalTo(20)
        }
        timeNumLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(timeLab)
            make.top.equalTo(timeLab.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    lazy var efficientView: ZZCircleProgress = {
       let view = ZZCircleProgress.init(frame: CGRect.init(x: kScreenWidth * 0.25 - 60, y: kMargin, width: 120, height: 120))
        view.backgroundColor = kWhiteColor
        view.cornerRadius = 60
        view.startAngle = 270
        view.duration = 1
        view.strokeWidth = 5
        view.showPoint = false
        view.showProgressText = false
        view.pathFillColor = kBlueFontColor
        view.prepareToShow = true
        
        return view
    }()
    
    lazy var efficentLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "解决问题高效"
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var efficentNumLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 28)
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var mannerView: ZZCircleProgress = {
        let view = ZZCircleProgress.init(frame: CGRect.init(x: kScreenWidth * 0.75 - 60, y: efficientView.y, width: efficientView.width, height: efficientView.height))
        view.backgroundColor = kWhiteColor
        view.cornerRadius = 60
        view.startAngle = 270
        view.duration = 1
        view.strokeWidth = 5
        view.showPoint = false
        view.showProgressText = false
        view.pathFillColor = kBlueFontColor
        view.prepareToShow = true
        
        return view
    }()
    
    lazy var mannerLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "态度友好"
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var mannerNumLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 28)
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var postView: ZZCircleProgress = {
        let view = ZZCircleProgress.init(frame: CGRect.init(x: efficientView.x, y: kMargin + efficientView.bottomY, width: efficientView.width, height: efficientView.height))
        view.backgroundColor = kWhiteColor
        view.cornerRadius = 60
        view.startAngle = 270
        view.duration = 1
        view.strokeWidth = 5
        view.showPoint = false
        view.showProgressText = false
        view.pathFillColor = kBlueFontColor
        view.prepareToShow = true
        
        return view
    }()
    
    lazy var postLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "穿戴工作服"
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var postNumLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 28)
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var timeView: ZZCircleProgress = {
        let view = ZZCircleProgress.init(frame: CGRect.init(x: mannerView.x, y: postView.y, width: efficientView.width, height: efficientView.height))
        view.backgroundColor = kWhiteColor
        view.cornerRadius = 60
        view.startAngle = 270
        view.duration = 1
        view.strokeWidth = 5
        view.showPoint = false
        view.showProgressText = false
        view.pathFillColor = kBlueFontColor
        view.prepareToShow = true
        
        return view
    }()
    
    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "准时上门服务"
        lab.textAlignment = .center
        
        return lab
    }()
    lazy var timeNumLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 28)
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        
        return lab
    }()
}
