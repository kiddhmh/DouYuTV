//
//  ProfileTotalLoginView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Spring

enum ThirdLogin {
    case wx
    case qq
    case sina
}
typealias ThirdClosure = (_ type: ThirdLogin) -> ()

class ProfileTotalLoginView: SpringView {
    
    // 第三方登录
    var thirdClosure: ThirdClosure?
    
    // 微信
    @IBOutlet weak var wxButton: UIButton!
    
    // QQ
    @IBOutlet weak var qqButton: UIButton!
    
    // 微博
    @IBOutlet weak var wbButton: UIButton!
    
    // 登录
    @IBOutlet weak var loginButton: UIButton!
    var loginClosure: moreBtnClosure?
    
    // 快速注册
    @IBOutlet weak var registerButton: UIButton!
    var resgisterClosure: moreBtnClosure?
    
    fileprivate var isAddCorner: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    
    private func setupUI() {
        self.backgroundColor = .clear
    
        loginButton.addTarget(self, action: #selector(highlightClick), for: .touchDown)
        loginButton.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(touchCancel), for: .touchCancel)
        registerButton.setTitleColor(C.mainColor, for: .normal)
    }
    
    /// 设置圆角
    private func addCornerRadius() {
        
        loginButton.addCorner(radius: 5, borderWidth: 1, backgroundColor: C.mainColor, borderColor: C.mainColor)
        wxButton.addCorner(radius: 5, borderWidth: 1, backgroundColor: .white, borderColor: .green)
        qqButton.addCorner(radius: 5, borderWidth: 1, backgroundColor: .white, borderColor: .blue)
        wbButton.addCorner(radius: 5, borderWidth: 1, backgroundColor: .white, borderColor: .red)
        
        self.addCorner(radius: 5, borderWidth: 1, backgroundColor: .white, borderColor: .black)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isAddCorner {
            self.addCornerRadius()
            isAddCorner = true
        }
    }
    
    
    // 微信
    @IBAction func wxLogin(_ sender: UIButton) {
        guard let thirdClosure = thirdClosure else { return }
        thirdClosure(.wx)
    }
    
    
    // QQ
    @IBAction func qqLogin(_ sender: UIButton) {
        guard let thirdClosure = thirdClosure else { return }
        thirdClosure(.qq)
    }
    
    
    // 微博
    @IBAction func sinaLogin(_ sender: UIButton) {
        guard let thirdClosure = thirdClosure else { return }
        thirdClosure(.sina)
    }
    
    
    // 快速注册
    @IBAction func quickLogin(_ sender: UIButton) {
        guard let resgisterClosure = resgisterClosure else { return }
        resgisterClosure()
    }
    
}


// MARK: - 按钮点击事件
extension ProfileTotalLoginView {
    
    /// 高亮事件
    @objc fileprivate func highlightClick() {
        changeColor(true)
    }
    
    
    /// 点击按钮(登录)
    @objc fileprivate func loginBtnClick() {
        changeColor(false)
        
        guard let loginClosure = loginClosure else { return }
        loginClosure()
    }
    
    
    @objc fileprivate func touchCancel() {
        changeColor(false)
    }
    
    /// 改变背景色
    private func changeColor(_ isHighLight: Bool) {
        loginButton.subviews.first?.removeFromSuperview()
        let color = isHighLight ? C.loginColor : C.mainColor
        loginButton.addCorner(radius: 6, borderWidth: 1, backgroundColor: color, borderColor: color)
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
