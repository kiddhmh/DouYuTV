//
//  SearchHistoryCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/25.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

// 测试
private let kCustom: CGFloat = 40

class SearchHistoryCell: UITableViewCell {
    
    /// 左边的序号Label
    fileprivate lazy var numLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    /// 右边的标题Labl
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kCustom, height: kCustom))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = C.mainTextColor
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
    
        contentView.addSubview(numLabel)
        contentView.addSubview(titleLabel)
        
        numLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(13)
            make.width.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numLabel.snp.right).offset(10)
            make.top.equalTo(numLabel.snp.top)
            make.height.equalTo(numLabel)
            make.width.equalTo(HmhDevice.screenW - 44)
        }
    }
    
}


extension SearchHistoryCell {
    
    class func cell(withTableView tableView: UITableView, _ indexPath: IndexPath) -> SearchHistoryCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID.SearchHistoryCellID) as? SearchHistoryCell
        if cell == nil {
            cell = SearchHistoryCell(style: .default, reuseIdentifier: CellID.SearchHistoryCellID)
        }
        return cell!
    }
    
    
    open func setTitle(_ title: String?, withIndex index: Int) {
        guard index >= 0 else { return }
        
        var color: UIColor = .gray
        if index < 3 {
            color = UIColor(red: 1.0, green: CGFloat(index) * 0.29, blue: CGFloat(index - 1) * 0.14, alpha: 1)
        }
        numLabel.addCorner(radius: 2, borderWidth: 1, backgroundColor: color, borderColor: color)
        
        numLabel.text = "\(index + 1)"
        titleLabel.text = title ?? ""
        
        // 调换圆角图片的位置
        let cornerView = numLabel.subviews.first
        cornerView?.removeFromSuperview()
        
        if contentView.subviews.count == 3 {
            contentView.subviews.first?.removeFromSuperview()
        }
        contentView.insertSubview(cornerView!, belowSubview: numLabel)
        cornerView?.snp.makeConstraints({ (make) in
            make.center.width.height.equalTo(numLabel)
        })
    }
    
}
