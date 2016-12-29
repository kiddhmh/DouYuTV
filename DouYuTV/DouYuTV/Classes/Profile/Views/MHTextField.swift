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


extension MHTextField {
    
    // 判断是否满足密码条件
    public func isAllowPassword(complection: (_ message: String, _ isAllow: Bool) -> ()) -> Bool {
        
        guard let text = self.text else { // 不能为空
            complection("不能为空",false)
            return false
        }
        
        guard !text.isEmpty else {
            complection("不能为空",false)
            return false
        }
        
        let length = text.length
        guard length < 26 && length > 4  else {
            complection("仅限5~25个字符", false)
            return false
        }
        
        complection("", true)
        return true
    }
    
    
    // 判断是否满足登录条件
    public func isAllowUserName(complection: (_ message: String, _ isAllow: Bool) -> ()) -> Bool {
        
        let result = isAllowPassword { (message, isAllow) in
            guard isAllow else {
                complection(message, isAllow)
                return
            }
        }
        
        guard result else {
            return false
        }
        
        guard self.text!.isRightLogin else {
            complection(self.placeholder ?? "请按照提示填写", false)
            return false
        }
        
        complection("", true)
        return true
    }
    
}
