//
//  HmhThirdLibExtension.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/29.
//  Copyright © 2016年 CMCC. All rights reserved.
//

// MARK: - 第三方SDK的相关Extension扩展

import MBProgressHUD

extension MBProgressHUD {
    
    /**
     显示成功的提示.
     
     - parameter message:   成功的文案.
     - parameter toView:    显示在哪个视图上.
     - parameter duration:  显示多久的时间之后消失.
     */
    static func showSuccess(_ message:String, toView:UIView? = UIApplication.shared.windows.last, duration:Double = 1.0) {
        show(message, iconName: "form_success", view: toView, duration: duration)
    }
    
    /**
     显示发送失败之后的提示.
     
     - parameter message:   失败的提示文案.
     - parameter toView:    显示哪个视图上.
     - parameter duration:  显示的时长.
     */
    static func showError(_ message:String, toView:UIView? = UIApplication.shared.windows.last, duration:Double = 1.0) {
        show(message, iconName: "loading_error", view: toView, duration: duration)
    }
    
    
    /**
     显示提示文案(不带图片).
     
     - parameter message: 显示文案信息.
     - parameter toView:  显示在哪个视图上.
     */
    static func showTips(_ message:String, toView:UIView? = UIApplication.shared.windows.last, duration:Double = 1.0) {
        guard let toView = toView else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        hud.label.text = message
        hud.mode = .text
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: duration)
    }
    
    /**
     显示Loading的信息.
     
     - parameter message: loading信息的提示文案.
     - parameter toView:  显示在哪个视图上.
     */
    static func showLoading(_ message:String = L.loading, toView:UIView? = UIApplication.shared.windows.last) {
        guard let toView = toView else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: toView, animated: true)
        hud.label.text = message
        hud.removeFromSuperViewOnHide = true
        hud.backgroundColor = UIColor.white
    }
    
    /**
     隐藏hud.
     
     - parameter view: 隐藏对应视图上的hud框.
     */
    static func hideHud(_ view:UIView? = UIApplication.shared.windows.last) {
        self.hide(for: view!, animated: true)
    }
}



extension MBProgressHUD {
    fileprivate static func show(_ message:String, iconName:String? = nil, view:UIView?, duration:Double) {
        guard let view = view else { return }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = message
        
        if let iconName = iconName {
            hud.customView = UIImageView(image: UIImage(named: iconName))
            hud.mode = .customView
        }
        
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: Double(duration))
    }
}

