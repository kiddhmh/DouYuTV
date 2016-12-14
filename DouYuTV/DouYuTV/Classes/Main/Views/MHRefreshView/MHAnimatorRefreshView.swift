//
//  MHAnimatorRefreshView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/2.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class MHAnimatorRefreshView: UIView {
    
    var lastUpdateTime: Date? {
        didSet {
            guard let date = lastUpdateTime else {return}
            let str = dateToString(date)
            timeLabel.text = str
        }
    }
    
    var refreshStatus: MHRefreshState = .normal {
        
        didSet {
            switch refreshStatus {
            case .normal:
                tipIcon.isHidden = false
                tipIndicator.stopAnimating()
                tipLabel.text = "下拉可以刷新"
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform.identity
                })
            case .pulling:
                tipLabel.text = "松开立即刷新"
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                })
            case .willRefresh:
                tipLabel.text = "正在刷新数据..."
                tipIcon.isHidden = true
                tipIndicator.startAnimating()
            }
        }
    }
    
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = C.mainTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "下拉可以刷新"
        return label
    }()
    
    fileprivate lazy var tipIcon: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "tableview_pull_refresh")
        imageView.contentMode = .center
        return imageView
    }()
    
    fileprivate lazy var tipIndicator: UIActivityIndicatorView = {
        let indica = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indica.isHidden = true
        return indica
    }()
    
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = C.mainTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        self.refreshStatus = .normal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(tipLabel)
        addSubview(tipIcon)
        addSubview(tipIndicator)
        addSubview(timeLabel)
        
        tipIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(60)
            make.top.equalTo(self.snp.top)
            make.height.width.equalTo(66)
        }
        
        tipIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(tipIcon)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX)
            make.bottom.equalTo(tipIcon.snp.centerY)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipLabel.snp.left)
            make.top.equalTo(tipIcon.snp.centerY)
        }
    }
    
    
    private func dateToString(_ date: Date) -> String {
        if timeLabel.isHidden == true {return ""}
        
        let selector = NSSelectorFromString("calendarWithIdentifier:")
        var calendar: NSCalendar
        if NSCalendar.responds(to: selector) {
            calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        }else {
            calendar = NSCalendar.current as NSCalendar
        }
        
        let cmp1 = calendar.components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: date)
        let cmp2 = calendar.components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: Date())
        
        //格式化日期
        let formatter = DateFormatter()
        if cmp1.day == cmp2.day { // 今天
            formatter.dateFormat = "今天 HH:mm"
        } else if cmp1.year == cmp2.year { // 今年
            formatter.dateFormat = "MM-dd HH:mm"
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        let time = formatter.string(from: date)
        
        return "最后更新: \(time)"
    }
    
}
