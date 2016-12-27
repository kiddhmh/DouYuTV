//
//  ProfileLoginController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let kMargin: CGFloat = 10

class ProfileLoginController: UIViewController {
    
    // 昵称
    fileprivate lazy var nameTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "昵称/用户名 (5-30位汉字、字母或数字)"
        textFiled.font = UIFont.systemFont(ofSize: 14)
        textFiled.clearButtonMode = .whileEditing
        textFiled.backgroundColor = .white
        textFiled.leftViewMode = .always
        textFiled.leftView = UIImageView(image: UIImage(named: "tf_login_username"))
        return textFiled
    }()
    
    // 密码
    fileprivate lazy var passTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "输入密码"
        textFiled.font = UIFont.systemFont(ofSize: 14)
        textFiled.clearButtonMode = .whileEditing
        textFiled.backgroundColor = .white
        textFiled.leftViewMode = .always
        textFiled.leftView = UIImageView(image: UIImage(named: "tf_login_password"))
        return textFiled
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
//        edgesForExtendedLayout = []
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "登录"
        
        let rightBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "btn_dismiss"), target: self, action: #selector(LoginDismiss))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    
    private func setupUI() {
        
        view.addSubview(nameTextField)
        view.addSubview(passTextField)
    
        nameTextField.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(kMargin)
            make.right.equalTo(view).offset(-kMargin)
            make.height.equalTo(44)
        }
        
        passTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(kMargin)
            make.top.equalTo(nameTextField.snp.bottom).offset(kMargin * 1.5)
            make.height.equalTo(nameTextField.snp.height)
        }
    }
    
    
    @objc private func LoginDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
