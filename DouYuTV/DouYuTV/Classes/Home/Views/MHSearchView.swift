//
//  MHSearHeaderView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let backImg = UIImage(named: "search_navigationbar_textfield_background")
private let typeTitles: [String] = ["直播", "视频"]
private let typeImages: [UIImage] = [#imageLiteral(resourceName: "search_bar_combo_item_live"), #imageLiteral(resourceName: "search_bar_combo_item_video")]
private let placeholders: [String] = ["搜索房间/主播/分类", "搜索视频"]
private let kCellH: CGFloat = 44

class MHSearchView: UITextField {
    
    fileprivate lazy var CustomLeftView: MHNoHighlighButton = {
        let btn = MHNoHighlighButton()
        btn.addTarget(self, action: #selector(chooseType(_:)), for: .touchUpInside)
        btn.backgroundColor = backImg?.getColorCustom()
        btn.setImage(UIImage(named: "search_bar_type_icon"), for: .normal)
        btn.setTitle(typeTitles[0], for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(C.mainTextColor, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15)
        return btn
    }()
    
    // 搜索类别
    fileprivate lazy var searchTypeView: MHSearchTypeView = MHSearchTypeView.typeView()
    
    fileprivate lazy var containerView: UIView = { [unowned self] in
        let containerView = UIView()
        return containerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        background = backImg
        placeholder = placeholders[0]
        
        leftView = CustomLeftView
        leftViewMode = .always
        leftView?.width = 60
        leftView?.height = self.height
        clearButtonMode = .whileEditing
        
        self.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    fileprivate func creatBtn(_ title: String?, _ image: UIImage, _ tag: Int) -> MHNoHighlighButton {
        
        let btn = MHNoHighlighButton()
        btn.setImage(image, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(definiteType(_:)), for: .touchDown)
        btn.backgroundColor = .clear
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = tag
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        return btn
    }
    
}


extension MHSearchView {
    
    
    /// 点击切换搜索类别
    @objc fileprivate func chooseType(_ sender: MHNoHighlighButton) {
        
        searchTypeView.containerView = containerView
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        searchTypeView.showFromView(sender)
        
        // 显示类别视图
        let liveBtn: MHNoHighlighButton = self.creatBtn(typeTitles[0], typeImages[0], 0)
        let liveRect = CGRect(x: 3, y: HmhDevice.navigationBarH, width: containerView.width, height: kCellH)
        liveBtn.frame = searchTypeView.convert(liveRect, to: containerView)
        containerView.addSubview(liveBtn)
        
        let videoBtn = self.creatBtn(typeTitles[1], typeImages[1], 1)
        let videoRect = CGRect(x: 3, y: HmhDevice.navigationBarH + kCellH, width: liveBtn.width, height: kCellH)
        videoBtn.frame = searchTypeView.convert(videoRect, to: containerView)
        containerView.addSubview(videoBtn)
    }
    
    
    /// 点击某个类别 
    @objc fileprivate func definiteType(_ sender: MHNoHighlighButton) {
        
        let index = sender.tag
        searchTypeView.dismiss { [weak self] in
            guard let sself = self else { return }
            sself.placeholder = placeholders[index]
            sself.CustomLeftView.setTitle(typeTitles[index], for: .normal)
        }
    }
    
    // 恢复按钮响应事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = leftView?.frame
        guard !(rect?.contains(point) ?? false) else { return CustomLeftView }
        return super.hitTest(point, with: event)
    }
}

