//
//  RecommendSectionHeaderView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/24.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class RecommendSectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    
    var dataModel: HotModel? {
        didSet {
            guard let dataModel = dataModel else {return}
            titleLabel.text = dataModel.tag_name
            iconImage.image = UIImage(named: "home_header_normal")
        }
    }
    
    
    
    @IBAction func moreClick(_ sender: UIButton) {
        print("点击了更多")
    }
}


extension RecommendSectionHeaderView {
    // xib快速创建
    class func clooectionHeardView() -> RecommendSectionHeaderView {
        return HmhTools.createView("RecommendSectionHeaderView") as! RecommendSectionHeaderView
    }
}
