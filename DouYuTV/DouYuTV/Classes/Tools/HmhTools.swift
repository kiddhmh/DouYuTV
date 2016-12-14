//
//  HmhTools.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

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


class MHCache: NSObject {
    
    
    /// 判断该图片是否缓存
    public class func mh_isCache(_ key: String?) -> Bool {
        
        let cache = KingfisherManager.shared.cache
        let result = cache.isImageCached(forKey: key!)
        return result.cached
    }
    
    
    /// 从磁盘里读取缓存的图片(默认路径)
    public class func mh_readImage(_ name: String?) -> UIImage {
        
        let cache = KingfisherManager.shared.cache
        let image = cache.retrieveImageInDiskCache(forKey: name!)
        return image!
    }
    
    /// 清除所有缓存
    public class func mh_clearAllCache() {
        let cache = KingfisherManager.shared.cache
        cache.clearDiskCache()//清除硬盘缓存
        cache.clearMemoryCache()//清理网络缓存
        cache.cleanExpiredDiskCache()//清理过期的，或者超过硬盘限制大小的
    }
    
}





