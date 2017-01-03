//
//  LivePrettyIconView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/31.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Kingfisher

class LivePrettyIconView: UIView {
    
    var model: AnchorModel? {
        didSet {
            guard let model = model, let icoURL = model.avatar_small else { return }
            let url = URL(string: icoURL)
            iconView.kf.setImage(with: url) { [weak self] (image, error, type, url) in
                guard let sself = self, let image = image else { return }
                if error?.domain == "NSURLErrorDomain" {return}
                sself.iconView.image = (image as UIImage).imageWithCornerRadius(16)
            }
            
            nameLabel.text = model.nickname ?? ""
            onlineLabel.text = HmhTools.handleNumber(model.online)
        }
    }
    
    fileprivate var iconView: UIImageView = {
        let iconView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        return iconView
    }()
    
    fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate var onlineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate var followBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "follow_btn"), for: .normal)
        btn.setImage(UIImage(named: "follow_btn_pressed"), for: .highlighted)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.8, alpha: 0.0)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(onlineLabel)
        addSubview(followBtn)
        
        iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(32)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(4)
        }
        
        followBtn.snp.makeConstraints { (make) in
            make.width.equalTo(44)
            make.height.equalTo(32)
            make.right.equalTo(self).offset(-4)
            make.centerY.equalTo(self)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.height.equalTo(self.height / 2)
            make.left.equalTo(iconView.snp.right).offset(3)
            make.right.equalTo(followBtn.snp.left).offset(-3)
        }
        
        onlineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.left.right.equalTo(nameLabel)
        }
    }
    
}
