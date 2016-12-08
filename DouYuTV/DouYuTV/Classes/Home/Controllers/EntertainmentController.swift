//
//  EntertainmentController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//  娱乐

import UIKit
import MBProgressHUD

private let kENSection = 12

class EntertainmentController: BaseAnchorViewController {
    
    fileprivate lazy var enterVM = EnmentViewModel()
    
    fileprivate lazy var dataArray = [HotModel]()
    
    fileprivate lazy var headerView: MyHeaderView = {
        let headerView = MyHeaderView(frame: CGRect(x: 0, y: -S.ColHeaderViewH, width: HmhDevice.screenW, height: S.ColHeaderViewH))
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.addSubview(headerView)
        collectionView.contentInset = UIEdgeInsets(top: S.ColHeaderViewH, left: 0, bottom: 0, right: 0)
    }
}


extension EntertainmentController {
    
    override func loadData() {
        super.loadData()
        
        enterVM.requestEnData(complectioned: { [weak self] in
            
            guard let models = self?.enterVM.enModels else {return}
            if models.count == 0 {return}
            var headrModels = [HotModel]()
            for i in 1..<models.count {
                headrModels.append(models[i])
            }
            self?.headerView.headerData = headrModels
            self?.headerView.isAddMoreBtn = false
            
            // 筛选房间数大于1的类型
            self?.dataArray = models.filter{ ($0.room_list?.count)! > 1 }
            
            self?.collectionView.reloadData()
            
            self?.loadDataFinished()
            self?.refreshControl?.endRefreshing()
            }, failed: {[weak self] (error) in
                MBProgressHUD.showError(error.errorMessage!)
                self?.loadDataFailed()
            })
    }
}


extension EntertainmentController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.dataArray.count == 0 {
            return 0
        }else {
            return kENSection
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = dataArray[section]
        if model.room_list?.count == 4 {
            return 4
        }else {
            return 2
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! RecommentNormalCell
        let anchorModels = dataArray[indexPath.section]
        cell.anchorModel = anchorModels.room_list?[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) as! RecommendSectionHeaderView
        
        if indexPath.section == 0 {
            sectionHeaderView.titleLabel.text = "最热"
            sectionHeaderView.iconImage.image = UIImage(named: "home_header_hot")
        }else {
            let hotModels = dataArray[indexPath.section]
            sectionHeaderView.dataModel = hotModels
            
        }
        
        return sectionHeaderView
    }
    
    
}


extension EntertainmentController {
    
    func loadDataDidClick(failedView: BaseFailedView, _ button: UIButton) {
        
        failedView.removeFromSuperview()
        startAnimation()
        
        loadData()
    }
    
}
