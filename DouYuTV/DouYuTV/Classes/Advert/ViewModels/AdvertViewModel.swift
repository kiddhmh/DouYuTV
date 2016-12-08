//
//  AdvertViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class AdvertViewModel: NSObject {
    
    fileprivate var advertRequest: MyHttpRequest?
    
    lazy var advertModels: [AdvertModel]? = [AdvertModel]()
    
    override init() {
        super.init()
    }
    
    deinit {
        advertRequest?.cancel()
    }
}


extension AdvertViewModel {

    func requestAvertData(complectioned complection:@escaping () -> (), failed fail: (_ error: MyError) -> ()) {
        let params = ["aid":"ios","time":"1480942380", "token":"1457555_11_f407d33ac96d2af1_2_18650423", "auth":"68e31a10a1ff0cb6ce06aec0d831ed28"]
        
        advertRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.ADVERT_DATA, parameters: params, complection: { (myResponse) in
            
//            switch  myResponse.state {
//            case .Success(let value):
//                
//            case .Error(let error):
//                fail(error)
//            }
            
            complection()
            
        })
    }
    
}
