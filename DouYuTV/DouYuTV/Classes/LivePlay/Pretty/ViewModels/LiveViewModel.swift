//
//  YKViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/3.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

private let liveURL = "http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"

class LiveViewModel: NSObject {
    
    fileprivate var liveRequest: MyHttpRequest?
    
    lazy var liveModels: [YKLiveModel] = []
    
    override init() {
        super.init()
    }
    
    deinit {
        liveRequest?.cancel()
    }
}


extension LiveViewModel {
    
    func requestLiveData(complectioned completion: @escaping () -> (),failed fail: @escaping (_ error: MyError) -> ()) {
        
        liveRequest = HttpDriver.get(URLString: liveURL, completion: { [weak self] response in
            
            switch response.state {
            case .Success(let value):
                let totalModels = Mapper<YKTotalModel>().map(JSON: value as! [String : Any])
                guard let lives = totalModels?.lives else {
                    let errror = MyError(errorType: .network)
                    errror.errorMessage = "网络错误"
                    fail(errror)
                    return
                }
                self?.liveModels = lives
            case .Error(let error):
                fail(error)
                return
            }
            
            completion()
        })
    }
    
}
