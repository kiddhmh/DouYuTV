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
    
    /// navTitleView
    fileprivate lazy var navTitleView: MHNavTitleView = {
        let navTitleView = MHNavTitleView(frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW, height: kButtonWidth), titles: [""])
        navTitleView.delegate = self
        return navTitleView
    }()
    
    /// 暂无数据
    fileprivate lazy var noDataView: LiveNoDataView = LiveNoDataView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(noDataView)
        view.addSubview(navTitleView)
        noDataView.isHidden = true
        navTitleView.isHidden = true
        collectionView.top += navTitleView.bottom
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noDataView.frame = collectionView.frame
    }
    
}

extension LiveAnchorController {
    
    override func loadData() {
        
        // 判断网络类型
        guard HttpReachability.isReachable == true else {
            MBProgressHUD.showError("当前网络不可用")
            return
        }
        
        anchorVM.requestAnchorData(shortName: (baseModel?.short_name)!, cate_id: (baseModel?.cate_id)!, limit: limit, offset: "0", complectioned: { [weak self] in
            
            guard let sself = self else { return }
            guard let modes = self?.anchorVM.anchorGroup else {return}
            guard let titleModels = self?.anchorVM.titleGroup else {return}
            if modes.count == 0 || titleModels.count == 0 {return}
            sself.maxCount = 0
            for i in 0..<titleModels.count {    //获取总数据个数
                sself.maxCount += titleModels[i].count_ios ?? 0
            }
            // 设置navTitleView
            var titles: [String] = []
            for i in 0..<titleModels.count {
                titles.append(titleModels[i].tag_name ?? "")
            }
            if titles.count == 1 {
                sself.navTitleView.removeFromSuperview()
                sself.collectionView.top = 0
            }else {
                titles.insert("全部", at: 0)
                sself.navTitleView.isHidden = false
                sself.navTitleView.uploadTitle(titles)
                sself.navTitleView.dataArray = titleModels
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
    
    
    /// 加载具体某个数据
    func loadConrfeteData(tag_id: String, maxcount: Int, limit: String, offset: String) {
        
        guard  maxcount != 0 else {
            // 显示暂无数据
            noDataView.isHidden = false
            contentView?.isHidden = true
            return
        }
        
        let count = Int(self.offset!) + Int(limit)!
        if count >= maxcount && self.offset! > 0 {  // 提示加载完毕
            footerView.allDataLoad()
            return
        }
        
        anchorVM.requestConcreteData(tag_id: tag_id, limit: limit, offset: offset, complectioned: { [weak self] in
            guard let sself = self else { return }
            guard let modes = self?.anchorVM.anchorGroup else {return}
            if modes.count == 0 {return}
            
            sself.offset = Int(offset)
            sself.dataArray += modes
            sself.collectionView.reloadData()
            
            sself.loadDataFinished()
            sself.refreshControl?.endRefreshing()
            sself.footerView.endRefresh()
            sself.noDataView.isHidden = true
            }, failed: { [weak self] (error) in
                guard let sself = self else { return }
                sself.footerView.endRefresh()
                MBProgressHUD.showError(error.errorMessage!)
            })
    }
    
}


// MARK: - MHNavTitleViewDelegate
extension LiveAnchorController: MHNavTitleViewDelegate {
    
    private func simpleMethod(_ index: Int) {
        guard index != 0  else {
            loadData()
            return
        }
        
        guard anchorVM.titleGroup.count != 0 else {return}
        let model = anchorVM.titleGroup[index - 1]
        
        // 清除之前的
        offset = 0
        dataArray.removeAll()
        loadConrfeteData(tag_id: (model.tag_id)!,maxcount: model.count_ios ?? 0, limit: limit, offset: "0")
    }
    
    /// 点击了某个Label
    func navTitleView(_ navTitleView: MHNavTitleView, didSelectedIndex index: Int) {
        simpleMethod(index)
    }
    
    /// 点击了某个collectionViewCell
    func navTitleView(_ navTitleView: MHNavTitleView, didSelectItemCell indexPath: IndexPath) {
        simpleMethod(indexPath.item)
    }
    
}
