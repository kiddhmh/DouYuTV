//
//  HmhUIExtension.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation
import UIKit

enum ValidatedType: String {
    case userName = "^[a-zA-Z0-9\\u4e00-\\u9fa5]{5,25}$"
    case phoneNumber = "^1[3|4|5|7|8][0-9]\\d{8}$"
    case idCard = "\\d{14}[[0-9],0-9xX]"
    case email = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
}

/// 正则表达式判断
func ValidateText(validatedType type: ValidatedType, _ validateString: String) -> Bool {
    
    do {
        
        let regex: NSRegularExpression = try NSRegularExpression(pattern: type.rawValue, options: .caseInsensitive)
        let matches = regex.matches(in: validateString, options: .reportProgress, range: NSRange(location: 0, length: validateString.characters.count))
        return matches.count > 0
    } catch {
        return false
    }
}

// MARK: - String
extension String {
    
    // 判断是否正确
    var isRightLogin: Bool {
        return ValidateText(validatedType: .userName, self)
    }
    
}


// MARK: - NSObject
extension NSObject {
    
    // 通过类名创建类（swift中需要命名空间加上类名）
    func swiftClassFromString(_ className: String) -> UIViewController? {
        
        // 1.获取命名空间
        guard let clsName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String, !className.isEmpty else {
            print("命名空间不存在")
            return nil
        }
        
        let cls: AnyClass? = NSClassFromString(clsName + "." + className)
        guard  let type = cls as? UIViewController.Type else {
            print("类名错误")
            return nil
        }
        
        let vc = type.init()
        return vc
    }
    
}


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
    
    
    /// 生成一定角度的圆角图片
    ///
    /// - parameter radius: 自定义的度数
    ///
    /// - returns: 圆角图片
    func imageWithCornerRadius(_ radius: CGFloat) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    /// 生成圆角图片
    ///
    /// - returns: 圆角图片
    func circleImage() -> UIImage? {
        
        UIGraphicsBeginImageContext(self.size)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx?.addEllipse(in: rect)
        ctx?.clip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    /// 向二维码中添加图片(不能过大)
    ///
    /// - Parameters:
    ///   - icon: 添加的图片
    ///   - iconSize: 添加图片的大小
    func addIconToQRCodeImage(_ icon:UIImage, _ iconSize:CGSize? = nil) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        let imgw = self.size.width
        let imgh = self.size.height
        let iconSize = iconSize == nil ? CGSize(width: imgw / 3, height: imgh / 3) : iconSize
        let icow = iconSize!.width
        let icoh = iconSize!.height
        
        self.draw(in: CGRect(x: 0, y: 0, width: imgw, height: imgh))
        icon.draw(in: CGRect(x: (imgw-icow)/2.0, y: (imgh-icoh)/2.0, width: icow, height: icoh))
        let qrImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return qrImage!
    }
    
    
    /// 二维码图片读取
    ///
    /// - Parameters:
    ///   - completion: 成功回调
    ///   - failed: 失败回调
    func readQRImage(_ completion: (_ value: String) -> (), _ failed: (_ message: String) -> ()) {
        //二维码读取
        let ciImage:CIImage = CIImage(image: self)!
        let context = CIContext(options: nil)
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode,
                                           context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let features=detector.features(in: ciImage)
        
        var stringValue:String = ""
        
        if features.count<=0 {
            failed("无法解析图片")
            return
        }else {
            //遍历所有的二维码，并框出
            for feature in features as! [CIQRCodeFeature] {
                stringValue = feature.messageString!
            }
        }
        completion(stringValue)
    }
    
}


// MARK: - UIColor
extension UIColor {
    
    ///生成一个随机色
    @nonobjc static var randomColor: UIColor {
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

    
    /// 把颜色转换成图片
    public func colorImage() -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
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
    
    
    /// 为UIView添加圆角效果(高效)
    func addCorner(radius: CGFloat) {
        self.addCorner(radius: radius, borderWidth: 1, backgroundColor: .clear, borderColor: .white)
    }
    
    
    
    /// 添加圆角
    ///
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - borderWidth: 边框线宽度
    ///   - backgroundColor: 背景色
    ///   - borderColor: 边框色
    func addCorner(radius: CGFloat,
                      borderWidth: CGFloat,
                      backgroundColor: UIColor,
                      borderColor: UIColor) {
        let imageView = UIImageView(image: drawRectWithRoundedCorner(radius: radius,
                                                                        borderWidth: borderWidth,
                                                                        backgroundColor: backgroundColor,
                                                                        borderColor: borderColor))
        self.insertSubview(imageView, at: 0)
    }
    
    /// 生成圆角图片
    func drawRectWithRoundedCorner(radius: CGFloat,
                                      borderWidth: CGFloat,
                                      backgroundColor: UIColor,
                                      borderColor: UIColor) -> UIImage {
        
        let sizeToFit = CGSize(width: self.width, height: self.height)
        let halfBorderWidth = borderWidth / 2.0
        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(borderWidth)
        context?.setStrokeColor(borderColor.cgColor)
        context?.setFillColor(backgroundColor.cgColor)
        
        let width = sizeToFit.width, height = sizeToFit.height
        context?.move(to: CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth))  // 开始坐标右边开始
        context?.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint(x: width - radius - halfBorderWidth, y: height - halfBorderWidth), radius: radius)  // 右下角角度
        context?.addArc(tangent1End: CGPoint(x: halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint(x: halfBorderWidth, y: height - radius - halfBorderWidth), radius: radius)          // 左下角角度
        
        context?.addArc(tangent1End: CGPoint(x: halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint(x: width - halfBorderWidth, y: halfBorderWidth), radius: radius)          // 左上角
        context?.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint(x: width - halfBorderWidth - halfBorderWidth, y: radius + halfBorderWidth), radius: radius)          // 右上角
        
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
    
    
}


private var key: Void?

// MARK: - UIButton
extension UIButton {
    
    /// 边框颜色(用于StoryBoard)
    public var borderFromUIColor: UIColor? {
        
        get {
            return objc_getAssociatedObject(self, &key) as? UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.borderColor = borderFromUIColor?.cgColor
        }
    }
    
}


private var keyText: Void?
// MARK: - UITextField 增加indexPath属性
extension UITextField {
    
    public var indexPath: IndexPath? {
        
        get {
            return objc_getAssociatedObject(self, &keyText) as? IndexPath
        }
        set(newValue) {
            objc_setAssociatedObject(self, &keyText, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}


// 改变屏幕方向
extension UIDevice {
    
    static func setOrientation(_ isFull: Bool) {
        
        if isFull == true {
            
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }else {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
}

