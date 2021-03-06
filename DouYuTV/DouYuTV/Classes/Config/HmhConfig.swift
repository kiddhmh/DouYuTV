//
//  HmhConfig.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import UIKit

/// 点击更多按钮回调
public typealias moreBtnClosure = () -> ()

/// 直播页面标题数据回调
public typealias reciveTitleClosure = (_ titles: AnyObject) -> ()


struct C {
    
    /// 导航栏是否隐藏
    static var isNavBarHidden = false
    
    /// 直播页面导航栏是否隐藏
    static var isLiveNavBarHidden = false
    
    /// 系统主要颜色
    static let mainColor = #imageLiteral(resourceName: "Img_orange").getColorCustom()
    
    /// 登录按钮高亮颜色
    static let loginColor = UIColor(r: 255, g: 60, b: 30, a: 1)
    
    /// 注册图片颜色
    static let registerColor = UIColor(r: 102, g: 102, b: 102, a: 1)
    
    /// 首页标题栏
    static let pageTitles: [String] = ["推荐","手游","娱乐","游戏","趣玩"]
    
    /// 直播默认导航栏字体
    static let livePageTitles: [String] = ["常用","全部"]
    
    /// 关注导航栏字体
    static let profileTitles: [String] = ["直播关注","视频订阅"]
    
    /// 字体主要颜色
    static let mainTextColor = UIColor(r: 111, g: 121, b: 121, a: 1)
    
    /// 下拉框选中颜色
    static let column_selectedColor = UIColor(r: 221, g: 221, b: 221)
    
    /// 下拉框普通颜色
    static let column_normalColor = UIColor(r: 205, g: 205, b: 205)
    
}


struct L {
    static let loading = "正在加载..."
    static let netWorkError = "网络异常"
    static let loadendind = "数据加载完毕"
    static let nodatamessage = "暂无直播，去其它栏目看看吧~"
}


struct S {
    /// PageTitleController
    static let scrollLineH: CGFloat = 3
    
    static let normalTextColor: UIColor = UIColor(r: 85, g: 85, b: 85)
    
    static let selectTextColor: UIColor = C.mainColor
    
    static let titleMargin: CGFloat = 20
    
    static let scrollLineMargin: CGFloat = 10
    
    /// headerViewH 顶部视图高度
    static let GameViewH: CGFloat = 90
    
    static let NormalInsertH: CGFloat = 5
    
    // collectionView顶部View
    static let ColHeaderViewH: CGFloat = 200
    
    
    /// Live
}


struct CellID {
    static let  PageContentViewCellID: String = "PageContentViewCellID"
    
    static let RecommentCellID: String = "RecommentCellID"
    
    static let RecommendSectionHeaderID: String = "RecommendSectionHeaderID"
    
    static let LiveSectionFooterID: String = "LiveSectionFooterID"
    
    static let RecommentPrettyCellID: String = "RecommentPrettyCellID"
    
    static let RecommentGameCellID: String = "RecomGameCellID"
    
    static let SearchHistoryCellID: String = "SearchHistoryCellID"
}


struct UMengShare {
    // 友盟AppKey
    static let AppKey = "58626ace677baa5cbd0014b2"
    
    // 新浪AppKey
    static let SinaAppKey = "1869182749"
    
    // 新浪AppSecret
    static let SinaAppSecret = "115301c2cc3aca99217fb388b509cfa1"
    
    // 微信AppKey
    static let WxAppKey = "wxcd9c96144414fec1"
    
    // 微信AppSrcret
    static let WxAppSecret = "88cbdf062de5bc62aa643a612e24706f"
    
    // QQAppID
    static let QQAppID = "1105841373"
    
    // QQAppKey
    static let QQAppKey = "k3qZrMKr8anTgPcE"
}

struct JPush {
    
    static let AppKey = "0484002110ef506719c9ca1e"
    
    static let MasterSecret = "cd90841d9eefc4b28eeb2cc4"
}

//extension Notification.Name {
//    
//    /// 切换控制器通知
//    public static let MHPushViewController: Notification.Name = Notification.Name(rawValue: "MHPushViewController")
//    
//    /// 切换TabbarController
//    public static let MHChangeSelectedController: Notification.Name = Notification.Name("MHChangeSelectedController")
//    
//    /// 我的页面显示登录注册
//    public static let MHSHowLogin: Notification.Name = Notification.Name("MHSHowLogin")
//    
//    /// 登录成功
//    public static let LoginSuccess: Notification.Name = Notification.Name("LoginSuccess")
//}

