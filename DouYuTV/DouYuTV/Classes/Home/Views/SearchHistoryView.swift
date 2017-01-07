//
//  SearchHistoryView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/6.
//  Copyright © 2017年 CMCC. All rights reserved.
//  搜索历史视图

import UIKit
import RealmSwift
import MBProgressHUD

private let kMargin: CGFloat = 16
private let kBottomLineH: CGFloat = 10

typealias UpdateClosure = (_ height: CGFloat) -> Void

class SearchHistoryView: UIView {
    
    // MARK: - Public
    var tags: [String]? {
        didSet {
            guard let tags = tags, tags.count != 0 else { return }
            // 添加标签
            tagListView.addTags(tags)
            
            // 更新自身高度
            guard tagListView.intrinsicContentSize.height != 0, tagListView.intrinsicContentSize.width != 0 else { return }
            self.height = tagListView.top + tagListView.intrinsicContentSize.height + kBottomLineH + kMargin
            tagListView.snp.updateConstraints { (make) in
                make.height.equalTo(tagListView.intrinsicContentSize.height)
            }
            
            botomView.frame = CGRect(x: self.left, y: self.height - kBottomLineH, width: width, height: kBottomLineH)
            
            // 通知tableView更新高度
            guard let updateHeight = updateHeight else { return }
            updateHeight(self.height)
        }
    }
    
    var updateHeight: UpdateClosure?
    
    // MARK: - Private or FilePrivate
    // 标签视图
    fileprivate lazy var tagListView: MHTagListView = {
        let tagListView = MHTagListView()
        tagListView.textFont = UIFont.systemFont(ofSize: 14)
        tagListView.cornerRadius = 4
        tagListView.tagBackgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        tagListView.isUserInteractionEnabled = true
        tagListView.textColor = .darkGray
        tagListView.delegate = self
        return tagListView
    }()
    
    
    // 清空按钮
    fileprivate lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_search_clean"), for: .normal)
        btn.backgroundColor = .white
        btn.setTitle("清空", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(C.mainTextColor, for: .normal)
        btn.addTarget(self, action: #selector(clearHistory), for: .touchUpInside)
        btn.imageView?.contentMode = .center
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        return btn
    }()
    
    // 最近搜索
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .white
        label.text = "最近搜索"
        return label
    }()
    
    
    /// 底部Line
    fileprivate lazy var botomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(kMargin)
            make.top.equalTo(self).offset(20)
        }
        
        addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.centerY.height.equalTo(messageLabel)
            make.right.equalTo(self)
        }
        
        addSubview(tagListView)
        tagListView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(kMargin)
            make.right.equalTo(self).offset(-kMargin)
            make.top.equalTo(messageLabel.snp.bottom).offset(kMargin)
            make.height.equalTo(0)
        }

        addSubview(botomView)
    }
    
    // 清空搜索记录
    @objc private func clearHistory() {
        
        let results = RealmTool.userReaml.objects(SearchHistoryModel.self)
        guard results.count != 0 else { return }
        
        try! RealmTool.userReaml.write {
            RealmTool.userReaml.delete(results)
        }
        
        self.isHidden = true
        guard let updateHeight = updateHeight else { return }
        updateHeight(CGFloat(0))
    }
    
    
    // 清空标签
    public func removeAllTags() {
        tagListView.removeAllTags()
        
        guard let updateHeight = updateHeight else { return }
        updateHeight(CGFloat(0))
    }
}


extension SearchHistoryView: TagListViewDelegate{
    
    // 点击了某个tagView
    func tagPressed(_ title: String, tagView: MHTagView, sender: MHTagListView) {
        MBProgressHUD.showTips("点击了\(title)")
    }
}
