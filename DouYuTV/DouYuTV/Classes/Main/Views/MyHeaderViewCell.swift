//
//  MyHeaderViewCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/5.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class MyHeaderViewCell: UICollectionViewCell {
    
    var groups : [HotModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var moreClosure: moreBtnClosure?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .white
        collectionView.register(RecomGameViewCell.self, forCellWithReuseIdentifier: CellID.RecommentGameCellID)
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.centerX.centerY.width.height.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemW = collectionView.bounds.width / 4
        let itemH = collectionView.bounds.height / 2
        layout.itemSize = CGSize(width: itemW, height: itemH)
    }
}

extension MyHeaderViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.求出Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentGameCellID, for: indexPath) as! RecomGameViewCell
        
        // 2.给Cell设置数据
        cell.imageURL = groups![indexPath.item].icon_url
        cell.title = groups![indexPath.item].tag_name
        
        return cell
    }
}


extension MyHeaderViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! RecomGameViewCell
        if cell.title == nil {
            if moreClosure != nil {
                moreClosure!()
            }
        }
    }
    
    
}
