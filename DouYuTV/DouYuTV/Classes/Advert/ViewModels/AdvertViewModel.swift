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
    
    var advertModels: AdvertModel?
    
    override init() {
        super.init()
    }
    
    deinit {
        advertRequest?.cancel()
    }
}


extension AdvertViewModel {

    func requestAvertData(complectioned complection:@escaping () -> (), failed fail: @escaping (_ error: MyError) -> ()) {
        
        advertRequest = HttpDriver.get(URLString: MyNetWorkingConfig.ADVERT_DATA) { (response) in
            
            switch response.state {
            case .Success(let value):
                self.advertModels = Mapper<AdvertModel>().map(JSON: value as! [String : Any])
            case .Error(let error):
                fail(error)
                return
            }
            complection()
        }
        
        
        
    }
    
}
