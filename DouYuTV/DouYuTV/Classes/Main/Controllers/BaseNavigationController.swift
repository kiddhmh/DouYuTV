//
//  BaseNavigationController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    override class func initialize() {
        //设置导航栏背景色
        UINavigationBar.appearance().barTintColor = C.mainColor
    }
    
    override func viewDidLoad() {
        //去掉导航栏下方的线
//        navigationBar.isTranslucent = false
//        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        navigationBar.shadowImage = UIImage()
        
        // 设置标题属性
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        
        let selector = NSSelectorFromString("interactivePopGestureRecognizer")
        if self.responds(to: selector) { //重新签代理
            self.interactivePopGestureRecognizer?.delegate = self
        }
        
        // 获取系统的Pop手势
        guard let systemges = interactivePopGestureRecognizer else { return }
        
        // 获取手势添加到的view中
        guard let gesView = systemges.view else { return }
        
        // 利用runtime查看所有属性名称
        /*
            var count: UInt32 = 0
            let ivas = class_copyIvarList(UIGestureRecognizer.self, &count)!
        
            for i in 0..<count {
                let ivar = ivas[Int(i)]
                let name = ivar_getName(ivar)
                print(String(cString: name!))
            }
         */
        let targets = systemges.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        
        // 取出target
        guard let target = targetObjc.value(forKey: "target") else { return }
        
        // 取出action
        let action = Selector(("handleNavigationTransition:"))
        
        // 创建自定义的Pan手势
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
    }

    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navBackBtn"), highlightImage: #imageLiteral(resourceName: "navBackBtnHL"), size: CGSize(width: 18, height: 18), target: self, action: #selector(popToParent))
            
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popToParent(){
        
        popViewController(animated: true)
    }
}

