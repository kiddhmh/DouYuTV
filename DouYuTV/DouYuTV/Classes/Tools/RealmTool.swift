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
    
    // 添加一个用户
    class func addObject(_ user: RLMUser) -> Bool {
        
        // 先判断是否存在该对象
        let oldObject = userReaml.objects(RLMUser.self)
        guard oldObject.count != 0 else { // 第一次创建用户
            try! userReaml.write {
                userReaml.add(user)
            }
            return true
        }
        
        // 判断用户名是否重复
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
    
    
    /// 判断是否能登录
    ///
    /// - Parameters:
    ///   - name: 昵称
    ///   - password: 密码
    /// - Returns: 返回值是一个元组(是否成功登录，提示信息)
    class func isRightToLogin(_ name: String, _ password: String, complection: (_ user: RLMUser) -> ()) -> (Bool,String) {
        
        // 用户名是否正确
        let userResults = userReaml.objects(RLMUser.self).filter("name = %@",name)
        guard userResults.count == 1 else {
            return (false, "用户不存在")
        }
        
        // 判断密码是否正确
        let pass = userResults.first?.Password
        guard pass == password else {
            return (false, "密码不正确")
        }
        
        complection(userResults.first!)
        return (true, "登录成功")
    }
    
    
    // 通过昵称查询用户
    class func searchUser(name: String) -> Results<RLMUser> {
        
        let userResult = userReaml.objects(RLMUser.self).filter("name = %@",name)
        return userResult
    }
    
    // 查找第三方登录是否登录过
    class func isRegister(_ user: RLMUser) -> Bool {
        
        let userResult = userReaml.objects(RLMUser.self).filter("uid = %@",user.uid)
        return userResult.count == 0 ? false : true
    }
}
