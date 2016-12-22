//
//  ProfileInforController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

private let kBottomH: CGFloat = 80

class ProfileInforController: UIViewController {
    
    fileprivate lazy var bottomView: ProfileInfoBottomView = {
        let bottomView = ProfileInfoBottomView(frame: CGRect(x: 0, y: HmhDevice.screenH - kBottomH, width: HmhDevice.screenW, height: kBottomH))
        return bottomView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "个人信息"
        
        view.backgroundColor = .randomColor
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(bottomView)
        bottomView.outLoginClosure = { [weak self] in
            // 显示退出成功并返回上级界面
            MBProgressHUD.showSuccess("退出成功")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: { 
                _ = self?.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name.MHSHowLogin, object: nil)
            })
        }
    }
    
}
