//
//  MHRefreshFooterView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/9.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import SnapKit

class MHRefreshFooterView: UICollectionReusableView {
    
    fileprivate lazy var loadMoreBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("点击加载更多", for: .normal)
        btn.setTitleColor(C.mainTextColor, for: .normal)
        btn.addTarget(self, action: #selector(loadmore), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "正在加载更多数据..."
        label.textColor = C.mainTextColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.isHidden = true
        return label
    }()
    
    var loadMoreData: moreBtnClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loadMoreBtn)
        addSubview(indicatorView)
        addSubview(tipLabel)
        
        loadMoreBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        indicatorView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(tipLabel.snp.left).offset(-10)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MHRefreshFooterView {
    
    @objc fileprivate func loadmore() {
        beginRefresh()
    }
    
    func beginRefresh() {
        changeState(isend: false)
        if loadMoreData != nil {
            loadMoreData!()
        }
    }
    
    func endRefresh() {
        changeState(isend: true)
    }
    
    
    func allDataLoad() {
        changeState(isend: true)
        loadMoreBtn.setTitle("已经全部加载完毕", for: .normal)
        loadMoreBtn.isUserInteractionEnabled = false
    }
    
    private func changeState(isend: Bool) {
        loadMoreBtn.isHidden = !isend
        loadMoreBtn.isUserInteractionEnabled = isend
        tipLabel.isHidden = isend
        indicatorView.isHidden = isend
        isend == true ? indicatorView.stopAnimating() : indicatorView.startAnimating()
    }
}
