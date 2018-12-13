//
//  JSMTuiJianGoodsVC.swift
//  JSMachine
//  推荐商品
//  Created by gouyz on 2018/12/13.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let tuiJianGoodsCell = "tuiJianGoodsCell"

class JSMTuiJianGoodsVC: GYZBaseVC {
    
    var speed: String = ""
    var dataList: [JSMGoodsModel] = [JSMGoodsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "推荐商品"
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        requestGoodsDatas()
    }
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        /// cell 的width要小于屏幕宽度的一半，才能一行显示2个以上的Item
        let itemH = (kScreenWidth - klineWidth * 2 - 4)/3.0
        //设置cell的大小
        layout.itemSize = CGSize(width: itemH, height: itemH  * 0.54 + kTitleHeight)
        
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = klineWidth
        //每行之间最小的间距
        layout.minimumLineSpacing = klineWidth
        
        let collView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = kWhiteColor
        
        collView.register(JSMTuiJianGoodsCell.self, forCellWithReuseIdentifier: tuiJianGoodsCell)
        
        
        return collView
    }()
    
    ///获取推荐商品列表数据
    func requestGoodsDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("need/recommend",parameters: ["pro_speed":speed],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = JSMGoodsModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.collectionView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无推荐商品信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestGoodsDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 去详情
    func goDetailVC(model: JSMGoodsModel){
        let vc = JSMGoodsDetailVC()
        vc.goodsId = model.shop_id!
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JSMTuiJianGoodsVC: UICollectionViewDataSource,UICollectionViewDelegate{
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tuiJianGoodsCell, for: indexPath) as! JSMTuiJianGoodsCell
        
        cell.dataModel = dataList[indexPath.row]
        
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goDetailVC(model: dataList[indexPath.row])
    }
}
