//
//  RLMCalendar.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/12.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import RealmSwift

class RLMCalendar: Object {
    
    dynamic var hour: Int = 0       // 小时
    dynamic var minute: Int = 0     // 分钟
    dynamic var weakDay: Int = 1    // 从1(周日)开始
    
}
