//
//  RLMUser.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/28.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import RealmSwift

class RLMUser: Object {
    
    // 用户数据
    dynamic var name = ""                   // 用户名
    dynamic var Password = ""               // 用户密码
    dynamic var iconurl = ""                // 用户头像
    
    dynamic var gender = "m"                     //性别（m表示男，w表示女）
    
    // 授权数据
    dynamic var uid = ""                    //用户id
    dynamic var openid = ""                 //QQ，微信用户openid，其他平台没有
    dynamic var accessToken = ""
    dynamic var refreshToken = ""
    dynamic var expiration: NSDate? = nil   //授权token（accessToken）过期时间
    
    // 原始数据
    dynamic var originalResponse: NSData? = nil
}
