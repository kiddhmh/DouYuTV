//
//  ProfileTotalLoginView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Spring

class ProfileTotalLoginView: SpringView {
    
    // 微信
    @IBOutlet weak var wxButton: UIButton!

    // QQ
    @IBOutlet weak var qqButton: UIButton!
    
    // 微博
    @IBOutlet weak var wbButton: UIButton!
    
    // 登录
    @IBOutlet weak var loginButton: UIButton!
    
    // 快速注册
    @IBOutlet weak var registerButton: UIButton!
    
    fileprivate var isAddCorner: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    
    private func setupUI() {
        self.backgroundColor = .clear
    
        loginButton.addTarget(self, action: #selector(highlightClick), for: .touchDown)
        loginButton.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        registerButton.setTitleColor(C.mainColor, for: .normal)
    }
    
    /// 设置圆角
    private func addCornerRadius() {
        
        loginButton.addCorner(radius: 7, borderWidth: 1, backgroundColor: C.mainColor, borderColor: C.mainColor)
        wxButton.addCorner(radius: 7, borderWidth: 1, backgroundColor: .white, borderColor: .green)
        qqButton.addCorner(radius: 7, borderWidth: 1, backgroundColor: .white, borderColor: .blue)
        wbButton.addCorner(radius: 7, borderWidth: 1, backgroundColor: .white, borderColor: .red)
        
        self.addCorner(radius: 7, borderWidth: 1, backgroundColor: .white, borderColor: .black)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isAddCorner {
            self.addCornerRadius()
            isAddCorner = true
        }
    }
    
    
}


// MARK: - 按钮点击事件
extension ProfileTotalLoginView {
    
    /// 高亮事件
    @objc fileprivate func highlightClick() {
        changeColor(true)
    }
    
    
    /// 点击按钮
    @objc fileprivate func loginBtnClick() {
        changeColor(false)
    }
    
    
    /// 改变背景色
    private func changeColor(_ isHighLight: Bool) {
        loginButton.subviews.first?.removeFromSuperview()
        let color = isHighLight ? C.loginColor : C.mainColor
        loginButton.addCorner(radius: 8, borderWidth: 1, backgroundColor: color, borderColor: color)
    }
    
}


// MARK: - 初始化
extension ProfileTotalLoginView {
    
    class func totalLoginView() -> ProfileTotalLoginView {
        return HmhTools.createView("ProfileTotalLoginView") as! ProfileTotalLoginView
    }
    
}


// MARK: - 事件响应链
extension ProfileTotalLoginView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        return super.hitTest(point, with: event)
    }
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let w: CGFloat = 24
        let h = w
        let rect = CGRect(x: self.centerX - 12, y: self.bottom + 30, width: w, height: h)
        // 转换成相对于当前视图的位置
        let newRect = self.superview?.convert(rect, to: self)
        
        guard newRect!.contains(point) == false else { return true }
        return super.point(inside: point, with: event)
    }
    
}
