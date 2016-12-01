//
//  CycleModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/1.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class CycleModel: Mappable {
    
    var id: Int?            // ID
    var title: String?      // 标题
    var pic_url: String?    // 图片地址
    var tv_pic_url: String? // 小图片地址
    var room: AnchorModel?  // 房间信息
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        title       <- map["title"]
        pic_url     <- map["pic_url"]
        tv_pic_url  <- map["tv_pic_url"]
        room        <- map["room"]
    }
    
}
