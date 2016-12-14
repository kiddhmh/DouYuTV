//
//  RecomGameViewCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/1.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class RecomGameViewCell: UICollectionViewCell {
    
    public lazy var iconImage: UIImageView! = {
        let image = UIImageView()
        return image
    }()
    
    public lazy var titleLabel: UILabel! = {
       let label = UILabel()
        label.textColor = C.mainTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var imageURL: String? {
        didSet {
            guard let imageURL = imageURL else {
                let image = UIImage(named: "home_more_btn")
                self.iconImage.image = image?.circleImage()
                return
            }
            iconImage.kf.setImage(with: URL(string: imageURL )) { [weak self] (image, error, type, url) in
                guard let sself = self else { return }
                sself.iconImage.image = (image! as UIImage).circleImage()
            }
        }
    }
    
    var title: String? {

        didSet {
            guard let title = title else {
                titleLabel.text = "更多"
                return
            }
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(45)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-8)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.iconImage.snp.bottom).offset(5)
        }
    }
    
}
