//
//  ProfileController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let ProfileCellID = "ProfileCellID"

private let imageData = ["image_my_recruitment","my_video_icon","Image_ticket","image_my_recommend","image_my_remind"]
private let titleData = ["主播招募","我的视频","票务中心","游戏中心","开播提醒"]

class ProfileController: UIViewController {
    
    fileprivate lazy var headerView: ProfileHeaderView = ProfileHeaderView()
    
    /// 登录页面
    fileprivate var loginView: ProfileTotalLoginView?
    
    /// 登录页面遮罩层
    fileprivate lazy var blurView: UIView = {
        let blureffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blureffect)
        effectView.frame = HmhDevice.screenRect
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenLoginView(_:)))
        effectView.addGestureRecognizer(tap)
        effectView.alpha = 0.0
        return effectView
    }()
    
    /// 关闭按钮
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "image_close_login"), for: .normal)
        btn.setImage(UIImage(named: "image_close_login_pressed"), for: .highlighted)
        btn.addTarget(self, action: #selector(hiddenLoginView(_:)), for: .touchUpInside)
        return btn
    }()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLogin), name: Notification.Name.MHSHowLogin, object: nil)
    }
    
    
    
    /// 显示登录页面
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
    }
    
    
    // 隐藏登录页面
    @objc private func hiddenLoginView(_ tap: UITapGestureRecognizer) {
        
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
        NotificationCenter.default.removeObserver(self)
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
    
    @objc fileprivate func showLogin() {
        headerView.loginButtonHidden(false)
    }
}
