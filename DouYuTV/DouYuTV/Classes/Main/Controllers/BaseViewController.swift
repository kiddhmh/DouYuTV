//
//  BaseViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/24.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    var hiddenBlock: ((_ ishidden: Bool, _ animated: Bool) -> Void)?
    
    /// 容器视图
    var contentView: UIView?
    
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
        failedView.delegate = self
        failedView.frame = CGRect(x: 0, y: HmhDevice.navigationBarH, width: HmhDevice.screenW, height: HmhDevice.screenH)
        return failedView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        baseSetupUI()
    }
    
    func loadDataFailed() {
        
        loadDataFinished()
        UIApplication.shared.keyWindow?.addSubview(failedView)
    }
}

extension BaseViewController {
    
    func baseSetupUI() {
        view.addSubview(animImageView)
        
        startAnimation()
    }
    
}


extension BaseViewController: BaseFailedViewDelegate {
    
    /// 切换控制器
    func pushViewController(_ ViewController: UIViewController, _ animated: Bool) {
        let userinfo = ["VC": ViewController, "animated": animated] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name.MHPushViewController, object: nil, userInfo: userinfo)
    }
}


extension BaseViewController {
    
    func startAnimation() {
        animImageView.isHidden = false
        animImageView.startAnimating()
        contentView?.isHidden = true
    }
    
    func loadDataFinished() {
        // 1.停止动画
        animImageView.stopAnimating()
        
        // 2.隐藏animImageView
        animImageView.isHidden = true
        contentView?.isHidden = false
    }
}






