//
//  MHHistoryViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class MHSearchHotViewModel: NSObject {
    
    fileprivate var searchHotRequest: MyHttpRequest?
    
    var searchHotModel: SearchHotModel?
    
    override init() {
        super.init()
    }
    
    deinit {
        searchHotRequest?.cancel()
    }
    
    
}


extension MHSearchHotViewModel {
    
    func requestHistoryData(complectioned complection:@escaping () -> (), failed fail:@escaping (_ error: MyError) -> ()) {
        
        searchHotRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.SEARCH_HISTORY, parameters: ["limit":"10"]) { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<SearchHotModel>().map(JSON: value as! [String : Any])
                self.searchHotModel = models
            case .Error(let error):
                fail(error)
                return
            }
            
            complection()
        }
    }
}
