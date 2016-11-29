//
//  BaseNavigationController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override class func initialize() {
        //设置导航栏背景色
        UINavigationBar.appearance().barTintColor = C.mainColor
    }
    
    override func viewDidLoad() {
        //去掉导航栏下方的线
//        navigationBar.isTranslucent = false
//        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        navigationBar.shadowImage = UIImage()
    }
    
    
}
