//
//  LiveNoDataView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/19.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class LiveNoDataView: UIView {
    
    fileprivate lazy var messageLabel: UILabel  = {
        let label = UILabel()
        label.text = L.nodatamessage
        label.textAlignment = .center
        label.textColor = C.mainTextColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "img_no_data_history"))
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        addSubview(imageView)
        addSubview(messageLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(75)
            make.centerY.equalTo(self).offset(-10)
            make.centerX.equalTo(self)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
    }
    
}
