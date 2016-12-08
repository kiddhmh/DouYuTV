//
//  LiveTitleModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class LiveTitleModel: Mappable {
    
    var cate_id: String?    // ID
    var cate_name: String?  // 类型名称
    var short_name: String? // 简称
    var push_ios: String?
    var push_show: String?
    var push_vertical_screen: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        cate_id <- map["cate_id"]
        cate_name               <- map["cate_name"]
        short_name              <- map["short_name"]
        push_ios                <- map["push_ios"]
        push_show               <- map["push_show"]
        push_vertical_screen    <- map["push_vertical_screen"]
        
    }
}
