//
//  MHRefreshControl.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/2.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

/// 刷新的三种状态
///
/// - Normal:      普通状态(未达到临界点)
/// - Pulling:     超过临界点，放手刷新
/// - WillRefresh: 超过临界点，正在刷新
enum MHRefreshState {
    case normal
    case pulling
    case willRefresh
}

/// 临界值
private let MHRefreshOffset: CGFloat = 66

class MHRefreshControl: UIControl {
    
    // 父视图
    fileprivate weak var scrollView: UIScrollView?
    fileprivate lazy var refreshView: MHRefreshView = MHRefreshView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        addSubview(refreshView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshView.frame = self.bounds
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let sv = newSuperview as? UIScrollView else {return}
        // 记录父视图
        scrollView = sv
        // 监听属性
        sv.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
}


extension MHRefreshControl {
    
    /// 监听属性改变调用
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {return}
        
        // 初始高度
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        if height < 0 {
            return
        }
        
        //传递高度  如果是在正在刷新状态，就不传递高度 改变大小
        if refreshView.refreshStatus != .willRefresh {
            refreshView.parentViewHeight = height
        }
        
        //根据高度设置刷新控件的frame
        let isTop = sv.contentInset.top == MHRefreshOffset
        let y = isTop ? height : (height + sv.contentInset.top)
        self.frame = CGRect(x: 0, y: -y, width: sv.bounds.width, height: height)
        
        //坑~~~ 由于推荐页面本身存在contentInset，所以需要另外调整self.frame,否则刷新时的动画无法显示
        if refreshView.refreshStatus == .willRefresh && sv.contentInset.top != MHRefreshOffset {
            self.top += MHRefreshOffset
        }
        
        print(self.refreshView.frame)
        
        if sv.isDragging {
            if height > MHRefreshOffset && refreshView.refreshStatus == .normal {
                print("放手刷新")
                refreshView.refreshStatus = .pulling
            }else if height <= MHRefreshOffset && refreshView.refreshStatus == .pulling {
                print("继续拉")
                refreshView.refreshStatus = .normal
            }
        }else {
            //放手 不在拖拽状态 判断是否超过临界点
            if refreshView.refreshStatus == .pulling {
                print("刷新中。。。")
                beginRefresh()
                // 发送刷新事件
                sendActions(for: .valueChanged)
            }
        }
    }
}
//(0.0, 0.0, 375.0, -0.0)




extension MHRefreshControl {
    
    // 开始刷新
    func beginRefresh() {
        print("开始刷新")
        // 判断父视图
        guard let sv = scrollView else {return}
        
        if refreshView.refreshStatus == .willRefresh {return}
        refreshView.refreshStatus = .willRefresh
        
        var insert = sv.contentInset
        insert.top += MHRefreshOffset
        sv.contentInset = insert
        
        refreshView.parentViewHeight = MHRefreshOffset
    }
    
    
    //结束刷新
    func endRefreshing(){
        print("结束刷新")
        guard let sv = scrollView else {
            return
        }
        
        //判断状态 是否正在刷新，如果不是，直接返回
        if refreshView.refreshStatus != .willRefresh {return}
        
        //恢复刷新视图的状态
        refreshView.refreshStatus = .normal
        //恢复表格的 contentInset
        var inset = sv.contentInset
        inset.top -= MHRefreshOffset
        sv.contentInset = inset
    }
}

