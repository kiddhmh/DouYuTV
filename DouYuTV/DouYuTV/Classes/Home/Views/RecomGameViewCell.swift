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
    
    /// 右边分割线
    private lazy var rightView: UIImageView! = {
        let rightView = UIImageView(image: UIImage(named: "column_vline"))
        rightView.isHidden = true
        return rightView
    }()
    
    /// 左边分割线
    private lazy var bottomView: UIImageView! = {
        let bottomView = UIImageView(image: UIImage(named: "column_hline"))
        bottomView.isHidden = true
        return bottomView
    }()
    
    /// 右下角选中按钮
    private lazy var selectedImage: UIImageView! = {
        let imageView = UIImageView(image: UIImage(named: "column_selected"))
        imageView.isHidden = true
        return imageView
    }()
    
    var isHiddenCutLine: Bool? {
        didSet {
            guard let isHiddenCutLine = isHiddenCutLine else {return}
            bottomView.isHidden = isHiddenCutLine
            rightView.isHidden = isHiddenCutLine
        }
    }
    
    var isSelectedView: Bool? {
        didSet {
            guard let isSelectedView = isSelectedView else {return}
            selectedImage.isHidden = isSelectedView
        }
    }
    
    var imageURL: String? {
        didSet {
            guard let imageURL = imageURL else {
                let image = UIImage(named: "home_more_btn")
                self.iconImage.image = image?.circleImage()
                return
            }
            iconImage.kf.setImage(with: URL(string: imageURL )) { [weak self] (image, error, type, url) in
                guard let sself = self else { return }
                guard let image = image else { return }
                sself.iconImage.image = (image as UIImage).circleImage()
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
        
        addSubview(rightView)
        addSubview(bottomView)
        
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.right.height.centerY.equalTo(self)
        }
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.width.centerX.equalTo(self)
        }
        
        addSubview(selectedImage)
        selectedImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.bottom.right.equalTo(self)
        }
    }
    
}
