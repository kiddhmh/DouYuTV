//
//  HttpClient.swift
//  swift3
//
//  Created by 胡明昊 on 16/11/20.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

enum HttpMethod {
    case get
    case post
}


class HttpClient: NSObject {
    
    //创建单例对象
    fileprivate static let instance: HttpClient = HttpClient()
    
    //提供方法访问
    class func sharedHttpClient() -> HttpClient {
        return instance
    }
    
    //get 请求
    func get(_ URLString: String, parameters: [String: Any]? = nil, complection: @escaping (_ response: MyHttpResponse) -> Void) -> MyHttpRequest {
        
        let url = URLString
        
        let parameter = parameters == nil ? parameters : HttpApiSign.configGetMethodWithParam(parameters)
        
        let request = HttpDriver.get(URLString: url, parameters: parameter, header: nil) {
            [weak self] response in
            
            if self != nil {
                var httpResponseState: HttpResponseState
                
                switch response.state {
                case .Success(let value):
                    httpResponseState = self!.handleResponse(value)
                case .Error(let value):
                    let error = MyError(errorType: .network)
                    error.subcode = value.subcode
                    error.errorMessage = "网络异常"
                    httpResponseState = HttpResponseState.Error(error)
                }
                
                let response = MyHttpResponse(state: httpResponseState)
                complection(response)
            }
        }
        
        
        return request
    }
    
    
    
    //post 请求
    func post(_ URLString: String, paramters: [String: Any]? = nil,complection: @escaping (_ response: MyHttpResponse) -> Void) -> MyHttpRequest {
        
        let url = URLString
        var jsonData: Data? = nil
        
        var jsonString: String? = nil
        
        if let paramters = paramters {
            
            jsonData = try? JSONSerialization.data(withJSONObject: paramters, options: [])
            jsonString = String(NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)!)
            
            print("\(jsonString)")
        }
        
        let request = HttpDriver.post(URL: url, data: jsonData, headers: nil) { [weak self] response in
            
            if self != nil {
                var httpResponseState: HttpResponseState
                
                switch response.state {
                case .Success(let value):
                    httpResponseState = self!.handleResponse(value)
                case .Error(let value):
                    let error = MyError(errorType: .network)
                    error.subcode = value.subcode
                    error.errorMessage = "网络异常"
                    httpResponseState = HttpResponseState.Error(error)
                }
                
                let responsee = MyHttpResponse(state: httpResponseState)
                complection(responsee)
            }
        }
        
        return request
    }
}


extension HttpClient {
    
    struct Const {
        static let MsgKey = "error"
        static let DataKey = "data"
    }
    
    struct ResponseCode {
        static let successCode = 0
    }
    
}



extension HttpClient {
    
    fileprivate func handleResponse(_ value: Any?) -> HttpResponseState {
        
        var httpResponseState: HttpResponseState
        
        if  let value = value {
            
            let dic = value as? NSDictionary
            if let dic = dic {
                let allKeys = dic.allKeys
                let res1 = allKeys.contains(where: { (key) -> Bool in
                    (key as! String) == Const.MsgKey
                })
                let res2 = allKeys.contains(where: { (key) -> Bool in
                    (key as! String) == Const.DataKey
                })
                
                if res1 == true && res2 == true {
                    let code = dic[Const.MsgKey] as! Int
                    
                    if code == ResponseCode.successCode {
//                        let dataValue = dic[Const.DataKey]!
// MARK: - 根据实际情况自定义
                        httpResponseState = HttpResponseState.Success(value)
                    }else {
                        
                        let error = MyError(errorType: .api)
                        error.errorMessage = dic[Const.MsgKey] as? String
                        httpResponseState = HttpResponseState.Error(error)
                    }
                }else {
                    
                    let error = MyError(errorType: .apiFormatter)
                    error.errorMessage = "返回的数据结构不是定义的格式"
                    httpResponseState = HttpResponseState.Error(error)
                    
                    var jsonString:String? = nil
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: dic, options:[])
                    jsonString = String(NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)!)
                    
                    print("返回的是:\(jsonString)")
                }
            }else {
                    let error = MyError(errorType: .other)
                    error.errorMessage = "返回的数据结构不是字典"
                    httpResponseState = HttpResponseState.Error(error)
                    
                }
            }else {
                let error = MyError(errorType: .other)
                error.errorMessage = "返回的数据结构不是字典"
                httpResponseState = HttpResponseState.Error(error)
            }
        return httpResponseState
    }
    
}





