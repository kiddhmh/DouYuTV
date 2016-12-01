//
//  RecomViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/29.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD

class RecomViewModel: NSObject {
    
    fileprivate var bigRequest: MyHttpRequest?
    fileprivate var hotRequest: MyHttpRequest?
    fileprivate var faceRequest: MyHttpRequest?
    fileprivate var cycleRequest: MyHttpRequest?
    
    lazy var bigGroup: [AnchorModel] = [AnchorModel]()
    lazy var faceGroup: [RecomFaceModel] = [RecomFaceModel]()
    lazy var hotGroup: [HotModel] = [HotModel]()
    lazy var cycleGroup: [CycleModel] = [CycleModel]()
    
    override init() {
        super.init()
        
    }
    
    deinit {
        bigRequest?.cancel()
        hotRequest?.cancel()
        faceRequest?.cancel()
        cycleRequest?.cancel()
    }
}


extension RecomViewModel {
    
    func requestData(complectioned completion: @escaping () -> (),failed fail: @escaping (_ error: MyError) -> ()) {
        
        // 颜值数据参数
        let params = ["limit": "4", "offset": "0", "time": Date.nowDate().toTimestamp() ]
        
        // 利用DispatchGroup管理多条网络请求
        let group = DispatchGroup()
        
        group.enter()
        // 请求第一部分推荐数据
        hotRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.RECOMMEND_BIG_GAME, parameters: ["time": Date.nowDate().toTimestamp()], complection: { (myResponse) in
            
            switch myResponse.state {
            case .Success(let value):
                let baseModel = Mapper<BaseModel<AnchorModel>>().map(JSON: value as! [String : Any])
                self.bigGroup = (baseModel?.data)!
            case .Error(let error):
                fail(error)
            }
            
            group.leave()
        })
        
        group.enter()
        // 请求第二部分颜值数据
        faceRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.RECOMMEND_FACE, parameters: params, complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let faceModels = Mapper<BaseModel<RecomFaceModel>>().map(JSON: value as! [String : Any])
                self.faceGroup = (faceModels?.data)!
            case .Error(let error):
                fail(error)
            }
            
            group.leave()
        })
        
        group.enter()
        // 请求第三部分最热数据
        hotRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.RECOMMEND_HOT_GAME, parameters: params, complection: { (myResponse) in
            
            switch myResponse.state {
            case .Success(let value):
                let baseModel = Mapper<BaseModel<HotModel>>().map(JSON: value as! [String: Any])
                self.hotGroup = (baseModel?.data)!
            case .Error(let error):
                fail(error)
            }
            
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) { 
            completion()
        }
    }
    
    
    /// 请求轮播图数据
    func requestCycleData(complectioned complection: @escaping () -> (),failed fail: @escaping (_ error: MyError) -> ()) {
        
        cycleRequest = HttpClient.sharedHttpClient().get("http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.401"], complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let cycleModel = Mapper<BaseModel<CycleModel>>().map(JSON: value as! [String: Any])
                self.cycleGroup = (cycleModel?.data)!
            case .Error(let error):
                fail(error)
            }
            
          complection()
        })
    }
    
}




