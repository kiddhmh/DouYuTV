//
//  FunViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class FunViewModel: NSObject {
    
    fileprivate var funRequest: MyHttpRequest?
    
    lazy var funModels: [HotModel] = [HotModel]()
    
    override init() {
        super.init()
    }
    
    deinit {
        funRequest?.cancel()
    }
    
}


extension FunViewModel {
    
    func requestFunData(complectioned complection:@escaping () -> (), failed fail:@escaping (_ error: MyError) -> ()) {
        
        funRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.ENMENT_BIG_DATA, parameters: ["identification" : "393b245e8046605f6f881d415949494c"]) { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<HotModel>>().map(JSON: value as! [String: Any])
                self.funModels = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            
            complection()
        }
    }
}
