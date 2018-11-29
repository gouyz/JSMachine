//
//  JSMPartnerVC.swift
//  JSMachine
//  合作伙伴
//  Created by gouyz on 2018/11/29.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

private let partnerCell = "partnerCell"

class JSMPartnerVC: GYZBaseVC {
    
    let itemWidth: CGFloat = (kScreenWidth - klineDoubleWidth*2)/3.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "合作伙伴"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
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
}
extension JSMPartnerVC: UICollectionViewDataSource,UICollectionViewDelegate{
    
    // MARK: UICollectionViewDataSource 代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: partnerCell, for: indexPath) as! JSMPartnerCell
        
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}
