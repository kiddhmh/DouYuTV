//
//  MyHeaderView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/5.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit
import ObjectMapper

private let kItemSizeW = HmhDevice.screenW / 4
private let kItemSizeH = kItemSizeW
private let kItemID = "MYHEADERCELLID"

class MyHeaderView: UIView {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: HmhDevice.screenW, height: S.GameViewH), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.register(MyHeaderViewCell.self, forCellWithReuseIdentifier: kItemID)
        
        return collectionView
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = C.mainColor
        return pageControl
    }()
    
    var headerData: [HotModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 判断是否添加更多按钮
    var isAddMoreBtn: Bool = false
    /// 点击更多按钮回调
    var headerViewCellMoreClosure: moreBtnClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        addSubview(pageControl)
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(10)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.top.equalTo(collectionView.snp.bottom).offset(5)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(pageControl.snp.top).offset(-5)
        }
    }
    
    override func layoutSubviews() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyHeaderView: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if headerData == nil { return 0 }
        let pageNum = (headerData!.count - 1) / 8 + 1
        pageControl.numberOfPages = pageNum
        pageControl.isHidden = pageNum == 1 ? true : false
        
        return pageNum
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kItemID, for: indexPath) as! MyHeaderViewCell
        
        setupCellDataWithCell(cell: cell, indexPath: indexPath)
    
        cell.moreClosure = { [unowned self] in
            if self.headerViewCellMoreClosure != nil {
                self.headerViewCellMoreClosure!()
            }
        }
        
        return cell
    }
    

    private func setupCellDataWithCell(cell : MyHeaderViewCell, indexPath : IndexPath) {
        // 0页: 0 ~ 7
        // 1页: 8 ~ 15
        // 2也: 16 ~ 23
        // 1.取出起始位置&终点位置
        let startIndex = indexPath.item * 8
        var endIndex = (indexPath.item + 1) * 8 - 1
        
        // 2.判断越界问题
        if endIndex > headerData!.count - 1 {
            endIndex = headerData!.count - 1
        }
        
        // 3.取出数据,并且赋值给cell
        var groups = Array(headerData![startIndex...endIndex])
        
        if isAddMoreBtn == true && endIndex == headerData!.count - 1 {   // 最后为更多按钮
            let last = Mapper<HotModel>().map(JSON: ["": NSNull()])!
            groups.append(last)
        }
        
        cell.groups = groups
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
}


