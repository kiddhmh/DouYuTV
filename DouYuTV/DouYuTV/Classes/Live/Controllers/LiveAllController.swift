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
    
    public lazy var dataArray: [AnchorModel] = []   //数据源
    
    public lazy var footerView: MHRefreshFooterView = MHRefreshFooterView()
    
    public var limit: String = "20"    // 每次请求的数据量
    
    public var offset: Int?            // 每次请求的起始位置
    
    public var baseModel: LiveTitleModel?    // 提供给子类使用
    
    public var maxCount: Int = 0  // 最大房间数
    
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
        
        super.loadData()
        
        /// 获取标题数据
        titleVM.requestTitleData(complectioned: { [weak self] in
            guard let sself = self else { return }
            guard let models = self?.titleVM.titleModels else {return}
            if models.count == 0 {return}
            
                // 通知父视图加载标题数据
            if sself.reciveData != nil {
                sself.reciveData!(models as AnyObject)
            }
            
                sself.loadDataFinished()
                sself.refreshControl?.endRefreshing()
            }, failed: {[weak self] (error) in
                guard let sself = self else { return }
                sself.loadDataFailed()
                MBProgressHUD.showError(error.errorMessage!)
            })
        
        /// 获取下方房间数据
        titleVM.requestAllData(limit: limit, offset: "0", complectioned: { [weak self] in
                guard let sself = self else { return }
                guard let modes = self?.titleVM.allModels else {return}
                if modes.count == 0 {return}
                // 每次下拉刷新先清除之前的
                sself.dataArray.removeAll()
                sself.offset = 0
                sself.dataArray = modes
                sself.collectionView.reloadData()
            
                sself.loadDataFinished()
                sself.refreshControl?.endRefreshing()
            }, failed: { [weak self] (error) in
                guard let sself = self else { return }
                sself.loadDataFailed()
                MBProgressHUD.showError(error.errorMessage!)
        })
    }
    
    
    /// 上拉加载更多
    public func loadMoreData(_ limit: String, _ offset: String) {
        
        titleVM.requestAllData(limit: limit, offset: offset, complectioned: { [weak self] in
            guard let sself = self else { return }
            guard let modes = self?.titleVM.allModels else {return}
            if modes.count == 0 {return}
            // 每次下拉刷新先清除之前的
            sself.offset = Int(offset)
            sself.dataArray += modes
            sself.collectionView.reloadData()
            
            sself.loadDataFinished()
            sself.refreshControl?.endRefreshing()
            sself.footerView.endRefresh()
            }, failed: { [weak self] (error) in
                guard let sself = self else { return }
                sself.footerView.endRefresh()
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
                guard let sself = self else { return }
                sself.loadMoreData((self?.limit)!, "\((self?.offset)! + 20)")
            }
            footerView.isHidden = true
            return footerView
        }else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            if dataArray.count < 20 {return}    // 如果数据太少，隐藏上拉刷新
            let footerView = view as! MHRefreshFooterView
            footerView.isHidden = false
            footerView.beginRefresh()
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isKind(of: UICollectionView.self) == true {
            
            let offsetY = scrollView.contentOffset.y
            guard offsetY > 0 || offsetY > collectionView.height else {return}
            
            if startOffsetY > offsetY { //显示
                if C.isLiveNavBarHidden == false { return }
                hiddenBlock?(false, true)
                C.isLiveNavBarHidden = false
            }else { //隐藏
                if C.isLiveNavBarHidden == true { return }
                hiddenBlock?(true, true)
                C.isLiveNavBarHidden = true
            }
        }
        
    }
    
}
