//
//  RecomFaceModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/29.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class RecomFaceModel: AnchorModel {
    
    var anchor_city: String?    //  所在城市
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        anchor_city     <- map["anchor_city"]
    }
    
}
