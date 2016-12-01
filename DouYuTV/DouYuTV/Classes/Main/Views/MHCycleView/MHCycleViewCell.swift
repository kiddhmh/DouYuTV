//
//  MHCycleViewCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/1.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class MHCycleViewCell: UICollectionViewCell {
    
    /// 文字标题间距
    private let KMargin = CGFloat(8)
    /// 轮播图片
    lazy var imageView = UIImageView()
    /// 轮播标题
    lazy var titleLab = UILabel()
    
    var cycleModel: MHCycleModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.height.width.centerY.centerX.equalTo(self)
        }
        
        addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.right.bottom.width.equalTo(self)
            make.height.equalTo(30)
        }
        titleLab.backgroundColor = UIColor(r: 178, g: 178, b: 178, a: 0.5)
        titleLab.tag = 2
        titleLab.textColor = UIColor.white
        titleLab.textAlignment = .left
        titleLab.font = UIFont.systemFont(ofSize: 14, weight: 8)
        titleLab.alpha = 0.6
    }
    
}
