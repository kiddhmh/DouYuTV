//
//  ProfileLoginController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let kMargin: CGFloat = 20
private let normalH: CGFloat = 44

class ProfileLoginController: UIViewController {
    
    // 昵称
    fileprivate lazy var nameTextField: MHTextField = {
        let textField = MHTextField.init(placeholder: "昵称/用户名 (5-30位汉字、字母或数字)", leftImage: #imageLiteral(resourceName: "tf_login_username"), leftViewSize: CGSize(width: normalH, height: normalH), frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW - 2 * kMargin, height: normalH))
        textField.delegate = self
        return textField
    }()
    
    // 密码
    fileprivate lazy var passTextField: UITextField = {
        let textField = MHTextField.init(placeholder: "输入密码", leftImage: #imageLiteral(resourceName: "tf_login_password"), leftViewSize: CGSize(width: normalH, height: normalH), frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW - 2 * kMargin, height: normalH))
        textField.delegate = self
        return textField
    }()
    
    
    // 登录按钮
    fileprivate lazy var loginButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW - 2 * kMargin, height: normalH))
        btn.addTarget(self, action: #selector(highlightClick), for: .touchDown)
        btn.addTarget(self, action: #selector(touchOut), for: .touchCancel)
        btn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        btn.setTitle("登录", for: .normal)
        btn.backgroundColor = .groupTableViewBackground
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    // 忘记密码
    fileprivate lazy var forgetPassWordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(restorePassWord), for: .touchUpInside)
        btn.setTitle("忘记密码?", for: .normal)
        btn.backgroundColor = .groupTableViewBackground
        btn.setTitleColor(C.mainTextColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    // 快速注册
    fileprivate lazy var quickRegisterBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(gotoRegister), for: .touchUpInside)
        btn.setTitle("快速注册", for: .normal)
        btn.backgroundColor = .groupTableViewBackground
        btn.setTitleColor(C.mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        
        setupNav()
        
        setupUI()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNav() {
        
        /// 坑的一B
        edgesForExtendedLayout = []
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "登录"
        
        let rightBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "btn_dismiss"), target: self, action: #selector(LoginDismiss))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    
    private func setupUI() {
        
        view.addSubview(nameTextField)
        view.addSubview(passTextField)
        view.addSubview(loginButton)
        view.addSubview(forgetPassWordBtn)
        view.addSubview(quickRegisterBtn)
        
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
        
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(nameTextField)
            make.right.equalTo(nameTextField)
            make.top.equalTo(passTextField.snp.bottom).offset(kMargin * 1.5)
            make.height.equalTo(normalH)
        }
        
        forgetPassWordBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameTextField)
            make.top.equalTo(loginButton.snp.bottom).offset(kMargin)
            make.height.equalTo(normalH)
            make.width.equalTo(normalH * 2)
        }
        
        quickRegisterBtn.snp.makeConstraints { (make) in
            make.right.equalTo(nameTextField)
            make.top.height.width.equalTo(forgetPassWordBtn)
        }
        
        
        nameTextField.addCorner(radius: 3, borderWidth: 1, backgroundColor: .white, borderColor: .white)
        passTextField.addCorner(radius: 3, borderWidth: 1, backgroundColor: .white, borderColor: .white)
        loginButton.addCorner(radius: 3, borderWidth: 1, backgroundColor: C.mainColor, borderColor: C.mainColor)
    }
    
    
    @objc private func LoginDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
}


// MARK: - 按钮点击事件
extension ProfileLoginController {
    
    /// 高亮事件
    @objc fileprivate func highlightClick() {
        changeColor(true)
    }
    
    
    /// 点击按钮(登录)
    @objc fileprivate func loginBtnClick() {
        changeColor(false)
        
    }
    
    @objc fileprivate func touchOut() {
        changeColor(false)
    }
    
    /// 改变背景色
    private func changeColor(_ isHighLight: Bool) {
        loginButton.subviews.first?.removeFromSuperview()
        let color = isHighLight ? C.loginColor : C.mainColor
        loginButton.addCorner(radius: 3, borderWidth: 1, backgroundColor: color, borderColor: color)
        
        nameTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    
    // 忘记密码
    @objc fileprivate func restorePassWord() {
        print("恢复密码")
    }
    
    
    // 快速注册(进入注册页面)
    @objc fileprivate func gotoRegister() {
        let registerVC = ProfileRegisterController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}


extension ProfileLoginController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
