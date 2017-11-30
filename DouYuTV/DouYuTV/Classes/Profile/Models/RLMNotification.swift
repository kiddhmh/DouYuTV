//
//  RLMNotification.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/11.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import Foundation
import RealmSwift

class RLMNotification: Object {
    
    dynamic var title = ""          // 标题
    dynamic var subtitle = ""       // 副标题
    dynamic var body = ""           // 内容
    dynamic var attactment = "" // 附件名称(包括后缀)
    
    dynamic var isReapet = false    // 是否重复
    dynamic var timeInteval = 60.0  // 时间间隔
    
    dynamic var calendar: RLMCalendar? = RLMCalendar() //日期
    
    dynamic var coordinateLongitude = ""         // 经度
    dynamic var coordinateLatitude = ""          // 纬度

}
