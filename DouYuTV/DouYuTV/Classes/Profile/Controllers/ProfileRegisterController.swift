//
//  ProfileRegisterController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/28.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

private let kMargin: CGFloat = 20
private let normalH: CGFloat = 44

class ProfileRegisterController: UIViewController {
    
    // 昵称
    fileprivate lazy var nameTextField: MHTextField = {
        let textField = MHTextField.init(placeholder: "昵称/用户名 (5-30位汉字、字母或数字)", leftImage: #imageLiteral(resourceName: "tf_login_username"), leftViewSize: CGSize(width: normalH, height: normalH), frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW - 2 * kMargin, height: normalH))
        textField.delegate = self
        return textField
    }()
    
    // 密码
    fileprivate lazy var passTextField: MHTextField = {
        let textField = MHTextField.init(placeholder: "输入密码", leftImage: #imageLiteral(resourceName: "tf_login_password"), leftViewSize: CGSize(width: normalH, height: normalH), frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW - 2 * kMargin, height: normalH))
        textField.delegate = self
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    // 确认密码
    fileprivate lazy var confirmTextField: MHTextField = {
        let textField = MHTextField.init(placeholder: "确认密码", leftImage: #imageLiteral(resourceName: "tf_login_password"), leftViewSize: CGSize(width: normalH, height: normalH), frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW - 2 * kMargin, height: normalH))
        textField.delegate = self
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // 提示label
    fileprivate lazy var warnLabel: UILabel = {
        let label = UILabel()
        label.text = "*昵称/用户名注册后不能随意更改"
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .groupTableViewBackground
        label.textColor = C.mainTextColor
        return label
    }()
    
    // 注册按钮
    fileprivate lazy var registerButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW - 2 * kMargin, height: normalH))
        btn.addTarget(self, action: #selector(highlightClick), for: .touchDown)
        btn.addTarget(self, action: #selector(touchOut), for: .touchCancel)
        btn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        btn.setTitle("注册", for: .normal)
        btn.backgroundColor = .groupTableViewBackground
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    
    // 马上登录
    fileprivate lazy var quickLogin: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(gotoLogin), for: .touchUpInside)
        btn.setTitle("马上登录", for: .normal)
        btn.backgroundColor = .groupTableViewBackground
        btn.setTitleColor(C.mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = "注册"
        view.backgroundColor = .groupTableViewBackground
        
        setupUI()
    }
    
    
    private func setupUI() {
        
        view.addSubview(nameTextField)
        view.addSubview(passTextField)
        view.addSubview(confirmTextField)
        view.addSubview(warnLabel)
        view.addSubview(registerButton)
        view.addSubview(quickLogin)
        
        nameTextField.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(kMargin)
            make.right.equalTo(view).offset(-kMargin)
            make.height.equalTo(normalH)
        }
        
        passTextField.snp.makeConstraints { (make) in
            make.left.equalTo(nameTextField)
            make.right.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(kMargin)
            make.height.equalTo(normalH)
        }
        
        confirmTextField.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(nameTextField)
            make.top.equalTo(passTextField.snp.bottom).offset(kMargin)
        }
        
        warnLabel.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(nameTextField)
            make.top.equalTo(confirmTextField.snp.bottom)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(nameTextField)
            make.top.equalTo(warnLabel.snp.bottom)
        }
        
        quickLogin.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.height.equalTo(nameTextField)
            make.width.equalTo(normalH * 2)
            make.top.equalTo(registerButton.snp.bottom)
        }
        
        nameTextField.addCorner(radius: 3, borderWidth: 1, backgroundColor: .white, borderColor: .white)
        passTextField.addCorner(radius: 3, borderWidth: 1, backgroundColor: .white, borderColor: .white)
        confirmTextField.addCorner(radius: 3, borderWidth: 1, backgroundColor: .white, borderColor: .white)
        registerButton.addCorner(radius: 3, borderWidth: 1, backgroundColor: C.mainColor, borderColor: C.mainColor)
    }
    
    // 马上去登录
    @objc private func gotoLogin() {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        confirmTextField.resignFirstResponder()
    }
    
}


// MARK: - ButtonAction
extension ProfileRegisterController {
    
    /// 高亮事件
    @objc fileprivate func highlightClick() {
        changeColor(true)
    }
    
    
    /// 点击按钮(注册)
    @objc fileprivate func loginBtnClick() {
        changeColor(false)
        
        // 判断是否满足注册条件
        if !isAllow() { return }
        
        // 向数据库注册一名新用户
        let user = RLMUser()
        user.name = nameTextField.text!
        user.Password = passTextField.text!
        
        let result = RealmTool.addObject(user)
        result ? MBProgressHUD.showSuccess("注册成功") : MBProgressHUD.showError("该昵称已存在")
        
        nameTextField.text = ""
        passTextField.text = ""
        confirmTextField.text = ""
        
        // 跳转到登录页面
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    private func isAllow() -> Bool {
        
        let nameResult = nameTextField.isAllowUserName { (message, isAllow) in
            guard isAllow else {
                MBProgressHUD.showError(message)
                return
            }
        }
        
        guard nameResult else { return  false}
        
        let passResult = passTextField.isAllowPassword { (message, isAllow) in
            guard isAllow else {
                MBProgressHUD.showError("密码" + message)
                return
            }
        }
        
        guard passResult else { return  false}
        
        let confirmResult = confirmTextField.isAllowPassword { (message, isAllow) in
            guard isAllow else {
                MBProgressHUD.showError("密码" + message)
                return
            }
        }
        
        guard confirmResult else { return  false}
        
        // 判断两次密码是否一致
        guard passTextField.text! == confirmTextField.text! else {
            MBProgressHUD.showError("两次密码输入的不一致")
            return false
        }
        
        return true
    }
    
    
    @objc fileprivate func touchOut() {
        changeColor(false)
    }
    
    /// 改变背景色
    private func changeColor(_ isHighLight: Bool) {
        registerButton.subviews.first?.removeFromSuperview()
        let color = isHighLight ? C.loginColor : C.mainColor
        registerButton.addCorner(radius: 3, borderWidth: 1, backgroundColor: color, borderColor: color)
        
        nameTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        confirmTextField.resignFirstResponder()
    }
    
}


// MARK: - UITextFieldDelegate
extension ProfileRegisterController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


