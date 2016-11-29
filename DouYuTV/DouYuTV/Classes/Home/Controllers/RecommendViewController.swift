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
        
        print(recomVM.faceGroup.count)
    }
    
    
}


extension RecommentViewController: UICollectionViewDelegateFlowLayout {
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentPrettyCellID, for: indexPath)
            return cell
        }else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
    }
    
    
}




