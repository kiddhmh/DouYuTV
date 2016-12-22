//
//  MHCustomButton.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/19.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

enum MHButtonType {
    case vertical   // 上下布局
    case horizontal // 左右布局
}

class MHCustomButton: MHNoHighlighButton {

    private var mhType: MHButtonType = .horizontal
    
    class func setBtnImage(_ imagename:String, title:String) -> MHCustomButton {
        let btn = MHCustomButton(frame: .zero, type: .vertical)
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: imagename), for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.contentMode = .center
        btn.titleLabel?.textAlignment = .center
        
        return btn
    }
    
    init(frame: CGRect, type: MHButtonType) {
        
        self.mhType = type
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch mhType {
        case .vertical:
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
        case .horizontal:
            let imgW : CGFloat = 24
            let imgH : CGFloat = 24
            let imgX : CGFloat = self.centerX - imgW * 2
            let imgY : CGFloat = self.centerY - 12
            self.imageView?.frame = CGRect.init(x: imgX, y: imgY, width: imgW, height: imgH)
            
            let titX : CGFloat = self.centerX
            let titY : CGFloat = self.centerY - 12
            let titW : CGFloat = self.width - titX
            let titH : CGFloat = imgH
            self.titleLabel?.frame = CGRect.init(x: titX, y: titY, width: titW, height: titH)
        }
    }
    
}
