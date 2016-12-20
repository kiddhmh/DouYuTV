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
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
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
