//
//  RecommendViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//  推荐

import UIKit



class RecommentViewController: BaseViewController {
    
    fileprivate lazy var recomVM: RecomViewModel = RecomViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
}


// MARK: - 请求数据
extension RecommentViewController {

    override func loadData() {
        
        recomVM.requestData(complectioned: { [weak self] in
            self?.collectionView.reloadData()
            self?.loadDataFinished()
            }, failed: {[weak self] (error) in
            
            self?.loadDataFailed(error)
        })
    }
    
}


extension RecommentViewController {
    
    func loadDataDidClick(failedView: BaseFailedView, _ button: UIButton) {
        failedView.removeFromSuperview()
        startAnimation()
        
        loadData()
    }
}


extension RecommentViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if recomVM.bigGroup.count == 0 {
            return 0
        }else {
            return kSectionCount
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }else {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentPrettyCellID, for: indexPath) as! RecommendPrettyCell
            cell.faceModel = recomVM.faceGroup[indexPath.row]
            return cell
        }else {
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! RecommentNormalCell
            
            if indexPath.section == 0 {
                cell.anchorModel = recomVM.bigGroup[indexPath.row]
            }else {
                let anchorModels = recomVM.hotGroup[indexPath.section - 2].room_list
                cell.anchorModel = anchorModels?[indexPath.row]
            }
            
            return cell
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) as! RecommendSectionHeaderView

        if indexPath.section == 0 {
            sectionHeaderView.titleLabel.text = "最热"
            sectionHeaderView.iconImage.image = UIImage(named: "home_header_hot")
        }
        
        if indexPath.section == 1 {
            sectionHeaderView.titleLabel.text = "颜值"
            sectionHeaderView.iconImage.image = UIImage(named: "columnYanzhiIcon")
        }
        
        if indexPath.section > 1 {
            sectionHeaderView.dataModel = recomVM.hotGroup[indexPath.section - 2]
        }
        
        return sectionHeaderView
    }
    
}




