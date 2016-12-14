//
//  LiveTitleViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class LiveTitleViewModel: NSObject {
    
    fileprivate var titleRequest: MyHttpRequest?
    
    fileprivate var allRequest: MyHttpRequest?
    
    lazy var titleModels: [LiveTitleModel] = []
    
    lazy var allModels: [AnchorModel] = []
    
    override init() {
        super.init()
    }
    
    deinit {
        titleRequest?.cancel()
        allRequest?.cancel()
    }
}

extension LiveTitleViewModel {
    
    /// 顶部标题数据
    func requestTitleData(complectioned complection:@escaping () -> (), failed fail:@escaping (_ error:MyError) -> ()) {
        
        titleRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.LIVE_TITLE_DATA, complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<LiveTitleModel>>().map(JSON: value as! [String: Any])
                self.titleModels = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            
            complection()
        })
    }
    
    /// 全部房间数据
    func requestAllData(limit: String, offset: String, complectioned complection:@escaping () -> (), failed fail:@escaping (_ error:MyError) -> ()) {
        
        let param = ["limit":limit,"offset":offset]
        
        allRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.LIVE_ALLGAME_DATA, parameters: param, complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<AnchorModel>>().map(JSON: value as! [String: Any])
                self.allModels = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            
            complection()
            
        })
    }
}
