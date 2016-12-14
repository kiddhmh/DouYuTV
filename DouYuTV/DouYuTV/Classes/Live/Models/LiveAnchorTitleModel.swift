//
//  LiveAnchorTitleModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/14.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class LiveAnchorTitleModel: Mappable {
    
    var tag_id: String?     //获取某类别数据id
    var short_name: String?	//属于哪个大类别，例如“移动游戏”
    var tag_name: String?   //属于哪个小类别，例如“王者荣耀”
    var pic_name: String?	//图片名称
    var pic_name2: String?	//图片名称2
    var icon_name: String?	//图标名称
    var small_icon_name: String?	//小图标名称
    var cate_id: String?
    var pic_url: String?        //图片地址
    var url: String?
    var icon_url: String?   //图标地址
    var small_icon_url: String? //小图标地址
    var count: Int?          //房间总数量
    var count_ios: Int?      //ios
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        tag_id          <- map["tag_id"]
        short_name      <- map["short_name"]
        tag_name        <- map["tag_name"]
        pic_name        <- map["pic_name"]
        pic_name2       <- map["pic_name2"]
        icon_name       <- map["icon_name"]
        small_icon_name <- map["small_icon_name"]
        cate_id         <- map["cate_id"]
        pic_url         <- map["pic_url"]
        url             <- map["url"]
        icon_url        <- map["icon_url"]
        small_icon_url  <- map["small_icon_url"]
        count           <- map["count"]
        count_ios       <- map["count_ios"]
    }
    
}
