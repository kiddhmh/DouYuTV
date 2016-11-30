//
//  BaseFailedView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/30.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

@objc protocol BaseFailedViewDelegate {
    @objc optional func loadDataDidClick(failedView: BaseFailedView, _ button: UIButton)
}

class BaseFailedView: UIView {
    
    weak var delegate: BaseFailedViewDelegate?
    
    @IBOutlet weak var loadDataAngin: UIButton!
    
    @IBAction func loadDataAngin(_ sender: UIButton) {
        
        guard delegate != nil else {return}
        delegate?.loadDataDidClick!(failedView: self, sender)
    }
    
}

extension BaseFailedView {
    
    class func failView() -> BaseFailedView {
        return HmhTools.createView("BaseFailedView") as! BaseFailedView
    }
    
}

