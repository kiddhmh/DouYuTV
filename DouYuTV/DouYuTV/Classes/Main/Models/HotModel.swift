//
//  HotBaseModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/30.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class HotModel: Mappable {
    
    var room_list: [AnchorModel]?   //  房间数组
    var icon_url: String?           //  类型头像
    var tag_name: String?           //  类型名称
    var tag_id: String?                //  类型标示
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        room_list   <-  map["room_list"]
        icon_url    <-  map["icon_url"]
        tag_name    <-  map["tag_name"]
        tag_id      <-  map["tag_id"]
    }
    
}
