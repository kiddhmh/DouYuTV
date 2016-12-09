//
//  MGameViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/5.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class MGameViewModel: NSObject {
    
    fileprivate var mHeaderRequest: MyHttpRequest?
    
    lazy var mModels: [HotModel] = [HotModel]()
    
    override init() {
        super.init()
    }
    
    deinit {
        mHeaderRequest?.cancel()
    }
    
}


extension MGameViewModel {
    
    func requestHederData(complectioned complection: @escaping () -> (),failed fail: @escaping (_ error: MyError) -> ()) {
        
        mHeaderRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.MGAME_BIG_DATA, parameters: ["identification" : "ba08216f13dd1742157412386eee1225"], complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<HotModel>>().map(JSON: value as! [String: Any])
                self.mModels = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            
            complection()
            
        })
        
    }
    
}
