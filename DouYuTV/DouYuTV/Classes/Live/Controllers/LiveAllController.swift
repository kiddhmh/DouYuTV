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
    
    var reciveData: reciveTitleClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        titleVM.requestAllData(limit: "20", offset: "0", complectioned: { [weak self] in
                guard let modes = self?.titleVM.allModels else {return}
                if modes.count == 0 {return}
                self?.collectionView.reloadData()
            
                self?.loadDataFinished()
                self?.refreshControl?.endRefreshing()
            }, failed: { [weak self] (error) in
                self?.loadDataFailed()
                MBProgressHUD.showError(error.errorMessage!)
        })
    }
}



extension LiveAllController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titleVM.allModels.count == 0 ? 0 : 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleVM.allModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! RecommentNormalCell
        cell.anchorModel = titleVM.allModels[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
}
