//
//  LiveViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class LiveViewController: UIViewController {
    
    fileprivate lazy var titleVM = LiveTitleViewModel()
    
    fileprivate lazy var pageTitleView: LivePageTitleView = {
       
        let pageTitleRect = CGRect(x: 0, y: 0, width: HmhDevice.screenW, height: HmhDevice.kNavigationBarH)
        let pageTitleView = LivePageTitleView(frame: pageTitleRect, isScrollEnable: false, titles: C.livePageTitles)
        pageTitleView.currentPage = 1
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    fileprivate var pageContentView: PageContentView!
    
    fileprivate lazy var childVcs: [UIViewController]! = {
        
        var childVcs = [UIViewController]()
        let normalVC = LiveNormalController()
        childVcs.append(normalVC)
        
        let allVC = LiveAllController()
        allVC.reciveData = {
            let models: [LiveTitleModel] = $0 as! [LiveTitleModel]
            print(models)
        }
        childVcs.append(allVC)
        
        return childVcs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        setupUI()
        
//        loadData()
    }
    
    
    private func setupUI() {
        
        // 创建容器视图
        let contentRect = CGRect(x: 0, y: HmhDevice.navigationBarH, width: HmhDevice.screenW, height: HmhDevice.screenH - HmhDevice.navigationBarH - HmhDevice.tabBarH)
        let pageContentView = PageContentView(frame: contentRect, childVcs: self.childVcs!, parentViewController: self)
        pageContentView.delegate = self
        self.pageContentView = pageContentView
        pageContentView.currentPage = 1
        view.addSubview(pageContentView)
        
        // 设置导航栏消失和隐藏
        for vc in childVcs {
            let baseVC = vc as? BaseViewController
            baseVC?.hiddenBlock = { [weak self] in
                self?.navigationController?.setNavigationBarHidden($0, animated: $1)
                let offsetYY: CGFloat = $0 ? -HmhDevice.kNavigationBarH : HmhDevice.kNavigationBarH
                UIView.animate(withDuration: 0.3, animations: {
//                    self?.pageTitleView.top += offsetYY
                    self?.pageContentView.top += offsetYY
                    self?.pageContentView.height -= offsetYY
                })
                if offsetYY > 0 {
                    
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = (self?.pageContentView.bounds.size)!
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    layout.scrollDirection = .horizontal
                    self?.pageContentView.collectionView.setCollectionViewLayout(layout, animated: false)
                    self?.pageContentView.collectionView.height -= offsetYY
                }else {
                    self?.pageContentView.collectionView.height -= offsetYY
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = (self?.pageContentView.bounds.size)!
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    layout.scrollDirection = .horizontal
                    self?.pageContentView.collectionView.setCollectionViewLayout(layout, animated: false)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension LiveViewController {
    
    fileprivate func setupNav() {
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置pageTitleView为navgation的titleView
        navigationItem.titleView = pageTitleView
    }
}


/// 通知方法
extension LiveViewController {
    
    
}


extension LiveViewController: pageContentViewDelegate {
    
    func pageContentView(pageContentView: PageContentView, sourceIndex: Int, targetIndex: Int, progress: Double) {
        
        pageTitleView.setCurrentTitle(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: CGFloat(progress))
    }
    
}


extension LiveViewController: LivePageTitleViewDelegate {
    
    func pageTitleView(_ pageTitleView: LivePageTitleView, didSelectedIndex index: Int) {
        
        pageContentView.scrollToIndex(index)
        
    }
    
}




