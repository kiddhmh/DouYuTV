//
//  MHBlurEffctView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/11.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import Spring

class MHBlurEffctView: SpringView {
    
    static let mhBlurEffectView: MHBlurEffctView = MHBlurEffctView(frame: HmhDevice.screenRect)
    
    var dismissClosure: moreBtnClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backImg = UIImageView(image: UIImage(named: "backImg"))
        backImg.frame = frame
        addSubview(backImg)
        let blureffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blureffect)
        effectView.frame = frame
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFromSuperView))
        effectView.addGestureRecognizer(tap)
        addSubview(effectView)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissFromSuperView() {
        
        alphaDismiss()
        
        guard let dismissClosure = dismissClosure else { return }
        dismissClosure()
    }
    
    
    private func alphaDismiss() {
        
        UIView.animate(withDuration: 1.0, animations: {
            self.alpha = 0.0
        }, completion: { (bool) in
            self.removeFromSuperview()
        })
    }
}
