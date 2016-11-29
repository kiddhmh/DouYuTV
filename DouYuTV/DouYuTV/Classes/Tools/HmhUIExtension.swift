//
//  HmhUIExtension.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIImage
extension UIImage {
    
    /// 获取图片中某一点的颜色
    func getColor(_ point: CGPoint!) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data = CFDataGetBytePtr(pixelData)!
        let pixelInfo = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        
        let red = CGFloat(data[pixelInfo]) / 255
        let green = CGFloat(data[pixelInfo + 1]) / 255
        let blue = CGFloat(data[pixelInfo + 2]) / 255
        let alpha = CGFloat(data[pixelInfo + 3]) / 255
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
        
    }
    
    func getColorCustom() -> UIColor {
        return self.getColor(CGPoint.zero)
    }
    
}


// MARK: - UIColor
extension UIColor {
    
    ///生成一个随机色
    static var randomColor: UIColor {
        return UIColor(r:Float(arc4random_uniform(256)), g:Float(arc4random_uniform(256)), b:Float(arc4random_uniform(256)))
    }
    
    /// 使用rgb创建UIColor对象.
    convenience init(r:Float, g:Float, b:Float, a:Float = 1.0) {
        self.init(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a))
    }
    
    /**
     色值转换为UIColor对象.
     
     - parameter hex:   色值的字符串,格式为 #FF0000 或者 FF0000
     - parameter alpha: 透明度，默认为1.0
     
     - returns: UIColor对象
     */
    
    convenience init(hex:String, _ alpha:Float = 1.0) {
        
        var cString: NSString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
    
        
        if cString.hasPrefix("#") {
            cString = cString.substring(from: 1) as NSString
        }
        
        assert(cString.length == 6, "色值必须是6位的字符串")
        
        let rString = cString.substring(to: 2)
        let gString = cString.substring(with: NSMakeRange(2, 2))
        let bString = cString.substring(with: NSMakeRange(4, 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(Float(r) / 255.0), green: CGFloat(Float(g) / 255.0), blue: CGFloat(Float(b) / 255.0), alpha: CGFloat(alpha))
    }

}



// MARK: - UIBarButtonItem
extension UIBarButtonItem {
    
    
    /**
     通过image和highlightImage初始化UIBarButtonItem.
     
     - parameter image:          image对象
     - parameter highlightImage: highlightImage对象
     - parameter size:           size对象，默认为当前图片的大小.
     - parameter target:         target
     - parameter action:         action
     
     - returns: UIBarButtonItem的对象.
     */
    convenience init(image: UIImage, highlightImage: UIImage? = nil, size: CGSize? = nil, target: AnyObject? = nil, action: Selector) {

        
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        if let hightImage = highlightImage  {
            btn.setImage(hightImage, for: .highlighted)
        }
        
        if let size = size {
            btn.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        } else {
            btn.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: btn)
    }
    
    
    /**
     通过title和titleColor初始化UIBarButtonItem.
     
     - parameter title:      title.
     - parameter titleColor: title的颜色.
     - parameter font:       字体对象，默认为17，可以不传入.
     - parameter size:       size的区域，默认适配当前的宽度.
     - parameter target:     target.
     - parameter action:     action.
     
     - returns: UIBarButtonItem的对象.
     */
    convenience init(title: String?, titleColor: UIColor?, font: UIFont = UIFont.systemFont(ofSize: 15), size:CGSize? = nil, target: AnyObject?, action:Selector) {
        let button = UIButton(type: .custom)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
        button.titleLabel?.font = font
        button.sizeToFit()
        
        self.init(customView:button)
    }
    
}


/// MARK - UIView
extension UIView {
    
    // MARK: - 常用位置属性
    
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    public var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
    }
    
    public var bottom:CGFloat {
        get {
            return self.top + self.height
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
}



