//
//  RealmTool.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/28.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import RealmSwift

private let UserRealm = "UserRealm"

class RealmTool: NSObject {
    
    static let path: NSString = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "") as NSString
    
    // 获取用户数据库
    static let userReaml: Realm = RealmTool.customRealm(withName: UserRealm)
    
    // 读取指定Realm数据库
    class func customRealm(withName name: String!) -> Realm {
        
        let filePath = path.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: filePath) {
            RealmTool.creatRealmWithName(name)
        }
        
        return try! Realm()
    }
    
    
    // 创建指定Realm数据库
    private class func creatRealmWithName(_ name: String!) {
        
        let filePath = path.appendingPathComponent(name)
        print("数据库目录\(filePath)")
        
        var config = Realm.Configuration()
        config.fileURL = URL(string: filePath)
        Realm.Configuration.defaultConfiguration = config
    }
    
    
}
