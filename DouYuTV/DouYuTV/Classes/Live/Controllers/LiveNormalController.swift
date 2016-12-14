//
//  LiveNormalController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/8.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

class LiveNormalController: BaseViewController {
    
    fileprivate lazy var norVM = LiveNormalViewModel()
    
    var refreshControl:MHRefreshControl?
    
    fileprivate lazy var dataArray: [HotModel] = []
    
    // MARK: - lazy
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (HmhDevice.screenW - 3) / 3 , height: (HmhDevice.screenH - 64 - 5) / 5)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        // 创建CollectionView
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 4.设置collectionView的内边距
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(RecomGameViewCell.self, forCellWithReuseIdentifier: CellID.RecommentGameCellID)
        
        return collectionView
        }()
    
    override func viewDidLoad() {
        
        setupUI()
        super.viewDidLoad()
        
        loadData()
    }
    
    private func setupUI() {
        
        contentView = collectionView
        view.addSubview(contentView!)
        refreshControl = MHRefreshControl(frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW, height: 66), style: .indicator)
        collectionView.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    override func loadDataFailed() {
        super.loadDataFailed()
        
        refreshControl?.endRefreshing()
    }
}


extension LiveNormalController {
    
    @objc fileprivate func loadData() {
        
        norVM.requestHederData(complectioned: { [weak self] in
            
            guard let sself = self else { return }
            guard let models = self?.norVM.normalModels else {return}
            if models.count == 0 {return}
            var headrModels = [HotModel]()
            // 最多加载15个(去掉最热)
            for i in 1..<16 {
            headrModels.append(models[i])
            }
            
            sself.dataArray = headrModels
            
            sself.collectionView.reloadData()
            
            sself.loadDataFinished()
            sself.refreshControl?.endRefreshing()
            
            }, failed: { [weak self] (error) in
                guard let sself = self else { return }
                MBProgressHUD.showError(error.errorMessage!)
                sself.loadDataFailed()
        })
    }
    
}

extension LiveNormalController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return norVM.normalModels.count == 0 ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentGameCellID, for: indexPath) as! RecomGameViewCell
        let model = dataArray[indexPath.item]
        cell.title = model.tag_name
        cell.imageURL = model.icon_url
        return cell
    }
}


extension LiveNormalController: UICollectionViewDelegateFlowLayout {
    
    
    
}


extension LiveNormalController {
    
    func loadDataDidClick(failedView: BaseFailedView, _ button: UIButton) {
        
        failedView.removeFromSuperview()
        startAnimation()
        
        loadData()
    }
    
}
