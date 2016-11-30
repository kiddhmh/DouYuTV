//
//  BaseViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/24.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

let kItemMargin: CGFloat = 8
let kItemW: CGFloat = (HmhDevice.screenW - 3 * kItemMargin) / 2
let kNormalItemH: CGFloat = kItemW * 3 / 4
let kPrettyItemH: CGFloat = kItemW * 4 / 3
let kHeaderViewH: CGFloat = 50

let kSectionCount: Int = 11
let kRowCount: Int = 4

class BaseViewController: UIViewController {
    
    var hiddenBlock: ((_ ishidden: Bool, _ animated: Bool) -> Void)?
    
    fileprivate var startOffsetY: CGFloat = 0
    
    // MARK: - lazy
    public lazy var collectionView: UICollectionView = { [unowned self] in
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kItemW,height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 创建CollectionView
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.bounces = false
        
        // 4.设置collectionView的内边距
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.register(UINib(nibName: "RecommentNormalCell", bundle: nil), forCellWithReuseIdentifier: CellID.RecommentCellID)
        collectionView.register(UINib(nibName: "RecommendPrettyCell", bundle: nil), forCellWithReuseIdentifier: CellID.RecommentPrettyCellID)
        collectionView.register(UINib(nibName: "RecommendSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellID.RecommendSectionHeaderID)
        
        return collectionView
        }()
    
    
    fileprivate lazy var animImageView : UIImageView = { [unowned self] in
        let imageView = UIImageView(image: UIImage(named: "dyla_img_loading_1"))
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named : "dyla_img_loading_1")!, UIImage(named : "dyla_img_loading_2")!]
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = LONG_MAX
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        return imageView
        }()
    
    fileprivate lazy var failedView: BaseFailedView = { [unowned self] in
        let failedView = BaseFailedView.failView()
        failedView.center = self.view.center
        failedView.delegate = self
        return failedView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUI()
        // 加载数据，子类负责重写
        loadData()
    }
    
    
    public func setUpCollectionViewBounds(_ bounds: CGRect) {
        collectionView.frame = bounds
    }
}


extension BaseViewController {
    
    fileprivate func setupUI() {
        
        view.addSubview(collectionView)
        
        view.addSubview(animImageView)
        
        startAnimation()
    }
}


extension BaseViewController {
    func loadData() {}
}


extension BaseViewController {
    
    func startAnimation() {
        animImageView.isHidden = false
        animImageView.startAnimating()
    }
    
    func loadDataFinished() {
        // 1.停止动画
        animImageView.stopAnimating()
        
        // 2.隐藏animImageView
        animImageView.isHidden = true
    }
}


extension BaseViewController: BaseFailedViewDelegate {
    
    func loadDataFailed(_ error: MyError) {
        
        MBProgressHUD.showError(error.errorMessage!)
        loadDataFinished()
        view.addSubview(failedView)
    }
    
}


extension BaseViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kSectionCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return kRowCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellID.RecommendSectionHeaderID, for: indexPath)
        
        return sectionHeaderView
    }
    
}


extension BaseViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        startOffsetY = scrollView.contentOffset.y
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) == true {
            
            let offsetY = scrollView.contentOffset.y
            if startOffsetY > offsetY { //显示
                if C.isNavBarHidden == false { return }
                hiddenBlock?(false, true)
                C.isNavBarHidden = false
            }else { //隐藏
                if C.isNavBarHidden == true { return }
                hiddenBlock?(true, true)
                C.isNavBarHidden = true
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startOffsetY = scrollView.contentOffset.y
    }
    
}

