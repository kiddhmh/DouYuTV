//
//  AllGameViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/6.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class AllGameViewController: UIViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: HmhDevice.screenW / 4, height: HmhDevice.screenW / 4)
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RecomGameViewCell.self, forCellWithReuseIdentifier: CellID.RecommentGameCellID)

        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    var dataModels: [HotModel]? {
        didSet {
            if dataModels == nil {return}
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "游戏"
        
        
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        view.addSubview(collectionView)
    }
    
}


extension AllGameViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels!.count == 0 ? 0 : dataModels!.count - 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentGameCellID, for: indexPath) as! RecomGameViewCell
        let model = dataModels![indexPath.item + 1]
        
        cell.imageURL = model.icon_url
        cell.title = model.tag_name
        
        return cell
    }
    
}


extension AllGameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section)---\(indexPath.item)")
    }
}


//extension AllGameViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
