//
//  LiveAnchorViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/14.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class LiveAnchorViewModel: NSObject {
    
    fileprivate var faceRequest: MyHttpRequest?
    fileprivate var anchorRequest: MyHttpRequest?
    fileprivate var titleRequest: MyHttpRequest?
    
    lazy var anchorGroup: [AnchorModel] = []
    lazy var faceGroup: [RecomFaceModel] = []
    lazy var titleGroup: [LiveAnchorTitleModel] = []
    
    override init() {
        super.init()
    }
    
    deinit {
        anchorRequest?.cancel()
        faceRequest?.cancel()
        titleRequest?.cancel()
    }
}


extension LiveAnchorViewModel {
    
    /// 颜值页面，下方全部数据
    func requestFaceData(shortName: String? = nil, cate_id: String, limit: String, offset: String, complectioned complection:@escaping () -> (), failed fail:@escaping (_ error:MyError) -> ()) {
        
        let paramData = ["limit":limit,"offset":offset,"time": Date.nowDate().toTimestamp()]
        
        let group = DispatchGroup()
        
        if let shortName = shortName {  // 上拉加载数据时不刷新导航栏
            let paramTitle = ["shortName":shortName]
            group.enter()
            /// 请求分类导航条数据
            titleRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.LIVE_NAV_TITLE_DATA, parameters: paramTitle, complection: { (myResponse) in
                
                switch  myResponse.state {
                case .Success(let value):
                    let models = Mapper<BaseModel<LiveAnchorTitleModel>>().map(JSON: value as! [String: Any])
                    self.titleGroup = (models?.data)!
                case .Error(let error):
                    fail(error)
                    return
                }
                group.leave()
            })
        }
        
        group.enter()
        /// 请求全部数据
        faceRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.LIVE_ALLCOLUMNLIST_DATA + cate_id, parameters: paramData, complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<RecomFaceModel>>().map(JSON: value as! [String: Any])
                self.faceGroup = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            complection()
        }
    }
    
    
    /// 其他类别数据
    func requestAnchorData(shortName: String? = nil, cate_id: String, limit: String, offset: String, complectioned complection:@escaping () -> (), failed fail:@escaping (_ error:MyError) -> ()) {
        
        let paramData = ["limit":limit,"offset":offset,"time": Date.nowDate().toTimestamp()]
        
        let group = DispatchGroup()
        
        if let shortName = shortName {  // 上拉加载数据时不刷新导航栏
            let paramTitle = ["shortName":shortName]
            group.enter()
            /// 请求分类导航条数据
            titleRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.LIVE_NAV_TITLE_DATA, parameters: paramTitle, complection: { (myResponse) in
                
                switch  myResponse.state {
                case .Success(let value):
                    let models = Mapper<BaseModel<LiveAnchorTitleModel>>().map(JSON: value as! [String: Any])
                    self.titleGroup = (models?.data)!
                case .Error(let error):
                    fail(error)
                    return
                }
                group.leave()
            })
        }
        
        group.enter()
        anchorRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.LIVE_ALLCOLUMNLIST_DATA + cate_id, parameters: paramData, complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<AnchorModel>>().map(JSON: value as! [String: Any])
                self.anchorGroup = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) { 
            complection()
        }
    }

}
