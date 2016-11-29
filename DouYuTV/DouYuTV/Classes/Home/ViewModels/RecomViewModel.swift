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
    
    fileprivate var faceRequest: MyHttpRequest?
    
    lazy var gameGroup: [AnchorModel] = [AnchorModel]()
    lazy var faceGroup: [RecomFaceModel] = [RecomFaceModel]()
    
    override init() {
        super.init()
        
        requestData { (myResponse) in
            switch myResponse.state {
            case .Success(let faceModels):
                self.faceGroup = (faceModels as! FaceBaseModel).data!
            case .Error(let error):
                if let errorMessage = error.errorMessage {
                    MBProgressHUD.showError(errorMessage)
                }
            }
        }
    }
    
    deinit {
        faceRequest?.cancel()
    }
}


extension RecomViewModel {
    
    func requestData(_ completion: @escaping (_ response: MyHttpResponse) -> ()) {
        
        let params = ["limit": "4", "offset": "0", "time": Date.nowDate().toTimestamp() ]
        
        faceRequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.RECOMMEND_FACE, parameters: params as [String : AnyObject]? , complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let faceModels = Mapper<FaceBaseModel>().map(JSON: value as! [String : Any])
                let response = MyHttpResponse(state: HttpResponseState.Success(faceModels))
                completion(response)
            case .Error(_):
                completion(myResponse)
            }
        })
        
    }
    
}




