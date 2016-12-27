//
//  HttpReachability.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/27.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Alamofire


open class HttpReachability {
    
    // 单例
    static let manager: NetworkReachabilityManager = NetworkReachabilityManager(host: "www.baidu.com")!
    
    // 当前网络状态
    static var reachabilityStatus = manager.networkReachabilityStatus
    
    // 状态类型
    public enum HttpStatus {
        case notReachable // notReachable
        case reachable(HttpConnectionType)
    }
    
    // 可联网下的状态类型
    public enum HttpConnectionType {
        case ethernetOrWiFi
        case wwan
    }
    
    // 是否联网
    static var isReachable: Bool { return isEthernetOrWiFi || isOnWWAN }
    
    
    // 是否wifi
    static var isEthernetOrWiFi: Bool { return HttpReachability.reachabilityStatus == .reachable(.ethernetOrWiFi) }
    
    // 是否蜂窝数据
    static var isOnWWAN: Bool { return HttpReachability.reachabilityStatus == .reachable(.wwan) }
    
    // 开启网络监听
    class func startListening() {
        
        manager.listener = { status in
            
            switch status {
            case .notReachable:
                print("网络不可用")
            case .unknown:
                print("未知网络")
            case .reachable(let type):
                switch type {
                case .ethernetOrWiFi:
                    print("当前处于wifi环境")
                case .wwan:
                    print("当前使用蜂窝数据")
                }
            }
        }
        
        manager.startListening()
    }
    
    
    /// 关闭监听
    class func stopListing() {
        manager.stopListening()
    }
    
    
    deinit {
        HttpReachability.manager.stopListening()
    }
    
}


// 结构体或枚举间比较大小
extension HttpReachability.HttpStatus: Equatable {}

/// Returns whether the two network reachability status values are equal.
///
/// - parameter lhs: The left-hand side value to compare.
/// - parameter rhs: The right-hand side value to compare.
///
/// - returns: `true` if the two values are equal, `false` otherwise.
public func ==(lhs: HttpReachability.HttpStatus, rhs: HttpReachability.HttpStatus) -> Bool {
    
    switch (lhs, rhs) {
    case (.notReachable, .notReachable):
        return true
    case let (.reachable(lhsConnectionType), .reachable(rhsConnectionType)):
        return lhsConnectionType == rhsConnectionType
    default:
        return false
    }
}

