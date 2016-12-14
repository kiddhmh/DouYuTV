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
        allVC.reciveData = { [weak self] in
            guard let sself = self else { return }
            let models: [LiveTitleModel] = $0 as! [LiveTitleModel]
            sself.upLoadView(models)
        }
        childVcs.append(allVC)
        
        return childVcs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        setupUI()
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
        setupNavHiddenClosure()
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
    
    /// 设置导航栏消失和隐藏  isLiveNavBarHidden
    fileprivate func setupNavHiddenClosure() {
        for vc in childVcs {
            let baseVC = vc as? BaseViewController
            baseVC?.hiddenBlock = { [weak self] in
                guard let sself = self else { return }
                sself.navigationController?.setNavigationBarHidden($0, animated: $1)
                let offsetYY: CGFloat = $0 ? -HmhDevice.kNavigationBarH : HmhDevice.kNavigationBarH
                UIView.animate(withDuration: 0.3, animations: {
                    sself.pageContentView.top += offsetYY
                    sself.pageContentView.height -= offsetYY
                })
                let layout = sself.pageContentView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                layout.itemSize = sself.pageContentView.bounds.size
                sself.pageContentView.collectionView.setCollectionViewLayout(layout, animated: false)
                sself.pageContentView.collectionView.height -= offsetYY
            }
        }
    }
    
    fileprivate func upLoadView(_ titleModels: [LiveTitleModel]) {
        
        var titles: [String] = C.livePageTitles
        for model in titleModels {
            titles.append(model.cate_name!)
        }
        
        addChildVCs(titleModels)
        // 设置导航栏消失和隐藏
        setupNavHiddenClosure()
        
        pageContentView.uploadVC(childVc: childVcs)
        pageTitleView.uploadTitle(titles)
    }
    
    private func addChildVCs(_ models: [LiveTitleModel]) {
        
        if childVcs.count == 10 { return }
        for i in 0..<models.count {
            if models[i].cate_name == "颜值" {
                let faceVC = LiveFaceController()
                faceVC.baseModel = models[i]
                childVcs.append(faceVC)
            }else {
                let anchorVC = LiveAnchorController()
                anchorVC.baseModel = models[i]
                childVcs.append(anchorVC)
            }
        }
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
