//
//  HotBaseModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/30.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class HotBaseModel: BaseModel {
    
    var data: [HotModel]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data    <- map["data"]
    }
    
}
