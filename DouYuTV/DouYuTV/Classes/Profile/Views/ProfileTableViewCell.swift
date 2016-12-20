//
//  ProfileTableViewCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/19.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var dataArray: [String]? {
        didSet {
            guard let dataArray = dataArray else {return}
            iconImage.image = UIImage(named: dataArray.first ?? "")
            titleLabel.text = dataArray.last
        }
    }
    
}
