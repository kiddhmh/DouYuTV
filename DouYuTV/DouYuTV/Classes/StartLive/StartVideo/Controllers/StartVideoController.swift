//
//  StartVideoController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/4.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit

class StartVideoController: UIViewController {
    
    // 返回
    @IBOutlet weak var backBtn: UIButton!
    
    // 美颜
    @IBOutlet weak var beautityBtn: UIButton!
    
    // 切换摄像头
    @IBOutlet weak var toggleBtn: UIButton!
    
    // 闪光灯
    @IBOutlet weak var flashBtn: UIButton!
    
    // 切换屏幕方向
    @IBOutlet weak var changeScreenBtn: UIButton!
    
    // 遮罩
    @IBOutlet weak var startEffectView: UIVisualEffectView!
    
    // 开始录制
    @IBOutlet weak var startVideoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startEffectView.layer.cornerRadius = startEffectView.width / 2
        startEffectView.layer.masksToBounds = true
    }
    
    
    // 返回上一级页面
    @IBAction func backHome(_ sender: UIButton) {
    }
    
    
    // 开关美颜
    @IBAction func changeBeautity(_ sender: UIButton) {
    }
    
    
    // 切换摄像头
    @IBAction func toggleCapture(_ sender: UIButton) {
    }
    
    
    // 开关闪光灯
    @IBAction func changeFlash(_ sender: UIButton) {
    }
    
    
    // 切换屏幕方向
    @IBAction func changeScreen(_ sender: UIButton) {
    }
    
    
    // 开始录制
    @IBAction func startToVideo(_ sender: UIButton) {
    }
    
}


extension StartVideoController {
    
    
    
    
}
