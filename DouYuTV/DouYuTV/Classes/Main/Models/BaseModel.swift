//
//  BaseModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/29.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseModel: Mappable {
    
    var error: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        error   <- map["error"]
    }
    
}
