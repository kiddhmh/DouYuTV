//
//  LivePrettyBottomView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/31.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

enum LayerBottomType {
    case message
    case share
    case gift
    case praise
}

class LivePrettyBottomView: UIView {
    
    var clickBtnClosure: ((_ type: LayerBottomType) -> ())?
    
    // 信息
    fileprivate lazy var messageBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "dyla_btn_message"), for: .normal)
        btn.setImage(UIImage(named: "dyla_btn_message_pressed"), for: .highlighted)
        btn.addTarget(self, action: #selector(messageClick), for: .touchUpInside)
        return btn
    }()
    
    //分享
    fileprivate lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_room_share"), for: .normal)
        btn.setImage(UIImage(named: "btn_room_shareHL"), for: .highlighted)
        btn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        return btn
    }()
    
    //礼物
    fileprivate lazy var giftBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_show_giftview"), for: .normal)
        btn.setImage(UIImage(named: "btn_show_giftview_pressed"), for: .highlighted)
        btn.addTarget(self, action: #selector(giftClick), for: .touchUpInside)
        return btn
    }()
    
    //点赞
    fileprivate lazy var praiseBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "赞"), for: .normal)
        btn.setImage(UIImage(named: "赞_small"), for: .highlighted)
        btn.addTarget(self, action: #selector(praiseClick), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        addSubview(messageBtn)
        addSubview(giftBtn)
        addSubview(shareBtn)
        addSubview(praiseBtn)
        
        messageBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
        
        shareBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.left.equalTo(messageBtn.snp.right).offset(15)
            make.centerY.equalTo(self)
        }
        
        praiseBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
        }
        
        giftBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
            make.right.equalTo(praiseBtn.snp.left).offset(-15)
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func messageClick() {
        if clickBtnClosure != nil {
            clickBtnClosure!(.message)
        }
    }
    
    @objc private func shareClick() {
        if clickBtnClosure != nil {
            clickBtnClosure!(.share)
        }
    }
    
    @objc private func giftClick() {
        if clickBtnClosure != nil {
            clickBtnClosure!(.gift)
        }
    }
    
    @objc private func praiseClick() {
        if clickBtnClosure != nil {
            clickBtnClosure!(.praise)
        }
    }
}