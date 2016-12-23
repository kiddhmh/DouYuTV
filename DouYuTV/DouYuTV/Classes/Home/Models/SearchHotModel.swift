//
//  HistoryModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import ObjectMapper

class SearchHotModel: Mappable {
    
    var error: Int?
    var data: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        error <- map["error"]
        data  <- map["data"]
    }
    
}
