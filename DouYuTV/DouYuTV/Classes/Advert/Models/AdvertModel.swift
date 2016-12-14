//
//  AdvertModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class AdvertModel: Mappable {
    
    var result: String?
    var picurl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        picurl <- map["data.picurl"]
    }
}
