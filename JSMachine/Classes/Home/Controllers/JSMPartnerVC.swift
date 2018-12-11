//
//  JSMPartnerVC.swift
//  JSMachine
//  合作伙伴
//  Created by gouyz on 2018/11/29.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let partnerCell = "partnerCell"

class JSMPartnerVC: GYZBaseVC {
    
    let itemWidth: CGFloat = (kScreenWidth - klineDoubleWidth*2)/3.0
    
    var dataList: [JSMPartnerModel] = [JSMPartnerModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "合作伙伴"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestPartnerDatas()
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth - kMargin * 2) * 0.87 + kTitleHeight + kMargin)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = klineDoubleWidth
        //每行之间最小的间距
        layout.minimumLineSpacing = klineDoubleWidth
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        
        collView.register(JSMPartnerCell.self, forCellWithReuseIdentifier: partnerCell)
        
        return collView
    }()
    ///获取合作伙伴列表数据
    func requestPartnerDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("partner/showPartner",parameters: nil,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMPartnerModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.collectionView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无合作伙伴信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestPartnerDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// webVC
    func goWebViewVC(title: String, url: String){
        let vc = JSMWebViewVC()
        vc.url = url
        vc.webTitle = title
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension JSMPartnerVC: UICollectionViewDataSource,UICollectionViewDelegate{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: partnerCell, for: indexPath) as! JSMPartnerCell
        
        cell.dataModel = dataList[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        goWebViewVC(title: model.name!, url: model.url!)
    }

}
