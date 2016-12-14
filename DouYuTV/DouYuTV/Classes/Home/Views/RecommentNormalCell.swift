//
//  RecommentNormalCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/24.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import Kingfisher

class RecommentNormalCell: UICollectionViewCell {
    
    /// 房间图片
    @IBOutlet weak var backImage: UIImageView!
    /// 房间标题
    @IBOutlet weak var roomTitleLbale: UILabel!
    /// 主播昵称
    @IBOutlet weak var roomNameLabel: UILabel!
    /// 在线人数
    @IBOutlet weak var onlineLabel: UILabel!
    
    
    var anchorModel: AnchorModel? {
        didSet {
            guard let anchorModel = anchorModel else {return}
            let url = URL(string: anchorModel.vertical_src ?? "")
            
            backImage.kf.setImage(with: url, placeholder: UIImage(named: "Img_default"), completionHandler: { [weak self] (image, error, type, url)  in
                guard let sself = self, let image = image else { return }
                if error?.domain == "NSURLErrorDomain" {return}
                sself.backImage.image = (image as UIImage).imageWithCornerRadius(15)
                })
            
            roomTitleLbale.text = anchorModel.room_name
            roomNameLabel.text = anchorModel.nickname
            onlineLabel.text = HmhTools.handleNumber(anchorModel.online)
        }
    }
    
}

extension RecommentNormalCell {
    
    class func recomNormalCell() -> RecommentNormalCell {
        return HmhTools.createView("RecommentNormalCell") as! RecommentNormalCell
    }
    
}
