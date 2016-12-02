//
//  GameViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//  游戏

import UIKit


class GameViewController: BaseViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            self.refreshControl?.endRefreshing()
        }
        
    }
}
