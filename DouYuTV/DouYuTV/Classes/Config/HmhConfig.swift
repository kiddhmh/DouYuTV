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
    
    /// 首页标题栏
    static let pageTitles: [String] = ["推荐","手游","娱乐","游戏","趣玩"]
    
    /// 直播默认导航栏字体
    static let livePageTitles: [String] = ["常用","全部"]
    
    /// 字体主要颜色
    static let mainTextColor = UIColor(r: 111, g: 121, b: 121, a: 1)
}


struct L {
    static let loading = "正在加载..."
    static let netWorkError = "网络异常"
    static let loadendind = "数据加载完毕"
    
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
}


extension Notification.Name {
    
    /// 切换控制器通知
    public static let MHPushViewController: Notification.Name = Notification.Name(rawValue: "MHPushViewController")
    
    /// 切换TabbarController
    public static let MHChangeSelectedController: Notification.Name = Notification.Name("MHChangeSelectedController")
}

