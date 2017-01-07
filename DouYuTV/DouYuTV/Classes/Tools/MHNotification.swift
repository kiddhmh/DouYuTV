//
//  NotifierProtocol.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/5.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit

// MAEK: - protocol
public protocol Notifier {
    associatedtype Notification: RawRepresentable
}


public extension Notifier where Notification.RawValue == String {
    
    // MARK: - Static Computed Variables
    
    private static func nameFor(_ notification: Notification) -> NSNotification.Name {
        
        let name = "\(self).\(notification.rawValue)"
        return NSNotification.Name(name)
    }
    
    // MARK: - Instance Methods
    
    // Post
    
    static func postNotification(notification: Notification, object: Any? = nil, userInfo: [String : Any]? = nil) {
        
        let name = nameFor(notification)
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    // Add
    
    static func addObserver(observer: Any, selector: Selector, notification: Notification) {
        let name = nameFor(notification)
        
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    // Remove
    
    static func removeObserver(observer: Any, notification: Notification, object: Any? = nil) {
        let name = nameFor(notification)
        
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }
    
    static func removeAll(observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
}

class MHNotification: Notifier {
    
    enum Notification: String {
        case pushVC                 /// 切换控制器通知
        case changeSelectedVC       /// 切换TabbarController
        case showLogin              /// 我的页面显示登录注册
        case loginSuccess           /// 登录成功
    }
}

