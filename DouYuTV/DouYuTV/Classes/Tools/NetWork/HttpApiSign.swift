//
//  HttpApiSign.swift
//  swift3
//
//  Created by 胡明昊 on 16/11/20.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation

class HttpApiSign: NSObject {
    
    
    /// 封装get请求的参数
    class func configGetMethodWithParam(_ param: [String : AnyObject]?) -> [String : AnyObject] {
        
        var paramDic = [String : AnyObject]()
        
        // 暂时不需要封装参数,So...
        paramDic = param!
        
        return paramDic
    }
    
    
    /**
     封装Post的请求的URL.
     */
    
//    class func configPostMethodURL(_ url:String, param:Dictionary<String, AnyObject>?) -> String {
//        
//        let token = MyManager.simpleRead("venderToken")
//        var jsonString:String? = nil
//        
//        //        var jsonString:String? = nil
//        //
//        //        if let param = param {
//        //            let jsonData = try? NSJSONSerialization.dataWithJSONObject(param, options:[])
//        //            jsonString = String(NSString(data: jsonData!, encoding: NSUTF8StringEncoding)!)
//        //        }
//        
//        //        var timestamp = Int(NSDate.nowDate().toTimestamp())!/1000
//        
//        //        let timestamp = Int(NSDate().timeIntervalSince1970/1000)
//        let timestamp = Date().timeIntervalSince1970
//        print("timestamp:  \(timestamp)")
//        
//        
//        var paramsArray = [String]()
//        
//        var apiSign = MyNetWorkingConfig.appId + String(timestamp)
//        apiSign = MyDataEncoding.EndcodeAesEcb(apiSign)
//        
//        apiSign = apiSign.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        
//        paramsArray.append("\(MyNetWorkingConfig.BaseNetworkParam.SignKey)=\(apiSign)")
//        paramsArray.append("\(MyNetWorkingConfig.BaseNetworkParam.AppIdKey)=\(MyNetWorkingConfig.appId)")
//        paramsArray.append("\(MyNetWorkingConfig.BaseNetworkParam.TimestampKey)=\(timestamp)")
//        if token != nil {
//            paramsArray.append("\(MyNetWorkingConfig.BaseNetworkParam.TokenKey)=\(token)")
//        }
//        
//        //        guard token == nil else{
//        //            paramsArray.append("\(AJHNetworkConfig.BaseNetworkParam.TokenKey)=\(token)")
//        //            return ""
//        //        }
//        
//        
//        //        paramsArray.append("\(AJHNetworkConfig.BaseNetworkParam.TokenKey)=\(OpenUDID.value())")
//        
//        var urlString = url
//        
//        urlString = "\(urlString)?\(paramsArray.joined(separator: "&"))"
//        
//        return urlString
//    }
    
    
    
}



extension Date {
    
    
    /// 时间转时间戳
    public func toTimestamp() -> String {
        return "\(Int(self.timeIntervalSince1970))"
    }
    
    /**
     获取当前的时间，已经做了本地化处理.
     */
    public static func nowDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return date.addingTimeInterval(Double(interval))
    }
    
}
