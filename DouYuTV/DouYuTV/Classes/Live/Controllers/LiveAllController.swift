//
//  LiveAllController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/8.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

class LiveAllController: BaseAnchorViewController {
    
    fileprivate lazy var titleVM = LiveTitleViewModel()
    
    fileprivate lazy var dataArray = [AnchorModel]()
    
    fileprivate lazy var footerView: MHRefreshFooterView = MHRefreshFooterView()
    
    fileprivate var limit: String = "20"    // 每次请求的数据量
    
    fileprivate var offset: Int?            // 每次请求的起始位置
    
    var reciveData: reciveTitleClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MHRefreshFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CellID.LiveSectionFooterID)
        
        collectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        
        loadData()
    }
    
}


extension LiveAllController {
    
    override func loadData() {
        /// 获取标题数据
        titleVM.requestTitleData(complectioned: { [weak self] in
            
            guard let models = self?.titleVM.titleModels else {return}
            if models.count == 0 {return}
            
                // 通知父视图加载标题数据
            if self?.reciveData != nil {
                self?.reciveData!(models as AnyObject)
            }
            
                self?.loadDataFinished()
                self?.refreshControl?.endRefreshing()
            }, failed: {[weak self] (error) in
                self?.loadDataFailed()
                MBProgressHUD.showError(error.errorMessage!)
            })
        
        /// 获取下方房间数据
        titleVM.requestAllData(limit: limit, offset: "0", complectioned: { [weak self] in
                guard let modes = self?.titleVM.allModels else {return}
                if modes.count == 0 {return}
                // 每次下拉刷新先清除之前的
                self?.dataArray.removeAll()
                self?.offset = 0
                self?.dataArray = modes
                self?.collectionView.reloadData()
            
                self?.loadDataFinished()
                self?.refreshControl?.endRefreshing()
            }, failed: { [weak self] (error) in
                self?.loadDataFailed()
                MBProgressHUD.showError(error.errorMessage!)
        })
    }
    
    
    /// 上拉加载更多
    fileprivate func loadMoreData(_ limit: String, _ offset: String) {
        
        titleVM.requestAllData(limit: limit, offset: offset, complectioned: { [weak self] in
            guard let modes = self?.titleVM.allModels else {return}
            if modes.count == 0 {return}
            // 每次下拉刷新先清除之前的
            self?.offset = Int(offset)
            self?.dataArray += modes
            self?.collectionView.reloadData()
            
            self?.loadDataFinished()
            self?.refreshControl?.endRefreshing()
            self?.footerView.endRefresh()
            }, failed: { [weak self] (error) in
                
                self?.footerView.endRefresh()
                MBProgressHUD.showError(error.errorMessage!)
            })
    }
}


extension LiveAllController {
    /// 失败重新加载
    func loadDataDidClick(failedView: BaseFailedView, _ button: UIButton) {
        failedView.removeFromSuperview()
        startAnimation()
        
        loadData()
    }
}


extension LiveAllController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count == 0 ? 0 : 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! RecommentNormalCell
        cell.anchorModel = dataArray[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: HmhDevice.screenW, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellID.LiveSectionFooterID, for: indexPath) as! MHRefreshFooterView
            self.footerView = footerView
            footerView.loadMoreData = { [weak self] in
                self?.loadMoreData((self?.limit)!, "\((self?.offset)! + 20)")
            }
            return footerView
        }else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            let footerView = view as! MHRefreshFooterView
            footerView.beginRefresh()
        }
    }
    
}
