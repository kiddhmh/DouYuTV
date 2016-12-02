//
//  HmhConfig.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import UIKit


struct C {
    
    /// 导航栏是否隐藏
    static var isNavBarHidden = false
    
    /// 系统主要颜色
    static let mainColor = #imageLiteral(resourceName: "Img_orange").getColorCustom()
    
    /// 首页标题栏
    static let pageTitles: [String] = ["推荐","游戏","娱乐","手游","趣玩"]
    
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
    
}


struct CellID {
    static let  PageContentViewCellID: String = "PageContentViewCellID"
    
    static let RecommentCellID: String = "RecommentCellID"
    
    static let RecommendSectionHeaderID: String = "RecommendSectionHeaderID"
    
    static let RecommentPrettyCellID: String = "RecommentPrettyCellID"
}
