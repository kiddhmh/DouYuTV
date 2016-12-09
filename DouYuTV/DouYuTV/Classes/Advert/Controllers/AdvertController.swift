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
    
    fileprivate lazy var jumpButton: UIButton = { [weak self] in
        let btn = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.alpha = 0.6
        btn.backgroundColor = UIColor.darkGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        let attStr = self?.addAttributed(time)
        btn.setAttributedTitle(attStr, for: .normal)
        btn.addTarget(self, action: #selector(jump), for: .touchDown)   //touchDown
        return btn
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
                let attStr = self?.addAttributed(time)
                self?.jumpButton.setAttributedTitle(attStr, for: .normal)
                
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
//        view.addSubview(timeLabel)
        
        jumpButton.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-10)
            make.top.equalTo(view.snp.top).offset(10)
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
    
    /// 转换富文本
    fileprivate func addAttributed(_ time: Int) -> NSMutableAttributedString {
        
        let str = "跳过(\(time))"
        let dicStr = [NSForegroundColorAttributeName : UIColor.white]
        let att = NSMutableAttributedString(string: str, attributes: dicStr)
        let dic = [NSForegroundColorAttributeName : C.mainColor]
        att.addAttributes(dic, range: NSRange(location: 3, length: 1))
        return att;
    }
    
}

