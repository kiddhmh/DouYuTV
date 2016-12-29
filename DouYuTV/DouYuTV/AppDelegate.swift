//
//  AppDelegate.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 清除缓存
        MHCache.mh_clearAllCache()
        
        // 开始网络监听
        HttpReachability.startListening()
        
        setupUmengShare()
        
        let window = UIWindow(frame: HmhDevice.screenRect)
        self.window = window
        
        let baseVC = HmhTools.createViewController("Main", identifier: "BaseTabBarController")
        
        let advertVC = AdvertController()
        advertVC.jumpClosure = {    // 广告到时间，切换控制器
            self.window?.rootViewController = baseVC
        }
        
        self.window?.rootViewController = advertVC
        
        self.window?.makeKeyAndVisible()

        return true
    }

    // 设置友盟
    private func setupUmengShare() {
        
        // 打开调试日志
        UMSocialManager.default().openLog(true)
        
        // 设置appkey
        UMSocialManager.default().umSocialAppkey = UMengShare.AppKey
        
        //设置微信的appKey和appSecret
        UMSocialManager.default().setPlaform(.wechatSession, appKey: UMengShare.WxAppKey, appSecret: UMengShare.WxAppSecret, redirectURL: "http://mobile.umeng.com/social")
        
        //设置分享到QQ互联的appKey和appSecret
        // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
        UMSocialManager.default().setPlaform(.QQ, appKey: UMengShare.QQAppID, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        
        //设置新浪的appKey和appSecret
        UMSocialManager.default().setPlaform(.sina, appKey: UMengShare.SinaAppKey, appSecret: UMengShare.SinaAppSecret, redirectURL: "http://sns.whalecloud.com/sina2/callback")
    }
    
    
    // 支持所有iOS系统
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let result = UMSocialManager.default().handleOpen(url)
        if !result { // 其他如支付等SDK的回调
            
        }
        
        return result
    }
    
    
    // 仅支持iOS9以上系统，iOS8及以下系统不会回调
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let result = UMSocialManager.default().handleOpen(url)
        if !result { // 其他如支付等SDK的回调
            
        }
        
        return result
    }
    
    
    // 支持目前所有iOS系统
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {

        let result = UMSocialManager.default().handleOpen(url)
        if !result { // 其他如支付等SDK的回调
            
        }
        
        return result
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

