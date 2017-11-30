//
//  ProfileSetController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/10.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import RealmSwift

private let profileSetcellID = "ProfileSetID"
private let proCenter: CGPoint = CGPoint(x: HmhDevice.screenW / 2, y: (HmhDevice.screenH - HmhDevice.navigationBarH) / 2)

class ProfileSetController: UIViewController {
    
    fileprivate lazy var dataSource: [String] = ["推送设置"]
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: profileSetcellID)
        return tableView
    }()
    
    // 推送设置页面
    fileprivate var pushConfigView: MHPushConfigView?
    
    fileprivate var blurEffectView: MHBlurEffctView = MHBlurEffctView.mhBlurEffectView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
//        edgesForExtendedLayout = []
        title = "设置"
        
        setupUI()
    }
    
    
    private func setupUI() {
        
        view.addSubview(tableView)
    }
    
}


// MARK: - UITableViewDataSource
extension ProfileSetController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: profileSetcellID, for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension ProfileSetController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 显示推送设置页面
        var isAddPushView: Bool = false
        for subview in view.subviews {
            if subview.isKind(of: MHPushConfigView.self) == true { isAddPushView = true }
        }
        guard !isAddPushView else { return }
        
        blurEffectView.alpha = 0.0
        view.insertSubview(blurEffectView, aboveSubview: tableView)
        UIView.animate(withDuration: 1.0) { 
            self.blurEffectView.alpha = 1.0
        }
        
        addPushConfigView(proCenter)
    }
    
    
    fileprivate func addPushConfigView(_ center: CGPoint, _ animate: String? = nil) {
        
        pushConfigView = MHPushConfigView.pushConfigView()
        guard let pushConfigView = pushConfigView else { return }
        view.insertSubview(pushConfigView, aboveSubview: blurEffectView)
        blurEffectView.isUserInteractionEnabled = false
        
        pushConfigView.snp.makeConstraints { (make) in
            make.center.equalTo(center)
            make.width.equalTo(HmhDevice.screenW * 0.8)
            make.height.equalTo(192)
        }
        
        pushConfigView.registerClosure = { [unowned self] type in
            self.registerClosure(type)
        }
        
        if animate != nil {
            pushConfigView.animation = animate!
        }
        
        pushConfigView.animateNext { [unowned self] in
            pushConfigView.isUserInteraction = true
            self.blurEffectView.isUserInteractionEnabled = true
        }
        
        blurEffectView.dismissClosure = { [unowned self] in
            self.pushConfigView?.animation = "fall"
            self.pushConfigView?.animateNext {
                self.pushConfigView?.removeFromSuperview()
            }
            
        }
    }
    
}


extension ProfileSetController {
    
    // 点击不同的推送按钮
    fileprivate func registerClosure(_ type: MHNotificationTrigger) {
        
        let model = searchNotificationObj()
        var title: String = ""
        switch type {
        case .timeInterval:
            title = "⏲"
            pushTitleArray = ["标题", "副标题", "内容", "附件", "时间间隔", "是否重复"]
        case .calendar:
            title = "📅"
            pushTitleArray = ["标题", "副标题", "内容", "附件", "日期", "是否重复"]
        case .location:
            title = "🌏"
            pushTitleArray = ["标题", "副标题", "内容", "附件", "地点", "是否重复"]
        }
        
        addRegisterView(title, model, trigger: type)
    }
    
    
    private func addRegisterView(_ title: String, _ model: RLMNotification, trigger: MHNotificationTrigger) {
        
        let timeView = MHTimeIntevalPushView.timeIntevalPushView()
        view.insertSubview(timeView, aboveSubview: blurEffectView)
        timeView.snp.makeConstraints({ (make) in
            make.center.equalTo(proCenter)
            make.width.equalTo(HmhDevice.screenW * 0.8)
            make.height.equalTo(200)
        })
        
        // 返回上一级回调
        timeView.backClosure = { [unowned self] in
            self.addPushConfigView(proCenter, "slideRight")
        }
        
        // 设置模型数据
        timeView.model = model
        timeView.timeIntevalNavItem.title = title
        
        blurEffectView.isUserInteractionEnabled = false
        timeView.animateNext {
            self.blurEffectView.isUserInteractionEnabled = false
        }
        
        // 设置当前推送类型
        timeView.trigger = trigger
        
        // 点击背景遮罩
        blurEffectView.dismissClosure = {
            timeView.animation = "fall"
            timeView.animateNext {
                timeView.removeFromSuperview()
            }
        }
    }
    
    
    // 从数据库读取模型
    private func searchNotificationObj() -> RLMNotification {
        
        let models = RealmTool.userReaml.objects(RLMNotification.self)
        
        guard models.count == 1 else {
            let noti = RLMNotification()
            let calendar = RLMCalendar()
            noti.calendar = calendar
            // 添加到数据库中
            try! RealmTool.userReaml.write {
                RealmTool.userReaml.add(noti)
            }
            return noti
        }
        
        return models.first!
    }
    
}
