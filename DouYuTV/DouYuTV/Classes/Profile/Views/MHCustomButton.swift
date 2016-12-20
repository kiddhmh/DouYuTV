//
//  MHCustomButton.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/19.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class MHCustomButton: UIButton {
    
    override var isHighlighted:Bool {
        get{
            return false
        }
        set(newValue) {}
    }

    class func setBtnImage(_ imagename:String, title:String) -> MHCustomButton {
        let btn = MHCustomButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: imagename), for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.contentMode = .center
        btn.titleLabel?.textAlignment = .center
        
        return btn
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imgW : CGFloat = 22
        let imgH : CGFloat = 22
        let imgX : CGFloat = (self.width - imgW) / 2
        let imgY : CGFloat = self.height / 2 - imgH
        self.imageView?.frame = CGRect.init(x: imgX, y: imgY, width: imgW, height: imgH)
        
        let titX : CGFloat = 0
        let titY : CGFloat = self.height / 2 + 10
        let titW : CGFloat = self.width
        let titH : CGFloat = imgH
        self.titleLabel?.frame = CGRect.init(x: titX, y: titY, width: titW, height: titH)
    }
    
}
