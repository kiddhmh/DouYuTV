//
//  LiveFaceController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/13.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

class LiveFaceController: LiveAllController {
    
    fileprivate lazy var faceVM = LiveAnchorViewModel()
    
    fileprivate lazy var faceDataArray: [RecomFaceModel] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: kItemW, height: kPrettyItemH)
    }
    
}

extension LiveFaceController {
    
    override func loadData() {
        
        // 判断网络类型
        guard HttpReachability.isReachable == true else {
            MBProgressHUD.showError("当前网络不可用")
            return
        }
        
        faceVM.requestFaceData(shortName: (baseModel?.short_name)!, cate_id: (baseModel?.cate_id)!, limit: limit, offset: "0", complectioned: { [weak self] in
            
            guard let sself = self else { return }
            guard let modes = self?.faceVM.faceGroup else {return}
            guard let titleModels = self?.faceVM.titleGroup else {return}
            if modes.count == 0 || titleModels.count == 0 {return}
            sself.maxCount = 0
            for i in 0..<titleModels.count {    // 总数据个数
                sself.maxCount += titleModels[i].count ?? 0
            }
            // 每次下拉刷新先清除之前的
            sself.faceDataArray.removeAll()
            sself.offset = 0
            sself.faceDataArray = modes
            sself.collectionView.reloadData()
            
            sself.loadDataFinished()
            sself.refreshControl?.endRefreshing()
            
            }, failed: { [weak self] (error) in
                guard let sself = self else { return }
                sself.loadDataFailed()
                MBProgressHUD.showError(error.errorMessage ?? "")
        })
    }
    
    
    override func loadMoreData(_ limit: String, _ offset: String) {
        
        let count = Int(self.offset!) + Int(limit)!
        if count >= maxCount {  // 提示加载完毕
            footerView.allDataLoad()
            return
        }
        
        faceVM.requestFaceData(cate_id: (baseModel?.cate_id)!, limit: limit, offset: offset, complectioned: { [weak self] in
            guard let sself = self else { return }
            guard let modes = self?.faceVM.faceGroup else {return}
            if modes.count == 0 {return}
            
            sself.offset = Int(offset)
            sself.faceDataArray += modes
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


// MARK: - UICollectionDataSource
extension LiveFaceController {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return faceDataArray.count == 0 ? 0 : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return faceDataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentPrettyCellID, for: indexPath) as! RecommendPrettyCell
        let model = faceDataArray[indexPath.item]
        cell.faceModel = model
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            if faceDataArray.count < 20 {return}    // 如果数据太少，隐藏上拉刷新
            let footerView = view as! MHRefreshFooterView
            footerView.isHidden = false
            footerView.beginRefresh()
        }
    }
    
}
