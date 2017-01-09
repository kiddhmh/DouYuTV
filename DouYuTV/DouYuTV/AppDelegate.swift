//
//  AppDelegate.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 清除缓存
        MHCache.mh_clearAllCache()
        
        // 开始网络监听
        HttpReachability.startListening()
        
        // 配置友盟
        setupUmengShare()
        
        // 配置推送
        setupPushServers(launchOptions)
        
        // 判断用户是否点击通知进入
        let enterPlayVC: moreBtnClosure = { [unowned self] in
            
            let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
            
            if remoteNotification != nil { // 一般是根据服务端返回的json判断应该去哪个页面，这里统一进入直播页面
                self.gotoPlayerVC()
            }
        }
        
        let window = UIWindow(frame: HmhDevice.screenRect)
        self.window = window
        
        let baseVC = HmhTools.createViewController("Main", identifier: "BaseTabBarController") as? UITabBarController
        
        let advertVC = AdvertController()
        advertVC.jumpClosure = { [unowned self] in    // 广告到时间，切换控制器
            self.window?.rootViewController = baseVC
            enterPlayVC()
        }
        
        self.window?.rootViewController = advertVC
        
        self.window?.makeKeyAndVisible()

        return true
    }

    fileprivate func gotoPlayerVC() {
        let livePlayVC = LivePrettyController()
        self.window?.rootViewController?.present(livePlayVC, animated: true, completion: nil)
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
    
    
    // 配置推送
    private func setupPushServers(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

        // 3.0 之前旧注册方法
//        if #available(iOS 10.0, *) {
//            let entity = JPUSHRegisterEntity()
//            entity.types = Int(UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.badge.rawValue | UNAuthorizationOptions.sound.rawValue)
//            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
//            
//        }else if #available(iOS 8.0, *) {
//            
//            let types = UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue
//            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
//        }
        
        // 3.0 之后新的注册方法
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
        
        
        let version = (UIDevice.current.systemVersion as NSString).floatValue
        if version >= 8.0 {
            //可以添加自定义categories
            // NSSet<UNNotificationCategory *> *categories for iOS10 or later
            // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        }
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        /*
         appKey
         填写管理Portal上创建应用后自动生成的AppKey值。请确保应用内配置的 AppKey 与 Portal 上创建应用后生成的 AppKey 一致。
         channel
         指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
         apsForProduction
         1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。
         0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
         注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
        */
        JPUSHService.setup(withOption: launchOptions, appKey: JPush.AppKey, channel: "App Store", apsForProduction: false)
        
        //监听注册成功
        NotificationCenter.default.addObserver(self, selector: #selector(setupTagsAndAlias), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
    }
    
    
    // 注册成功后打标签和别名
    @objc private func setupTagsAndAlias() {
        
        // 打上标签和别名，针对不同的用户进行推送，这里只是模拟下，实际开发会根据用户信息进行设置
        var tags = Set<String>()
        tags.insert("Kiddhmh")
        let vaildTags = JPUSHService.filterValidTags(tags)
        JPUSHService.setTags(vaildTags, alias: "Kiddhmh") { (iResCode,  iTags, ialias) in
            print("result ===>>> iResCode = \(iResCode) \n iTags = \(iTags) \n ialias = \(ialias)")
        }
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
    
    
    // 注册deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    // 注册失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    
    // 收到推送
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        JPUSHService.handleRemoteNotification(userInfo)
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
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // 每次点击进入应用，清空角标和通知
        JPUSHService.setBadge(0)
        JPUSHService.resetBadge()
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

@available(iOS 10.0, *)
extension AppDelegate: JPUSHRegisterDelegate {
    
    
    // 接收到通知
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
     
        let userInfo = notification.request.content.userInfo
        
        let request = notification.request // 收到推送的请求
        let content = request.content      // 收到推送的消息内容
        
        let badge = content.badge          // 推送消息的角标
        let body = content.body            // 推送的消息体
        let sound = content.sound          // 推送消息的声音
        let subtitle = content.subtitle    // 推送消息的副标题
        let title = content.title          // 推送消息的标题
        
        
        if request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true { // 远程通知
            
            JPUSHService.handleRemoteNotification(userInfo)
            print("收到了远程通知 ==>> badge = \(badge) \n body = \(body) \n sound = \(sound) \n subtitle = \(subtitle) \n title = \(title)")
            
        }else { // 本地通知
            print("收到了本地通知 ==>> badge = \(badge) \n body = \(body) \n sound = \(sound) \n subtitle = \(subtitle) \n title = \(title)")
        }
        
        let options = Int(UNNotificationPresentationOptions.alert.rawValue | UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.badge.rawValue)
        
        completionHandler(options) // 需要执行这个方法，选择是否提醒用户
    }
    
    
    // 点击收到的通知进入app
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo
        let request = response.notification.request // 收到推送的请求
        let content = request.content               // 收到推送的消息内容
        
        let badge = content.badge          // 推送消息的角标
        let body = content.body            // 推送的消息体
        let sound = content.sound          // 推送消息的声音
        let subtitle = content.subtitle    // 推送消息的副标题
        let title = content.title          // 推送消息的标题
        
        if request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {// 远程通知
            JPUSHService.handleRemoteNotification(userInfo)
            print("收到了远程通知 ==>> badge = \(badge) \n body = \(body) \n sound = \(sound) \n subtitle = \(subtitle) \n title = \(title)")
            
        }else { // 本地通知
            
            print("收到了本地通知 ==>> badge = \(badge) \n body = \(body) \n sound = \(sound) \n subtitle = \(subtitle) \n title = \(title)")
        }
    
        
        // 收到通知，跳转到对应界面
        if UIApplication.shared.applicationState == .active { // 在前台
            
            let alertVC = UIAlertController(title: "提示", message: "白富美主播已上线,是否前往观看", preferredStyle: .alert)
            let sureAction = UIAlertAction(title: "火速前往", style: .default, handler: { (action) in
                self.gotoPlayerVC()
            })
            let cancelAction = UIAlertAction(title: "我还是个孩子", style: .cancel) { (action) in
                alertVC.dismiss(animated: true, completion: nil)
            }
            
            alertVC.addAction(cancelAction)
            alertVC.addAction(sureAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
        }else { // 后台
            gotoPlayerVC()
        }
        
        completionHandler()  // 系统要求执行这个方法
    }

}
