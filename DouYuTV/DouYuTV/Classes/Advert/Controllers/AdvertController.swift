//
//  AdvertController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

private var time: Int = 5

class AdvertController: UIViewController {
    
    fileprivate lazy var advertImageView: UIImageView = {
        let imageView = UIImageView(frame: HmhDevice.screenRect)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    fileprivate lazy var launchView: UIImageView = {
        let imageView = UIImageView(frame: HmhDevice.screenRect)
        imageView.image = UIImage(named: "LaunchImage-800-667h@2x")
        return imageView
    }()
    
    fileprivate var advertModel: AdvertModel?
    
    fileprivate lazy var advertVM: AdvertViewModel = AdvertViewModel()
    
    // 跳过广告
    var jumpClosure: (() -> ())?
    
    fileprivate var timer: DispatchSourceTimer?
    
    fileprivate lazy var jumpButton: UIButton = { [weak self] in
        let btn = UIButton()
        guard let sself = self else { return btn}
        btn.setTitleColor(.white, for: .normal)
        btn.alpha = 0.6
        btn.backgroundColor = .darkGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        let attStr = sself.addAttributed(time)
        btn.setAttributedTitle(attStr, for: .normal)
        btn.addTarget(sself, action: #selector(jump), for: .touchDown)   //touchDown
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        loadData()
    }
    
    private func setupUI() {
        
        view.addSubview(advertImageView)
        view.addSubview(jumpButton)
        view.addSubview(launchView)
        advertImageView.isHidden = true
        jumpButton.isHidden = true
        launchView.isHidden = false
        
        jumpButton.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-15)
            make.top.equalTo(view.snp.top).offset(15)
        }
    }
    
}


extension AdvertController {
    
    fileprivate func loadData() {
        
        advertVM.requestAvertData(complectioned: { [weak self] in
            guard let sself = self else { return }
            guard let model = sself.advertVM.advertModels else { return }
            sself.advertModel = model
            if MHCache.mh_isCache(model.picurl) == true {   // 本地读取
                sself.advertImageView.image = MHCache.mh_readImage(model.picurl)
                sself.startTime()
            }else { // 下载
                let url = URL(string: model.picurl ?? "")
                sself.advertImageView.kf.setImage(with: url, completionHandler: { (image, error, type, url) in
                    sself.startTime()
                })
            }
            }, failed: { [weak self] (error) in
                guard let sself = self else { return }
                if sself.jumpClosure != nil {
                    sself.jumpClosure!()
                }
            })
    }
    
    /// 定时器
    fileprivate func startTime() {
        
        launchView.isHidden = true
        advertImageView.isHidden = false
        jumpButton.isHidden = false
        
        // 创建定时任务
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            time -= 1
            
            DispatchQueue.main.async { [weak self] in
                guard let sself = self else { return }
                let attStr = sself.addAttributed(time)
                sself.jumpButton.setAttributedTitle(attStr, for: .normal)
                
                if time == 0 {
                    sself.view.removeFromSuperview()
                    sself.timer?.cancel()
                    if sself.jumpClosure != nil {
                        sself.jumpClosure!()
                    }
                }
            }
        }
        
        timer?.resume()
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

