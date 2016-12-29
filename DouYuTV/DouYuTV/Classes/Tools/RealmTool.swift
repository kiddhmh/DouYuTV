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
        
//        let filePath = path.appendingPathComponent(name)
//        print("数据库目录\(filePath)")
//        if !FileManager.default.fileExists(atPath: filePath) {
//            RealmTool.creatRealmWithName(name)
//        }
//        
//        Tips: 该方法创建的只是默认的Realm数据库，自定义需另创建
//        return try! Realm()
        
        return creatRealmWithName(name)
    }
    
    
    // 创建指定Realm数据库
    private class func creatRealmWithName(_ name: String!) -> Realm {
    
        let filePath = path.appendingPathComponent(name! + ".realm")

        print("数据库目录 ===>>> \(filePath)")
        
        var config = Realm.Configuration()
        config.fileURL = URL(string: filePath)
        Realm.Configuration.defaultConfiguration = config
        return try! Realm(configuration: config)
    }
    
    
    // 添加一个对象
    class func addObject(_ user: RLMUser) -> Bool {
        
        // 先判断是否存在该对象
        let oldObject = userReaml.objects(RLMUser.self)
        guard oldObject.count != 0 else { // 第一次创建用户
            try! userReaml.write {
                userReaml.add(user)
            }
            return true
        }
        
        // Tips: 注意后面 predicate 的格式，否则会crash
        let simpleUser = oldObject.filter("name = %@",user.name)
//        let simpleUser = oldObject.filter("name = '\(user.name)'")
        guard simpleUser.count == 0 else { // 昵称已存在
            return false
        }
        
        try! userReaml.write {
            userReaml.add(user)
        }
        return true
    }
    
}
