//
//  GameViewModel.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/6.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import ObjectMapper

class GameViewModel: NSObject {
    
    fileprivate var gameModelReequest: MyHttpRequest?
    
    lazy var gameModels: [HotModel] = [HotModel]()
    
    override init() {
        super.init()
    }
    
    deinit {
        gameModelReequest?.cancel()
    }
    
}


extension GameViewModel {
    
    func requestGameData(complectioned complection: @escaping () -> (),failed fail: @escaping (_ error: MyError) -> ()) {
        
        gameModelReequest = HttpClient.sharedHttpClient().get(MyNetWorkingConfig.GAME_BIG_DATA, parameters: ["identification" : "3e760da75be261a588c74c4830632360"], complection: { (myResponse) in
            
            switch  myResponse.state {
            case .Success(let value):
                let models = Mapper<BaseModel<HotModel>>().map(JSON: value as! [String: Any])
                self.gameModels = (models?.data)!
            case .Error(let error):
                fail(error)
                return
            }
            
            complection()
            
        })
        
    }
    
}
