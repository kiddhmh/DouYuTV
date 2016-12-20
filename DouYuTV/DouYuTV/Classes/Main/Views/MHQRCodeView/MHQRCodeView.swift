//
//  MHQRCodeView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/20.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class MHQRCodeView: UIView {
    
    fileprivate lazy var lineImgV: UIImageView = {
        let lineView = UIImageView(image: UIImage(named: "扫描线"))
        lineView.contentMode = .scaleAspectFill
        lineView.backgroundColor = UIColor.clear
        return lineView
    }()
    
    fileprivate lazy var maskview: UIView = {
        let mask = UIView()
        mask.alpha = 0.5
        mask.backgroundColor = .black
        return mask
    }()
    
    fileprivate lazy var backImg: UIImageView = {
        let back = UIImageView(image: UIImage(named: "扫描框"))
        return back
    }()
    
    fileprivate lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.text = "将二维码放入框内,即可自动扫描"
        label.textColor = C.mainColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(maskview)
        addSubview(backImg)
        addSubview(msgLabel)
        addSubview(lineImgV)
        
        maskview.snp.makeConstraints { (make) in
            make.centerX.centerY.width.height.equalTo(self)
        }
        
        backImg.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(HmhDevice.screenW / 3 * 2)
        }
        
        msgLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(backImg.snp.bottom).offset(20)
        }
        
        lineImgV.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.width.top.left.equalTo(backImg)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 将扫描区域显示出来
        resetMaskView()
    }
    
    private func resetMaskView() {
        
        let path = UIBezierPath(rect: maskview.bounds)
        let clearPath = UIBezierPath(rect: CGRect(x: backImg.left + 1, y: backImg.top + 1, width: backImg.width - 2, height: backImg.height - 2)).reversing()
        path.append(clearPath)
        if let shapeLayer = maskview.layer.mask as? CAShapeLayer {
            shapeLayer.path = path.cgPath
        }else{
            let shapeLayer:CAShapeLayer = CAShapeLayer()
            maskview.layer.mask = shapeLayer
            shapeLayer.path = path.cgPath
        }
    }

}


extension MHQRCodeView {
    
    /// 开始扫描动画
    public func startAnimation() {
        lineImgV.isHidden = false
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: CGPoint(x: HmhDevice.screenW / 2, y: backImg.top - 1))
        animation.toValue = NSValue(cgPoint: CGPoint(x: HmhDevice.screenW / 2, y: backImg.bottom + 1))
        animation.duration = 2.0
        animation.repeatCount = Float(OPEN_MAX)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        self.lineImgV.layer.add(animation, forKey: "LineAnimation")
    }
    
    /// 停止扫描动画
    public func stopAnimation() {
        lineImgV.layer.removeAnimation(forKey: "LineAnimation")
        lineImgV.isHidden = true
    }
}
