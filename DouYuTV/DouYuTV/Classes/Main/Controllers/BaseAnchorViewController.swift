//
//  BaseAnchorViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/8.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

let kItemMargin: CGFloat = 10
let kItemW: CGFloat = (HmhDevice.screenW - 3 * kItemMargin) / 2
let kNormalItemH: CGFloat = kItemW * 3 / 4
let kPrettyItemH: CGFloat = kItemW * 4 / 3
let kHeaderViewH: CGFloat = 50

let kSectionCount: Int = 11
let kRowCount: Int = 4

class BaseAnchorViewController: BaseViewController {
    
    var refreshControl:MHRefreshControl?
    
    public var startOffsetY: CGFloat = 0
    
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
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 4.设置collectionView的内边距
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.register(UINib(nibName: "RecommentNormalCell", bundle: nil), forCellWithReuseIdentifier: CellID.RecommentCellID)
        collectionView.register(UINib(nibName: "RecommendPrettyCell", bundle: nil), forCellWithReuseIdentifier: CellID.RecommentPrettyCellID)
        collectionView.register(UINib(nibName: "RecommendSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellID.RecommendSectionHeaderID)
        
        return collectionView
        }()

    /// 坑！！！更新collectionView位置，否则有无法想象的错误 ~ 切记
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.frame = (self.view.superview?.frame)!
    }
    
    override func viewDidLoad() {
        
        setupUI()
        
        super.viewDidLoad()
        
        // 加载数据，子类负责重写
        loadData()
    }
}


extension BaseAnchorViewController {
    
     func setupUI() {
        
        contentView = collectionView
        view.addSubview(contentView!)
        refreshControl = MHRefreshControl(frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW, height: 66), style: .animationView)
        collectionView.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    
    override func loadDataFailed() {
        super.loadDataFailed()
        
        refreshControl?.endRefreshing()
    }
    
    func loadData() {
        // 子类重写
        // 判断网络类型
        guard HttpReachability.isReachable == true else {
            MBProgressHUD.showError("当前网络不可用")
            loadDataFailed()
            return
        }
    }
}


extension BaseAnchorViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kSectionCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return kRowCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentCellID, for: indexPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellID.RecommendSectionHeaderID, for: indexPath)
        
        return sectionHeaderView
    }
    
}


extension BaseAnchorViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        startOffsetY = scrollView.contentOffset.y
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) == true {
            
            let offsetY = scrollView.contentOffset.y
            guard offsetY > 0 || offsetY > collectionView.height else {return}
            
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
    }
}
