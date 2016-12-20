//
//  FollowController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class FollowController: LiveViewController {
    
    fileprivate lazy var followTitleView: LivePageTitleView = {
        
        let pageTitleRect = CGRect(x: 0, y: 0, width: HmhDevice.screenW, height: HmhDevice.kNavigationBarH)
        let pageTitleView = LivePageTitleView(frame: pageTitleRect, isScrollEnable: false, titles: C.profileTitles)
        pageTitleView.currentPage = 0
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    fileprivate var followContentView: PageContentView!
    
    fileprivate lazy var childVcs: [UIViewController]! = {
        
        var childVcs = [UIViewController]()
        let normalVC = FollowZBController()
        childVcs.append(normalVC)
        let allVC = FollowMovieController()
        childVcs.append(allVC)
        
        return childVcs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        
        let contentRect = CGRect(x: 0, y: HmhDevice.navigationBarH, width: HmhDevice.screenW, height: HmhDevice.screenH - HmhDevice.navigationBarH - HmhDevice.tabBarH)
        let pageContentView = PageContentView(frame: contentRect, childVcs: self.childVcs!, parentViewController: self)
        pageContentView.delegate = self
        self.followContentView = pageContentView
        pageContentView.currentPage = 0
        view.addSubview(pageContentView)
    }
    
    override func setupNav() {
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置pageTitleView为navgation的titleView
        navigationItem.titleView = followTitleView
    }
    
}


// MARK: - FollowDelegate
extension FollowController {
    
    override func pageContentView(pageContentView: PageContentView, sourceIndex: Int, targetIndex: Int, progress: Double) {
        
        followTitleView.setCurrentTitle(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: CGFloat(progress))
    }
    
    override func pageTitleView(_ pageTitleView: LivePageTitleView, didSelectedIndex index: Int) {
        
        followContentView.scrollToIndex(index)
    }
    
}

