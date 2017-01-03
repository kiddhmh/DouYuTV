//
//  YKLiveModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/3.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class YKLiveModel: Mappable {
    
    var share_addr: String?     // 分享链接
    var stream_addr: String?    // 拉流地址
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        
        share_addr  <- map["share_addr"]
        stream_addr <- map["stream_addr"]
    }
}
