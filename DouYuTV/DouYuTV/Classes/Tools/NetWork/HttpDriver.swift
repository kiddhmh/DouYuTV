//
//  HttpDriver.swift
//  swift3
//
//  Created by 胡明昊 on 16/11/18.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Alamofire

enum HttpResponseState {
    case Success(Any)
    case Error(MyError)
}


// MARK: - 方法
///普通的get和post请求
class HttpDriver {
    
    /// get请求，返回json数据
    ///
    /// - parameter URLString:  请求的url地址
    /// - parameter parameters: 请求的参数，可以不传入此参数
    /// - parameter header:     请求的headers，传入Dictionary
    /// - parameter completion: 请求完成的闭包
    ///
    /// - returns: MyHttpRequest对象
    class func get(URLString: String, parameters: [String: Any]? = nil, header: [String: String]? = nil,completion:@escaping (_ response: MyHttpResponse) -> Void) -> MyHttpRequest {
        
      let request = Alamofire.request(URLString, method: .get, parameters: parameters, headers: header)
        .validate()
        .responseJSON { response in
            completion(handleResponseData(response: response))
        }
        
        return MyHttpRequest(request: request)
    }
    
    
    
    /// post请求，返回json数据
    ///
    /// - parameter URLString:  请求的url地址
    /// - parameter parameters: 请求的参数，可以不传入此参数
    /// - parameter headers:    请求的headers，传入Dictionary
    /// - parameter completion: 请求完成的闭包
    ///
    /// - returns: MyHttpRequest对象
    class func post(URLString: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (_ response: MyHttpResponse) -> Void) -> MyHttpRequest {
        
        let request = Alamofire.request(URLString, method: .post, parameters: parameters,   headers: headers)
            .validate()
            .responseJSON { response in
            completion(handleResponseData(response: response))
        }
        
        return MyHttpRequest(request: request)
        
    }
    
    
    
    class func post(URL: String, data: Data?, headers: [String: String]? = nil, completion: @escaping (_ response: MyHttpResponse) -> Void) -> MyHttpRequest {
        
        let request = NSMutableURLRequest(url: NSURL(string: URL) as! URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.allHTTPHeaderFields = headers
        
        let alamofireRequest = Alamofire.request(request as! URLRequestConvertible)
        .validate()
        .responseJSON { response in
            completion(handleResponseData(response: response))
        }
        
        return MyHttpRequest(request: alamofireRequest)
    }
    
    
    
    
    
//MARK: - 处理网络请求的response数据
    class func handleResponseData(response: Alamofire.DataResponse<Any>) -> MyHttpResponse {
        
        var httpResponseState: HttpResponseState?
        
        switch response.result {
        case .success(let value):
            httpResponseState = HttpResponseState.Success(value)
        case .failure(let error as NSError):
            let err = MyError(errorType: .network)
            err.subcode = error.code
            err.errorMessage = error.description
            httpResponseState = HttpResponseState.Error(err)
        default: break
        }
        
        return MyHttpResponse(state: httpResponseState!)
    }
    
}



/// 上传文件的对象
class HttpUpLoadDriver {
    
    private var uploadRequest: Alamofire.Request?
    
    //Tip Any:任意变量，AnyObject任意类，在import Foundation的ing情况下，swift与OC的几个对应的类型会进行自动转换，因此Any相当于AnyObject
    
    func upload(URLString: String,
                parameters: [String: AnyObject]? = nil,
                formdatas: [MyUploadFormData]? = nil,
                headers: [String: String]? = nil,
                progressed: ((Int64, Int64) -> Void)? = nil,
                completion: @escaping (_ response: MyHttpResponse) -> Void
        )  {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
                //提交文件/二进制数据流
            if let formdatas = formdatas {
                for formdata in formdatas {
                 
                    if let data = formdata.data {
                        multipartFormData.append(data, withName: formdata.name, fileName: formdata.filename, mimeType: formdata.mimeType)
                    }
                    
                    if let url = formdata.fileURL {
                        multipartFormData.append(url, withName: formdata.name, fileName: formdata.filename, mimeType: formdata.mimeType)
                    }
                    
                }
            }
            
            //普通参数
            if let parameters = parameters {
                
                for (name, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: name)
                }
            }
            
            }, to: URLString, method: .post, headers: headers, encodingCompletion: { [weak self] encodingResult in
                
                if let sself = self {
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        //upload
                        sself.uploadRequest = upload
                        
                        //progress
                        upload.uploadProgress(closure: { (progress) in
                            progressed!(progress.completedUnitCount, progress.totalUnitCount)
                        })
                        
                        upload.responseJSON(completionHandler: { response in
                            
                            sself.uploadRequest = nil
                            var httpResponseState : HttpResponseState?
                            
                            switch response.result {
                            case .success(let value):
                                httpResponseState = HttpResponseState.Success(value)
                                
                            case .failure(let error as NSError):
                                let err = MyError(errorType: .network)
                                err.subcode = error.code
                                err.errorMessage = error.description
                                httpResponseState = HttpResponseState.Error(err)
                            default: break
                            }
                           
                            completion(MyHttpResponse(state: httpResponseState!))
                        })
                        
                    case .failure(_):
                        let error = MyError(errorType: .network)
                        error.errorMessage = "EncodingError,请检查编码格式"
                        
                        let httpResponseState = HttpResponseState.Error(error)
                        completion(MyHttpResponse(state: httpResponseState))
                    }
                }
        })
    }
    
    
    /// 取消上传任务
    func cancelUpload() {
        
        self.uploadRequest?.cancel()
        self.uploadRequest = nil
    }
    
    struct MyUploadFormData {
        var data : Data?
        var fileURL : URL?
        var name : String
        var filename : String = ""
        var mimeType : String
        
        init(data: Data?, name: String, filename: String, mimeType: String) {
            self.data = data
            self.name = name
            self.filename = filename
            self.mimeType = mimeType
        }
        
        
        init(fileURL: URL, name: String, filename: String, mimeType: String) {
            self.fileURL = fileURL
            self.name = name
            self.filename = filename
            self.mimeType = mimeType
        }
        
    }
}



// MARK: - 类
/// 返回的错误类型
class MyError {
    
    var errorType: MyErrorType
    var subcode: Int?
    var errorMessage: String?
    
    init(errorType : MyErrorType) {
        self.errorType = errorType;
    }
    
    enum MyErrorType {
        case network            //网络错误
        case api                //API返回错误
        case apiFormatter       //格式错误
        case other              //其他错误，比如解析错误，类型错误
    }
    
}



/// 所有请求的request对象
class MyHttpRequest {
    
    var request: Alamofire.Request
    
    init(request: Alamofire.Request) {
        self.request = request
    }
    
    func cancel() {
        self.request.cancel()
    }
}


class MyHttpResponse {
    
    var state: HttpResponseState
    
    init(state: HttpResponseState) {
        self.state = state
    }
}



