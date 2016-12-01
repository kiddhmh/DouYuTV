//
//  BaseModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/29.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseModel<T: Mappable>: Mappable {
    
    var error: Int?
    var data: [T]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        error   <- map["error"]
        data    <- map["data"]
    }
    
}
