//
//  EnmentViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class EnmentViewModel: NSObject {
    
    fileprivate var enModelReequest: MyHttpRequest?
    
    lazy var enModels: [HotModel] = [HotModel]()
    
    override init() {
        super.init()
    }
    
    deinit {
        enModelReequest?.cancel()
    }
    
}


extension EnmentViewModel {
    
    func requestEnData(complectioned complection: @escaping () -> (),failed fail: @escaping (_ error: MyError) -> ()) {
        
        enModelReequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.ENMENT_BIG_DATA, parameters: ["identification" : "9acf9c6f117a4c2d02de30294ec29da9"]) { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<HotModel>>().map(JSON: value as! [String: Any])
                self.enModels = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            
            complection()
        }
    }
}
