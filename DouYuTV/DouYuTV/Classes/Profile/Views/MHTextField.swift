//
//  MHTextField.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/28.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class MHTextField: UITextField {
    
    init(placeholder: String?, leftImage: UIImage, leftViewSize: CGSize, frame: CGRect) {
        
        super.init(frame: frame)
        self.placeholder = placeholder ?? ""
        self.font = UIFont.systemFont(ofSize: 14)
        self.clearButtonMode = .whileEditing
        self.backgroundColor = .groupTableViewBackground
        self.leftViewMode = .always
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftViewSize.width, height: leftViewSize.height))
        let imageView = UIImageView(image: leftImage)
        leftView.addSubview(imageView)
        imageView.center = leftView.center
        self.leftView = leftView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
