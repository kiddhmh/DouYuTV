//
//  AdvertController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

private var time: Int = 4

class AdvertController: UIViewController {
    
    fileprivate lazy var advertImageView: UIImageView = {
        let imageView = UIImageView(frame: HmhDevice.screenRect)
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // 跳过广告
    var jumpClosure: (() -> ())?
    
    fileprivate var timer: DispatchSourceTimer?
    
    fileprivate lazy var jumpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.red
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("跳过", for: .normal)
        btn.addTarget(self, action: #selector(jump), for: .touchDown)   //touchDown
        return btn
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "\(time)s"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()
        
        // 创建定时任务
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            time -= 1
            
            DispatchQueue.main.async { [weak self] in
                self?.timeLabel.text = "\(time)s"

                if time == 0 {
                    self?.view.removeFromSuperview()
                    self?.timer?.cancel()
                    if self?.jumpClosure != nil {
                        self?.jumpClosure!()
                    }
                }
            }
        }
        
        timer?.resume()
    }
    
    private func setupUI() {
        
        view.addSubview(advertImageView)
        view.addSubview(jumpButton)
        view.addSubview(timeLabel)
        
        jumpButton.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left)
            make.top.equalTo(view.snp.top).offset(10)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(jumpButton.snp.right)
            make.top.equalTo(jumpButton.snp.top)
            make.height.equalTo(jumpButton.snp.height)
            make.right.equalTo(view.snp.right).offset(-10)
        }
    }
    
}


extension AdvertController {
    
    @objc fileprivate func jump() {
        if self.jumpClosure != nil {
            timer?.cancel()
            self.jumpClosure!()
        }
    }
    
}

