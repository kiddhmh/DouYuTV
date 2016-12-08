//
//  PageContentView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import UIKit

protocol pageContentViewDelegate: class {
    
    func pageContentView( pageContentView: PageContentView, sourceIndex: Int, targetIndex: Int,  progress: Double)
    
}

class PageContentView: UIView {
    
    /// 设置滚动的位置
    var currentPage: Int? {
        didSet {
            if currentPage! == 0 || currentPage! > childVcs.count {return}
            let point = CGPoint(x: CGFloat(currentPage!) * HmhDevice.screenW, y: 0)
            collectionView.setContentOffset(point, animated: false)
        }
    }
    
    fileprivate var childVcs: [UIViewController]
    
    fileprivate var parentViewController: UIViewController
    
    fileprivate var startOffsetX: CGFloat = 0
    
    fileprivate var isForbidScrollDelegate : Bool = false
    
    weak open var delegate: pageContentViewDelegate?
    
    public lazy var collectionView: UICollectionView = { [unowned self] in
       
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2.创建CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.white
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellID.PageContentViewCellID)
        
        return collectionView
    }()
    
    // 构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController) {
        
        self.childVcs = childVcs
        self.parentViewController = parentViewController

        super.init(frame: frame)
        
        addSubview(self.collectionView)
        collectionView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置滚动
    public func scrollToIndex(_ index: Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        let offset = CGPoint(x: CGFloat(index) * collectionView.bounds.width, y: 0)
        collectionView.setContentOffset(offset, animated: false)
        
    }
}


extension PageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.PageContentViewCellID, for: indexPath)
        
        //先移除之前的
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        //取出控制器
        assert(childVcs.count != 0, "PageContentView ----- cellforItemFail")
        
        let childVC = childVcs[indexPath.item]
        childVC.view.frame = cell.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }

}


extension PageContentView: UICollectionViewDelegate {
    
    //获取开始下标值
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 定义要获取的值
        var sourceIndex = 0
        var targetIndex = 0
        var progress: Double = 0
        
        // 获取进度
        let offsetX = scrollView.contentOffset.x
        let radio = Double(offsetX / CGFloat(scrollView.width))
        progress = radio - floor(radio)
        
        // 判断滑动的方向
        if offsetX > startOffsetX { //向左滑
            
            sourceIndex = Int(offsetX / scrollView.width)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVcs.count { //滑动最后
                targetIndex = childVcs.count - 1
            }
            
            if offsetX - startOffsetX == scrollView.width { //滑完一页
                progress = 1.0
                targetIndex = sourceIndex
            }
            
            
        }else { //向右滑
            
            targetIndex = Int(offsetX / scrollView.width)
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
            progress = 1 - progress
            
        }
        
        
        delegate?.pageContentView(pageContentView: self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
}


