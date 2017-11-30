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
import SwiftKeychainWrapper

//MARK: - 定义通用的系统相关参数
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



//MARK: -  定义工具类方法
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
        
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView
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
    
    static let resources: [String] = HmhTools.notiResources()
    
    // 获取本地通知附件文件夹下所有文件
    static func notiResources() -> [String] {
        let resourcePath = Bundle.main.resourcePath! + "/NotificationResource.bundle"
        let filemanager = FileManager.default
        let arr = try? filemanager.contentsOfDirectory(atPath: resourcePath)
        return arr ?? [""]
    }
}


// MARK: - 清理缓存
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


// MARK: - 存储操作
class HmhFileManager: NSObject {
    
// MARK: - UserDefaults
    class func simpleSave(_ value: Any?, forKey: String) {
        
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    class func simpleRead(_ key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    class func simpleRemove(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    
// MARK: - SwiftKeychainWrapper
    class func keychainSave(_ value: String, forKey: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: forKey)
    }
    
    class func keychainRead(_ key:String) -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }
    
    class func keychainremove(_ key:String) -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: key)
    }
    
}


// MARK : - 判断是否是模拟器
struct Platform {
    
    static let isSimulator: Bool = {
        
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()

}

