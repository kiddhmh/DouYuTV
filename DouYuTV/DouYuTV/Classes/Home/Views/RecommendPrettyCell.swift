//
//  RecommendPrettyCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/24.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendPrettyCell: UICollectionViewCell {
    
    /// 房间图片
    @IBOutlet weak var backImage: UIImageView!
    /// 在线人数
    @IBOutlet weak var onlineLabel: UILabel!
    /// 主播昵称
    @IBOutlet weak var roomNameLabel: UILabel!
    /// 主播地址
    @IBOutlet weak var locationLabel: UILabel!
    
    var faceModel:  RecomFaceModel? {
        didSet {
            guard let faceModel = faceModel else {return}
            
            let url = URL(string: faceModel.vertical_src ?? "")
            backImage.kf.setImage(with: url, placeholder: UIImage(named: "live_cell_default_phone"))
            onlineLabel.text = HmhTools.handleNumber(faceModel.online)
            roomNameLabel.text = faceModel.nickname
            locationLabel.text = faceModel.anchor_city
        }
    }
    
}


extension RecommendPrettyCell {
    
    class func recomPrettyCell() -> RecommendPrettyCell {
        return HmhTools.createView("RecommendPrettyCell") as! RecommendPrettyCell
    }
    
}
