//
//  MHPushConfigView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/10.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import Spring

private let buttonColor: UIColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
public enum MHNotificationTrigger {
    case timeInterval   // 时间
    case calendar       // 日历
    case location       // 地点
}

typealias RegisterClosure = (_ type: MHNotificationTrigger) -> Void

class MHPushConfigView: SpringView {
    
    // 时间
    @IBOutlet weak var timeIntervalButton: UIButton!
    
    // 日历
    @IBOutlet weak var calendarButton: UIButton!
    
    // 地点
    @IBOutlet weak var locationButton: UIButton!
    
    var registerClosure: RegisterClosure?
    
    var isUserInteraction: Bool = false {
        
        didSet {
            guard isUserInteraction else { return }
            isUserInteractionEnabled = isUserInteraction
            timeIntervalButton.isUserInteractionEnabled = isUserInteraction
            calendarButton.isUserInteractionEnabled = isUserInteraction
            locationButton.isUserInteractionEnabled = isUserInteraction
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        
        timeIntervalButton.addCorner(radius: 6, borderWidth: 1, backgroundColor: buttonColor, borderColor: buttonColor)
        calendarButton.addCorner(radius: 6, borderWidth: 1, backgroundColor: buttonColor, borderColor: buttonColor)
        locationButton.addCorner(radius: 6, borderWidth: 1, backgroundColor: buttonColor, borderColor: buttonColor)
    }
    
    
    @IBAction func registerTimePush(_ sender: UIButton) {
        
        guard  let registerClosure = registerClosure else { return }
        registerClosure(.timeInterval)
        moveToleft()
    }
    
    
    @IBAction func registerCalendarPush(_ sender: UIButton) {
        
        guard  let registerClosure = registerClosure else { return }
        registerClosure(.calendar)
        moveToleft()
    }
    
    
    @IBAction func registerLocationPush(_ sender: UIButton) {
        
        guard  let registerClosure = registerClosure else { return }
        registerClosure(.location)
        moveToleft()
    }
    
    
    @IBAction func dismissFromSuperView(_ sender: UITapGestureRecognizer) {
        
        animation = "fall"
        animateNext { 
            self.removeFromSuperview()
            MHBlurEffctView.mhBlurEffectView.removeFromSuperview()
        }
    }
    
    
    private func moveToleft() {
        
        self.snp.updateConstraints { (make) in
            make.center.equalTo(CGPoint(x: -HmhDevice.screenW * 0.4, y: (HmhDevice.screenH - HmhDevice.navigationBarH) / 2))
        }
        
        animation = "slideLeft"
        animateNext {
            self.removeFromSuperview()
        }
    }
    
}


extension MHPushConfigView {
    
    class func pushConfigView() -> MHPushConfigView {
        return HmhTools.createView("MHPushConfigView") as! MHPushConfigView
    }
    
}


