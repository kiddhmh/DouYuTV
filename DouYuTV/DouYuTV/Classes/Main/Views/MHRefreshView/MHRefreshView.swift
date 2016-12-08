//
//  MHRefreshView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/2.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class MHRefreshView: UIView {
    
    //父视图高度
    var parentViewHeight: CGFloat = 0

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
                normalHidden(false)
                normalImageView.image = UIImage(named: "dyla_img_mj_stateIdle")
                stateLabel.text = "下拉可以刷新"
                
            case .pulling:
                normalHidden(false)
                normalImageView.image = UIImage(named: "dyla_img_mj_statePulling")
                stateLabel.text = "松开立即刷新"
                
            case .willRefresh:
                normalHidden(true)
            }
        }
    }
    

    fileprivate lazy var normalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "dyla_img_mj_stateIdle")
        return imageView
    }()
    
    fileprivate lazy var refreshImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        var images = [UIImage]()
        for i in 1...4 {
            let image = UIImage(named: "img_mj_stateRefreshing_0\(i)")
            images.append(image!)
        }
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = LONG_MAX
        imageView.isHidden = true
        return imageView
    }()
    
    fileprivate lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = C.mainTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "下拉可以刷新"
        return label
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = C.mainTextColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        setupUI()
        self.refreshStatus = .normal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func normalHidden(_ isHidden: Bool) {
        normalImageView.isHidden = isHidden
        timeLabel.isHidden = isHidden
        stateLabel.isHidden = isHidden
        refreshImageView.isHidden = !isHidden
        isHidden ? refreshImageView.startAnimating() : refreshImageView.stopAnimating()
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


extension MHRefreshView {
    
    fileprivate func setupUI() {
        
        addSubview(normalImageView)
        addSubview(refreshImageView)
        addSubview(stateLabel)
        addSubview(timeLabel)
        
        normalImageView.snp.makeConstraints { (make) in
            make.width.equalTo(65)
            make.height.equalTo(66)
            make.bottom.equalTo(self.snp.bottom)
            make.centerX.equalTo(self.snp.centerX).offset(-30)
        }
        
        refreshImageView.snp.makeConstraints { (make) in
            make.width.equalTo(135)
            make.height.equalTo(65)
            make.bottom.equalTo(normalImageView.snp.bottom)
            make.left.equalTo(normalImageView.snp.left)
        }
        
        stateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(normalImageView.snp.right)
            make.bottom.equalTo(normalImageView.snp.centerY)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(normalImageView.snp.centerY)
            make.left.equalTo(normalImageView.snp.right)
        }
        
    }
    
}
