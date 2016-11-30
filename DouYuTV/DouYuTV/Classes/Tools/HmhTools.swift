//
//  HmhTools.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import UIKit

/// 定义通用的系统相关参数
struct HmhDevice {
    
    ///获取屏幕尺寸
    static let screenRect = UIScreen.main.bounds
    
    /// 获取屏幕的高度
    static let screenH = UIScreen.main.bounds.size.height
    
    /// 获取屏幕的宽度
    static let screenW = UIScreen.main.bounds.size.width
    
    /// 获取navigationBar的高度
    static let navigationBarH: CGFloat = 64
    
    static let kStatusBarH: CGFloat = 20
    static let kNavigationBarH: CGFloat = 44
    static let kTabbarH: CGFloat = 44

    
    /// 获取tabBar的高度
    static let tabBarH: CGFloat = 49
    
    /// 获取系统版本
    static let systemVersion = Float(UIDevice.current.systemName)
    
    /// 获取app的版本号
    static let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    
    /// 获取bundle版本号
    static let appBundleVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    
    
    static func isiPhone4() -> Bool {
        return screenH == 480
    }
    
    static func isiPhone5s() -> Bool {
        return screenH == 1136
    }
    
    static func isiPhone6() -> Bool {
        return screenW == 375
    }
    
    static func isiPhone6p() -> Bool {
        return screenW == 414
    }
}



/// 定义工具类方法
struct HmhTools {
    
    //通过storyboardName和identifier初始化controller的工具方法.
    static func createViewController(_ storyboradName: String, identifier: String? = nil) -> UIViewController? {
        let sb = UIStoryboard(name: storyboradName, bundle: nil)
        
        guard let identifier = identifier  else {
            return sb.instantiateInitialViewController()
        }
        return sb.instantiateViewController(withIdentifier: identifier)
    }
    
    
    // 通过xib创建视图
    static func createView(_ nibName: String) -> UIView? {
        
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.last as? UIView
    }
    
    
    // 换算在线人数
    static func handleNumber(_ number: Int?) -> String {
        guard let number = number else {
            return ""
        }
        if number < 10000 {
            return "\(number)"
        }else {
            let new = Double(number / 1000) / 10.0
            return "\(new)万"
        }
    }
}










