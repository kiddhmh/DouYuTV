//
//  MyNetWorkingConfig.swift
//  swift3
//
//  Created by 胡明昊 on 16/11/20.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation

struct MyNetWorkingConfig {
    // 启动广告
    static let ADVERT_DATA = "http://api2.pianke.me/pub/screen"
    
    /// 热门搜索
    static let SEARCH_HISTORY = "http://apiv2.douyucdn.cn/video/search/getTodayTopData"
    
    /// 推荐
    static let RECOMMEND_FACE = "http://capi.douyucdn.cn/api/v1/getVerticalRoom"
    static let RECOMMEND_HOT_GAME = "http://capi.douyucdn.cn/api/v1/getHotCate"
    static let RECOMMEND_BIG_GAME = "http://capi.douyucdn.cn/api/v1/getbigDataRoom"
    static let RECOMMEND_CYCLE = "http://www.douyutv.com/api/v1/slide/6"
    
    // 游戏
    static let MGAME_BIG_DATA = "http://capi.douyucdn.cn/api/homeCate/getHotRoom"
    
    // 手游
    static let GAME_BIG_DATA = "http://capi.douyucdn.cn/api/homeCate/getHotRoom"
    
    // 娱乐
    static let ENMENT_BIG_DATA = "http://capi.douyucdn.cn/api/homeCate/getHotRoom"
    
    // 趣玩
    static let FUN_BIG_DATA = "http://capi.douyucdn.cn/api/homeCate/getHotRoom"
    
    /// 直播
    // 上方导航栏标题
    static let LIVE_TITLE_DATA = "http://capi.douyucdn.cn/api/v1/getColumnList"
    
    /// 全部游戏
    static let LIVE_ALLGAME_DATA = "http://capi.douyucdn.cn/api/v1/live"
    
    /// 直播-每个模块全部房间
    static let LIVE_ALLCOLUMNLIST_DATA = "http://capi.douyucdn.cn/api/v1/getColumnRoom/"
    
    /// 直播上方分类导航条数据
    static let LIVE_NAV_TITLE_DATA = "http://capi.douyucdn.cn/api/v1/getColumnDetail"
    
}


struct MyURL {
    
}
