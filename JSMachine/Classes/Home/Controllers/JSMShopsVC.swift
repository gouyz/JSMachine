//
//  JSMShopsVC.swift
//  JSMachine
//  在线商城
//  Created by gouyz on 2018/12/4.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

private let kLeftTableViewCell = "LeftTableViewCell"
private let kShopCell = "kShopCell"
private let kShopHeader = "kShopHeader"

class JSMShopsVC: GYZBaseVC {
    
    fileprivate lazy var categoryList = ["减速机","电机","标准件","减速机配件","机械密封"]
    fileprivate lazy var collectionDatas = [["减速机1","减速机1","减速机1","减速机1","减速机1"],["减速机2","减速机2","减速机2","减速机2","减速机2"],["减速机11","减速机11","减速机11","减速机11","减速机11"],["减速机12","减速机12","减速机12","减速机12","减速机12"],["减速机13","减速机13","减速机13","减速机13","减速机13","减速机13","减速机13","减速机13"]]
    
    fileprivate var selectIndex = 0
    fileprivate var isScrollDown = true
    fileprivate var lastOffsetY : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        self.navigationItem.titleView = searchView
        
        view.addSubview(leftTableView)
        view.addSubview(collectionView)
        
        leftTableView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(view)
            make.width.equalTo(100)
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(view)
//            }else{
//                make.bottom.equalTo(-kTitleAndStateHeight)
//            }
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(leftTableView.snp.right).offset(2)
            make.right.equalTo(-2)
            make.bottom.equalTo(view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(kTitleAndStateHeight)
            }else{
                make.top.equalTo(view)
            }
        }
        
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate lazy var leftTableView : UITableView = {
        let leftTableView = UITableView(frame: CGRect.zero, style: .plain)
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.separatorColor = UIColor.clear
        
        leftTableView.estimatedRowHeight = kTitleHeight
        // 设置行高为自动适配
        leftTableView.rowHeight = UITableViewAutomaticDimension
        
        
        leftTableView.register(JSMShopLeftCell.self, forCellReuseIdentifier: kLeftTableViewCell)
        
        return leftTableView
    }()
    
    lazy var flowlayout : GYZCollectionViewFlowLayout = {
        let flowlayout = GYZCollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 2
        flowlayout.minimumInteritemSpacing = 2
        flowlayout.itemSize = CGSize(width: (kScreenWidth - 100 - 4 - 4) / 2, height: (kScreenWidth - 100 - 4 - 4) / 2 + kTitleHeight)
        return flowlayout
    }()
    
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(JSMShopCell.self, forCellWithReuseIdentifier: kShopCell)
        collectionView.register(JSMShopHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kShopHeader)
        return collectionView
    }()
    lazy var searchView: GYZSearchBtnView = GYZSearchBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
    
    /// 去详情
    func goDetailVC(){
        let vc = JSMGoodsDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TableView DataSource Delegate
extension JSMShopsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLeftTableViewCell, for: indexPath) as! JSMShopLeftCell
        
        cell.nameLab.text = categoryList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        
        // http://stackoverflow.com/questions/22100227/scroll-uicollectionview-to-section-header-view
        // 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
        scrollToTop(section: selectIndex, animated: true)
        
        // collectionView.scrollToItem(at: IndexPath(row: 0, section: selectIndex), at: .top, animated: true)
        tableView.scrollToRow(at: IndexPath(row: selectIndex, section: 0), at: .top, animated: true)
    }
    
    //MARK: - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
    fileprivate func scrollToTop(section: Int, animated: Bool) {
        let headerRect = frameForHeader(section: section)
        let topOfHeader = CGPoint(x: 0, y: headerRect.origin.y - collectionView.contentInset.top)
        collectionView.setContentOffset(topOfHeader, animated: animated)
    }
    
    fileprivate func frameForHeader(section: Int) -> CGRect {
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
        guard let frameForFirstCell = attributes?.frame else {
            return .zero
        }
        return frameForFirstCell;
    }
}
//MARK: - CollectionView DataSource Delegate
extension JSMShopsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDatas[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kShopCell, for: indexPath) as! JSMShopCell
        
        cell.nameLab.text = collectionDatas[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kShopHeader, for: indexPath) as! JSMShopHeaderView
            
            view.nameLab.text = categoryList[indexPath.section]
            
            reusableview = view
        }
        
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth - 100, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goDetailVC()
    }
    
    // CollectionView 分区标题即将展示
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        // 当前 CollectionView 滚动的方向向上，CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
        if !isScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            selectRow(index: indexPath.section)
        }
    }
    
    // CollectionView 分区标题展示结束
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        // 当前 CollectionView 滚动的方向向下，CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
        if isScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            selectRow(index: indexPath.section + 1)
        }
    }
    
    // 当拖动 CollectionView 的时候，处理 TableView
    private func selectRow(index : Int) {
        leftTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }
    
    // 标记一下 CollectionView 的滚动方向，是向上还是向下
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == scrollView {
            isScrollDown = lastOffsetY < scrollView.contentOffset.y
            lastOffsetY = scrollView.contentOffset.y
        }
    }
}
