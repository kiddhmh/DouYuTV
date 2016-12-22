//
//  ProfileInfoBottomVIew.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/21.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class ProfileInfoBottomView: UIView {
    
    var outLoginClosure: moreBtnClosure?
    
    fileprivate lazy var outLoginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.setBackgroundImage(C.mainColor.colorImage(), for: .normal)
        btn.setBackgroundImage(C.loginColor.colorImage(), for: .highlighted)
        btn.addTarget(self, action: #selector(outLogin), for: .touchUpInside)
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
        
        backgroundColor = .groupTableViewBackground
        
        insertSubview(outLoginButton, aboveSubview: self)
        outLoginButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(10)
        }
    }
    
    
    /// 退出登录
    @objc private func outLogin() {
        guard  let outClosure = outLoginClosure else { return }
        outClosure()
    }
}
