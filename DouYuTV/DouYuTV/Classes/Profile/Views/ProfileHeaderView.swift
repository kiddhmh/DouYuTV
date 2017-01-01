//
//  ProfileHeaderView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/19.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit
import Spring
import Kingfisher

private let imgArray = ["image_my_history","image_my_focus","image_my_task","Image_my_pay"]
private let titleArray = ["观看历史","关注管理","我的任务","鱼翅充值"]

class ProfileHeaderView: UIView {
    
    /// 进入个人信息页面
    var gotoInforClosure: moreBtnClosure?
    
    /// 显示登录界面
    var showLoginViewClosure: moreBtnClosure?
    
    fileprivate var isAddCorner: Bool = false
    
    /// 背景图片
    fileprivate lazy var backImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Image_userView_background_Day"))
        return imageView
    }()
    
    /// 设置按钮
    fileprivate lazy var setButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Image_headerView_settings"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    /// 消息按钮
    fileprivate lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Image_headerView_message"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    /// 头像
    fileprivate lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        return imageView
    }()
    
    
    /// 昵称
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 进入下一页面
    fileprivate lazy var changeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_my_arrow_right_white"))
        return imageView
    }()
    
    
    /// 查看修改信息
    fileprivate lazy var infoBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(gotoInforVC), for: .touchUpInside)
        return btn
    }()
    
    
    /// 登录
    fileprivate lazy var loginButton: MHNoHighlighButton = {
        let btn: MHNoHighlighButton = MHNoHighlighButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        btn.backgroundColor = .clear
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.isHidden = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    /// 注册
    fileprivate lazy var registerButton: MHNoHighlighButton = {
        let btn: MHNoHighlighButton = MHNoHighlighButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        btn.backgroundColor = .clear
        btn.setTitle("注册", for: .normal)
        btn.isHidden = true
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name.LoginSuccess, object: nil)
        
        // 判断是否已经登录
        let name = HmhFileManager.simpleRead("user") as? String
        if name == nil {
            loginButtonHidden(false)
        }else {
            // 设置信息
            loginSuccess()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        addSubview(backImageView)
        backImageView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalTo(self)
            make.height.equalTo(180)
        }
        
        addSubview(setButton)
        setButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.top.equalTo(self.snp.top).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
        }
        
        addSubview(messageButton)
        setButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.top.equalTo(self.snp.top).offset(20)
            make.right.equalTo(setButton.snp.left).offset(-20)
        }
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView).offset(10)
            make.width.height.equalTo(70)
            make.left.equalTo(backImageView).offset(20)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.left.equalTo(iconView.snp.right).offset(20)
        }
        
        addSubview(changeImageView)
        changeImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.centerY.equalTo(backImageView)
            make.right.equalTo(self.snp.right).offset(-10)
        }
        
        addSubview(infoBtn)
        infoBtn.snp.makeConstraints { (make) in
            make.left.top.height.equalTo(iconView)
            make.right.equalTo(changeImageView.snp.right)
        }
        
        addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.centerY.equalTo(iconView.snp.centerY)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView.snp.centerY)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.left.equalTo(loginButton.snp.right).offset(10)
        }
    
    }
    
    private func setupButton() {
        
        let width: CGFloat = HmhDevice.screenW / 4
        let height: CGFloat = 80
        let y: CGFloat = backImageView.height
        
        for i in 0..<imgArray.count {
            let btn: MHCustomButton = MHCustomButton.setBtnImage(imgArray[i], title: titleArray[i])
            btn.frame = CGRect(x: HmhDevice.screenW / 4 * CGFloat(i), y: y, width: width, height: height)
            addSubview(btn)
        }
    }
    
    
    @objc private func gotoInforVC() {
        guard let gotoInforClosure = gotoInforClosure else { return }
        gotoInforClosure()
    }
}


extension ProfileHeaderView {
    
    // 显示或隐藏注册登录按钮
    public func loginButtonHidden(_ hidden: Bool) {
        
        loginButton.isHidden = hidden
        registerButton.isHidden = hidden
        nameLabel.isHidden = !hidden
        changeImageView.isHidden = !hidden
        infoBtn.isHidden = !hidden
        
        iconView.image = hidden ? UIImage(named: "萌妹子")?.circleImage() : UIImage(named: "Image_column_default")?.circleImage()
        
        guard isAddCorner == false else { return }
        loginButton.addCorner(radius: 3, borderWidth: 1, backgroundColor: .clear, borderColor: .white)
        registerButton.addCorner(radius: 3, borderWidth: 1, backgroundColor: .clear, borderColor: .white)
    }
    
    // 点击登录/注册按钮
    @objc fileprivate func loginBtnClick(_ sender: UIButton) {
        
        guard let showLoginViewClosure = showLoginViewClosure else { return }
        showLoginViewClosure()
    }
}


extension ProfileHeaderView {
    
    // 登录成功
    @objc public func loginSuccess() {
        
        // 读取用户信息
        let name = HmhFileManager.simpleRead("user") as? String
        guard let namee = name, name != "" else { return }
        
        let results = RealmTool.searchUser(name: namee)
        guard results.count != 0, results.first != nil else { return }
        
        let user = results.first!
        // 设置头像
        if user.iconurl == "" {
            iconView.image = UIImage(named: "萌妹子")?.circleImage()
        }else {
            let resource = URL(string: user.iconurl)
            iconView.kf.setImage(with: resource, placeholder: UIImage(named: "Image_column_default")?.circleImage(), completionHandler: { [weak self] (image, error, type, url) in
                guard let sself = self, let image = image else { return }
                if error?.domain == "NSURLErrorDomain" {return}
                sself.iconView.image = (image as UIImage).circleImage()
            })
        }
        
        // 设置昵称
        nameLabel.text = user.name
        
        loginButtonHidden(true)
        
        // 保存登录后的用户昵称
        HmhFileManager.simpleSave(user.name, forKey: "user")
    }
    
}
