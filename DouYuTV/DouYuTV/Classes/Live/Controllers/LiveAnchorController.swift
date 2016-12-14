//
//  LiveAnchorController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/14.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

class LiveAnchorController: LiveAllController {
    
    fileprivate lazy var anchorVM = LiveAnchorViewModel()
    /// 分类数据
    fileprivate lazy var anchorTitleModels: [LiveAnchorTitleModel] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
}

extension LiveAnchorController {
    
    override func loadData() {
        
        anchorVM.requestAnchorData(shortName: (baseModel?.short_name)!, cate_id: (baseModel?.cate_id)!, limit: limit, offset: "0", complectioned: { [weak self] in
            
            guard let sself = self else { return }
            guard let modes = self?.anchorVM.anchorGroup else {return}
            guard let titleModels = self?.anchorVM.titleGroup else {return}
            if modes.count == 0 || titleModels.count == 0 {return}
            sself.maxCount = 0
            for i in 0..<titleModels.count {    //获取总数据个数
                sself.maxCount += titleModels[i].count ?? 0
            }
            // 每次下拉刷新先清除之前的
            
            sself.offset = 0
            sself.dataArray = modes
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
        
        anchorVM.requestAnchorData(cate_id: (baseModel?.cate_id)!, limit: limit, offset: offset, complectioned: { [weak self] in
            guard let sself = self else { return }
            guard let modes = self?.anchorVM.anchorGroup else {return}
            if modes.count == 0 {return}
            
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
