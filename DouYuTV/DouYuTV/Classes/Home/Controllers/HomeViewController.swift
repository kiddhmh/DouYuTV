//
//  HomeViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    
    fileprivate var pageContentView: PageContentView!
    
    fileprivate lazy var pageTitleView: PageTitleView = {
        
        let pageTitleRect = CGRect(x: 0, y: HmhDevice.navigationBarH, width: HmhDevice.screenW, height: kTitleViewH)
        let pageTitleView = PageTitleView(frame: pageTitleRect, isScrollEnable: false, titles: C.pageTitles)
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    fileprivate lazy var childVcs: [UIViewController]! = {
      
        var childVcs = [UIViewController]()
        let recommentVC = RecommentViewController()
        childVcs.append(recommentVC)
        
        let gameVc = GameViewController()
        childVcs.append(gameVc)
        
        let entertainmentVC = EntertainmentController()
        childVcs.append(entertainmentVC)
        
        let MGameVC = MGameViewController()
        childVcs.append(MGameVC)
        
        let FunVC = FunViewController()
        childVcs.append(FunVC)
        
        return childVcs
    }()
    
    /// 搜索历史页面
    fileprivate lazy var searchVC: MHSearchViewController = MHSearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavgationBar()
        
        setupUI()
        
        // 设置转场动画代理
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.transitioningDelegate = self
        
        // 注册通知，切换控制器
        NotificationCenter.default.addObserver(self, selector: #selector(pushViewController(_:)), name: NSNotification.Name.MHPushViewController, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSelectedController(_:)), name: Notification.Name.MHChangeSelectedController, object: nil)
    }
    
    
    private func setupUI() {
        
        // 创建首页标题栏
        view.addSubview(self.pageTitleView)
        
        // 创建容器视图
        let contentRect = CGRect(x: 0, y: HmhDevice.navigationBarH + kTitleViewH, width: HmhDevice.screenW, height: HmhDevice.screenH - pageTitleView.height - HmhDevice.navigationBarH - HmhDevice.tabBarH)
        
        let pageContentView = PageContentView(frame: contentRect, childVcs: self.childVcs!, parentViewController: self)
        pageContentView.delegate = self
        self.pageContentView = pageContentView
        
        view.addSubview(pageContentView)
        
        // 设置导航栏消失和隐藏
        for vc in childVcs {
            let baseVC = vc as? BaseViewController
            baseVC?.hiddenBlock = { [weak self] in
                guard let sself = self else { return }
                sself.navigationController?.setNavigationBarHidden($0, animated: $1)
                let offsetYY: CGFloat = $0 ? -HmhDevice.kNavigationBarH : HmhDevice.kNavigationBarH
                UIView.animate(withDuration: 0.3, animations: {
                    sself.pageTitleView.top += offsetYY
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - UIViewControllerTransitioningDelegate协议
// MARK: - 作为代理，需要提供present和dismiss时的animator，有时候一个animator可以同时在present和dismiss时用
extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MHTransitionManager()
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MHTransitionZoom()
    }
}


/// 通知方法
extension HomeViewController {
    
    @objc fileprivate func pushViewController(_ notification: NSNotification) {
        
        let info = notification.userInfo
        let ViewController = info!["VC"] as! UIViewController
        let animated = info!["animated"] as! Bool
        self.navigationController?.pushViewController(ViewController, animated: animated)
    }
    
    @objc fileprivate func changeSelectedController(_ notification: NSNotification) {
        tabBarController?.selectedIndex = 1
    }
    
}


extension HomeViewController {
    
    // MARK: - 设置导航栏内容
    fileprivate func setupNavgationBar() {

        //不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 设置导航栏
        setupnavigationLeft()
        setupnavigationRight()
    }
    
    fileprivate func setupnavigationLeft() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "homeLogoIcon"), highlightImage: nil, size: nil, target: self, action: #selector(RefreshData))
    }
    
    fileprivate func setupnavigationRight() {
        
        let size = CGSize(width: 40, height: 44)
        
        let historyItem = UIBarButtonItem(image: #imageLiteral(resourceName: "viewHistoryIcon"), highlightImage: nil, size: size, target: self, action: #selector(RefreshData))
        let scanItem = UIBarButtonItem(image: #imageLiteral(resourceName: "scanIcon"), highlightImage: nil, size: size, target: self, action: #selector(presentQRVC))
        let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "searchBtnIcon"), highlightImage: nil, size: size, target: self, action: #selector(gotoSearchVC))
        
        navigationItem.rightBarButtonItems = [searchItem, scanItem, historyItem]
    }
}


/// MARK: - RightBarButtonItemsAction
extension HomeViewController {
    
    func RefreshData() {
        // 获取当前位置视图
        let currentPage = pageContentView.collectionView.contentOffset.x / view.width
        let currentVC = childVcs[Int(currentPage)] as? BaseAnchorViewController
        guard currentVC?.refreshControl?.isRefresh == false else {
            return
        }
        currentVC?.refreshControl?.refreshState = .pulling
        let offSetY = currentVC?.collectionView.contentOffset.y
        let point = CGPoint(x: 0, y: offSetY! - (currentVC?.refreshControl?.MHRefreshOffset)!)
        currentVC?.collectionView.setContentOffset(point, animated: false)
    }
    
    /// 进入二维码界面
    @objc fileprivate func presentQRVC() {
        let qrCodeVC = MHQRCodeController()
        navigationController?.pushViewController(qrCodeVC, animated: true)
    }
    
    /// 进入搜索界面
    @objc fileprivate func gotoSearchVC() {
        
        self.present(searchVC, animated: true, completion: nil)
    }
    
}


// MARK: - PageTitleViewDelegate
extension HomeViewController: PageTitleViewDelegate {
    
    func pageTitleView(_ pageTitleView: PageTitleView, didSelectedIndex index: Int) {
        
        pageContentView.scrollToIndex(index)
    }
}


// MARK: - PageContentViewDelegate
extension HomeViewController: pageContentViewDelegate {
    
    func pageContentView(pageContentView: PageContentView, sourceIndex: Int, targetIndex: Int, progress: Double) {
        
        pageTitleView.setCurrentTitle(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: CGFloat(progress))
    }
}



