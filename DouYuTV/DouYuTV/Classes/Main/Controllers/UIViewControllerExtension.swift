//
//  UIViewControllerExtension.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/4.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit

extension UIViewController: StartLiveViewDelegate {
    
    
    func startLiveDidClick(_ liveView: StartLiveView, _ type: LiveType) {
        
        switch type {
        case .live:
            print("点击直播")
        case .video:
            print("点击录制")
        // 进入录制页面
            let videoVC = HmhTools.createViewController("StartVideoController", identifier: "StartVideoController") as! StartVideoController
            self.present(videoVC, animated: true, completion: nil)
        }
    }
}
