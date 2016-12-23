//
//  MHSearchTypeView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class MHSearchTypeView: UIView {
    
    /// 视图容器
    fileprivate lazy var contentView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search_bar_combo_bg"))
        imageView.isUserInteractionEnabled = true
        imageView.width = 120
        imageView.height = 105
        return imageView
    }()
    
    /// 内容视图
    public var containerView: UIView? {
        
        didSet {
            guard let containerView = containerView else { return }
            containerView.top = 10
            containerView.left = 0
            containerView.width = contentView.width
            containerView.height = contentView.height - 10
            contentView.addSubview(containerView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 添加背景图
        addSubview(contentView)
    }
    
}


extension MHSearchTypeView {
    
    public class func typeView() -> MHSearchTypeView {
        return MHSearchTypeView()
    }
    
    /// 显示
    ///
    /// - Parameter view: 目标View
    public func showFromView(_ fromView: UIView) {
        
        let window = UIApplication.shared.windows.last
        window?.addSubview(self)
        self.frame = window?.bounds ?? .zero
        
        //调整contentView的位置
//        let newRect = fromView.convert(fromView.bounds, to: window)
//        contentView.top = newRect.maxY - 10
        contentView.top = HmhDevice.navigationBarH + 88 + 2 - contentView.height
        contentView.left = 3
    }
    
    
    /// 隐藏
    ///
    /// - Parameter complection: 完成的回调
    public func dismiss(_ complection: (() -> ())? = nil) {
        
        self.removeFromSuperview()
        guard let complection = complection else { return }
        complection()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
}
