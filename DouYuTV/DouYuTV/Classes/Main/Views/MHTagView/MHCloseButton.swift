//
//  MHCloseButton.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/6.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit

internal class MHCloseButton: UIButton {
    
    var iconSize: CGFloat = 10
    var lineWidth: CGFloat = 1
    var lineColor: UIColor = UIColor.white.withAlphaComponent(0.54)
    
    weak var tagView: MHTagView?
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        
        let iconFrame = CGRect(
            x: (rect.width - iconSize) / 2.0,
            y: (rect.height - iconSize) / 2.0,
            width: iconSize,
            height: iconSize
        )
        
        path.move(to: iconFrame.origin)
        path.addLine(to: CGPoint(x: iconFrame.maxX, y: iconFrame.maxY))
        path.move(to: CGPoint(x: iconFrame.maxX, y: iconFrame.minY))
        path.addLine(to: CGPoint(x: iconFrame.minX, y: iconFrame.maxY))
        
        lineColor.setStroke()
        
        path.stroke()
    }
    
}
