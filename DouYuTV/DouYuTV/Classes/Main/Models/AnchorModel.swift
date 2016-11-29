//
//  AnchorModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/29.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class AnchorModel: Mappable {
    
    var nickname: String?       //  主播昵称
    var avatar_small: String?   //  主播头像(小)
    var avatar_mid: String?     //  主播头像(中)
    var vertical_src: String?   //  房间图片(大)
    var room_src: String?       //  房间图片(小)
    var game_name: String?      //  房间类型
    var room_name: String?      //  房间名称
    var room_id: Int?           //  房间ID
    var isVertical: Int?        //  是否手机直播(1:手机,0:电脑)
    var online: Int?            //  观看人数
    
    required init?(map: Map) {
        
    }
    
    
     func mapping(map: Map) {
        nickname        <- map["nickname"]
        avatar_small    <- map["avatar_small"]
        avatar_mid      <- map["avatar_mid"]
        vertical_src    <- map["vertical_src"]
        room_src        <- map["room_src"]
        game_name       <- map["game_name"]
        room_name       <- map["room_name"]
        room_id         <- map["room_id"]
        isVertical      <- map["isVertical"]
        online          <- map["online"]
    }
    
}
