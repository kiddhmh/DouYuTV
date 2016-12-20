//
//  ProfileHeaderView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/19.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

private let imgArray = ["image_my_history","image_my_focus","image_my_task","Image_my_pay"]
private let titleArray = ["观看历史","关注管理","我的任务","鱼翅充值"]

class ProfileHeaderView: UIView {
    
    fileprivate lazy var backImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Image_userView_background_Day"))
        return imageView
    }()
    
    fileprivate lazy var setButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Image_headerView_settings"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    fileprivate lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Image_headerView_message"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    fileprivate lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.text = "kidd风"
        return label
    }()
    
    fileprivate lazy var changeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_my_arrow_right_white"))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(backImageView)
        backImageView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalTo(self)
            make.height.equalTo(180)
        }
        
        addSubview(setButton)
        setButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.top.equalTo(self.snp.top).offset(20)
            make.right.equalTo(self.snp.right).offset(-10)
        }
        
        addSubview(messageButton)
        setButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.top.equalTo(self.snp.top).offset(20)
            make.right.equalTo(setButton.snp.left).offset(-10)
        }
        
        addSubview(iconView)
        iconView.image = UIImage(named: "萌妹子")?.circleImage()
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.width.height.equalTo(60)
            make.left.equalTo(backImageView).offset(20)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backImageView)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        addSubview(changeImageView)
        changeImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.centerY.equalTo(backImageView)
            make.right.equalTo(self.snp.right).offset(-10)
        }
    }
    
    private func setupButton() {
        
        let width: CGFloat = HmhDevice.screenW / 4
        let height: CGFloat = 80
        let y: CGFloat = backImageView.height
        
        for i in 0..<imgArray.count {
            let btn: MHCustomButton = MHCustomButton.setBtnImage(imgArray[i], title: titleArray[i])
            btn.frame = CGRect(x: HmhDevice.screenW / 4 * CGFloat(i), y: y, width: width, height: height)
            addSubview(btn)
        }
    }
}
