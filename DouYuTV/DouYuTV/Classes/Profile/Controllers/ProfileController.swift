//
//  ProfileController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

private let ProfileCellID = "ProfileCellID"

private let imageData = ["image_my_recruitment","my_video_icon","Image_ticket","image_my_recommend","image_my_remind"]
private let titleData = ["主播招募","我的视频","票务中心","游戏中心","开播提醒"]

class ProfileController: UIViewController, StartLiveViewDelegate {
    
    fileprivate lazy var headerView: ProfileHeaderView = ProfileHeaderView()
    
    /// 登录页面
    fileprivate var loginView: ProfileTotalLoginView?
    
    /// 登录页面遮罩层
    fileprivate lazy var blurView: UIView = {
        let blureffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blureffect)
        effectView.frame = HmhDevice.screenRect
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenLoginView))
        effectView.addGestureRecognizer(tap)
        effectView.alpha = 0.0
        return effectView
    }()
    
    /// 关闭按钮
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "image_close_login"), for: .normal)
        btn.setImage(UIImage(named: "image_close_login_pressed"), for: .highlighted)
        btn.addTarget(self, action: #selector(hiddenLoginView), for: .touchUpInside)
        return btn
    }()
    
    /// 录制按钮
    fileprivate lazy var startLiveView: StartLiveView = StartLiveView.liveView
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tableView: UITableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headerView
        tableView.bounces = false
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileCellID)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        headerView.frame = CGRect(x: tableView.left, y: tableView.top, width: tableView.width, height: 260)
        headerView.gotoInforClosure = { [unowned self] in
            let infoVC = ProfileInforController()
            self.navigationController?.pushViewController(infoVC, animated: true)
        }
        
        headerView.showLoginViewClosure = { [unowned self] in
            self.showLoginView()
        }
        
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        // 添加录制按钮
        view.insertSubview(startLiveView, aboveSubview: tableView)
        startLiveView.delegate = self
        startLiveView.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.bottom.equalTo(view).offset(-HmhDevice.tabBarH - 15)
            make.right.equalTo(view).offset(-15)
        }
        
        MHNotification.addObserver(observer: self, selector: #selector(showLogin), notification: .showLogin)
    }
    
    
    
    /// 弹出登录页面
    private func showLoginView() {
        self.blurView.alpha = 0.0
        loginView = ProfileTotalLoginView.totalLoginView()
        UIApplication.shared.keyWindow?.addSubview(blurView)
        UIApplication.shared.keyWindow?.addSubview(loginView!)
        loginView?.addSubview(closeBtn)
        
        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 1.0
        }
        
        loginView!.snp.makeConstraints { (make) in
            make.centerX.equalTo(blurView)
            make.centerY.equalTo(blurView).offset(-30)
            make.left.equalTo(blurView).offset(30)
            make.height.equalTo(HmhDevice.screenW)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginView!.snp.bottom).offset(30)
            make.centerX.equalTo(loginView!)
            make.width.height.equalTo(24)
        }
        
        loginView!.animate()
        
        // 添加登录回调闭包
        setupLoginClosure()
    }
    
    
    // 隐藏登录页面
    @objc fileprivate func hiddenLoginView() {
        
        loginView!.animation = "zoomOut"
        loginView?.animate()
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.blurView.alpha = 0.0
        }) { (bool) in
            guard bool == true else { return }
            self.blurView.removeFromSuperview()
            self.loginView?.removeFromSuperview()
        }
        
        closeBtn.removeFromSuperview()
    }
    
    deinit {
        MHNotification.removeAll(observer: self)
    }
}


extension ProfileController {
    
    fileprivate func setupLoginClosure() {
        
        loginView?.loginClosure = { [unowned self] in // 登录
            
            let LoginVC = ProfileLoginController()
            let nav = BaseNavigationController(rootViewController: LoginVC)
            self.present(nav, animated: true, completion: nil)
            self.hiddenLoginView()
        }
        
        loginView?.resgisterClosure = { // 注册
            let registerVC = ProfileRegisterController()
            let nav = BaseNavigationController(rootViewController: registerVC)
            self.present(nav, animated: true, completion: nil)
            self.hiddenLoginView()
        }
        
        // 第三方登录
        loginView?.thirdClosure = { [unowned self] type in
            
            var platformType: UMSocialPlatformType
            
            switch type {
            case .wx:
              platformType = .wechatSession // 微信
            case .qq:
              platformType = .QQ            // QQ
            case .sina:
              platformType = .sina          // 微博
            }
            
            MBProgressHUD.showLoading("请稍后", toView: self.loginView)
            self.getUserInfoForPlatform(platformType)
        }
    }
    
    
    // 获取登录信息
    fileprivate func getUserInfoForPlatform(_ platformType: UMSocialPlatformType) {
        
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: self) { [unowned self]  (result, error) in
            guard error == nil else {
                print("第三方登录错误信息 === \(error)")
                return
            }
            
            // 获取信息并存储
            let resp = result as? UMSocialUserInfoResponse
            guard let respp = resp else { return }
            let user = RLMUser()
            user.uid = respp.uid
            user.openid = respp.openid ?? ""
            user.accessToken = respp.accessToken ?? ""
            user.refreshToken = respp.refreshToken ?? ""
            user.expiration = respp.expiration as NSDate?
            
            user.name = respp.name ?? ""
            user.iconurl = respp.iconurl ?? ""
            user.gender = respp.gender ?? "m"
            
            // 保存登录后的用户昵称
            let isRegister = RealmTool.isRegister(user)
            if isRegister == false { // 未注册过
                let isSuccess = RealmTool.addObject(user)
                guard isSuccess == true else { return }
            }
            
            HmhFileManager.simpleSave(user.name, forKey: "user")
            
            MBProgressHUD.hide(for: self.loginView!, animated: true)
            
            self.headerView.loginSuccess()
            self.hiddenLoginView()
        }
    }
}


extension ProfileController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? 1 : 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCellID, for: indexPath) as? ProfileTableViewCell
        cell?.dataArray = [imageData[indexPath.section * 2 + indexPath.row],titleData[indexPath.section * 2 + indexPath.row]]
        
        return cell!
    }
    
}


extension ProfileController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let url = URL(string: "http://uri6.com/Zf2AZr")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:]) { (bool) in
                print("=========\(bool)")
            }
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
}

/// 通知方法
extension ProfileController {
    
    // 弹出登录页面
    @objc fileprivate func showLogin() {
        headerView.loginButtonHidden(false)
    }
}
