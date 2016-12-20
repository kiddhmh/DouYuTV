//
//  MHQRCodeTool.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/20.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let defaultSize = CGSize(width: HmhDevice.screenW / 2, height: HmhDevice.screenW / 2)

class MHQRCodeTool: NSObject {
    
    
    /// 生成二维码图片
    /// - Parameters:
    ///   - content: 二维码中的内容
    ///   - size: 图片的大小
    class func creatQRCodeImage(_ content: String, _ size: CGSize? = nil) -> UIImage {
        
        let size = size == nil ? defaultSize : size
        let contentData = content.data(using: .utf8)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        qrFilter?.setValue(contentData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        
        colorFilter?.setValuesForKeys(["inputImage" : (qrFilter?.outputImage)!,"inputColor0":CIColor(cgColor: UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.white.cgColor)])
        
        let qrImage = colorFilter?.outputImage
        let cgImage = CIContext(options: nil).createCGImage(qrImage!, from: (qrImage?.extent)!)
        UIGraphicsBeginImageContext(size!)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .none
        context!.scaleBy(x: 1.0, y: -1.0)
        context?.draw(cgImage!, in: (context?.boundingBoxOfClipPath)!)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return codeImage!
    }
    
    
    
}
