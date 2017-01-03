//
//  YKTotalModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/3.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class YKTotalModel: Mappable {
    
    var dm_error: String?
    var error_msg: String?
    var lives: [YKLiveModel]?
    var expire_time: Int?
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        
        dm_error    <- map["dm_error"]
        error_msg   <- map["error_msg"]
        lives       <- map["lives"]
        expire_time <- map["expire_time"]
    }
}
