//
//  StartVideoController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/4.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import LFLiveKit

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
    
    // 显示直播状态
    @IBOutlet weak var liveStateLabel: UILabel!
    
    // 推流
    fileprivate lazy var liveSession: LFLiveSession = {
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        let audioConfiguration: LFLiveAudioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration: LFLiveVideoConfiguration = LFLiveVideoConfiguration.default()
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.delegate = self
        session?.preView = self.view
        return session!
    }()
    
    // 推流地址
    var rtmpUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startEffectView.layer.cornerRadius = startEffectView.width / 2
        startEffectView.layer.masksToBounds = true
        
        // 检测是否授权
        requestAccessForAudio()
        requestAccessForVideo()
        
        // 默认开启后置摄像头
        liveSession.captureDevicePosition = .back
    }
    
    
    //MARK: AccessAuth
    
    func requestAccessForVideo() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo);
        switch status  {
        // 许可对话没有出现，发起授权许可
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async { [unowned self] in
                        self.liveSession.running = true
                    }
                }
            })
            
        // 已经开启授权，可继续
        case .authorized:
            liveSession.running = true
        // 用户明确地拒绝授权，或者相机设备无法访问
        case .denied:
            break
        case .restricted:
            break
        }
    }
    
        
    func requestAccessForAudio() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeAudio)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted) in
                
            })
            
        // 已经开启授权，可继续
        case .authorized:
            break
        // 用户明确地拒绝授权，或者相机设备无法访问
        case .denied:
            break
        case .restricted:
            break
        }
    }
    
    
    // 返回上一级页面
    @IBAction func backHome(_ sender: UIButton) {
        
        if liveSession.state == .pending || liveSession.state == .start {
            liveSession.stopLive()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // 开关美颜
    @IBAction func changeBeautity(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        // 默认是开启美颜的
        liveSession.beautyFace = !liveSession.beautyFace
    }
    
    
    // 切换摄像头
    @IBAction func toggleCapture(_ sender: UIButton) {
        
        let isBack = liveSession.captureDevicePosition == .back
        sender.isSelected = !sender.isSelected
        flashBtn.isHidden = isBack
        
        let position: AVCaptureDevicePosition = isBack ? .front : .back
        liveSession.captureDevicePosition = position
    }
    
    
    // 开关闪光灯
    @IBAction func changeFlash(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        liveSession.torch = sender.isSelected
    }
    
    
    // 切换屏幕方向
    @IBAction func changeScreen(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        UIDevice.setOrientation(sender.isSelected)
    }
    
    
    // 开始录制
    @IBAction func startToVideo(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        guard sender.isSelected else {  //结束直播
            liveSession.stopLive()
            liveStateLabel.text = "状态: 直播关闭RTMP: \(rtmpUrl)"
            return
        }
        
        // 开始直播
        let stream = LFLiveStreamInfo()
        // 电脑的IP地址
        stream.url = "rtmp://192.168.0.103/rtmplive/room"
        rtmpUrl = stream.url
        liveSession.startLive(stream)
    }
    
}


extension StartVideoController: LFLiveSessionDelegate {
    
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
    }
    
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case .ready:
            liveStateLabel.text = "未连接\(rtmpUrl!)"
        case .pending:
            liveStateLabel.text = "连接中\(rtmpUrl!)"
        case .start:
            liveStateLabel.text = "已连接\(rtmpUrl!)"
        case .error:
            liveStateLabel.text = "连接错误\(rtmpUrl!)"
        case .stop:
            liveStateLabel.text = "未连接\(rtmpUrl!)"
            liveSession.stopLive()
        default:
            break
        }
    }
}
