//
//  LivePageTitleView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/7.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let normalColor = UIColor(r: 230, g: 230, b: 230, a: 1)

protocol LivePageTitleViewDelegate: class {
    
    func pageTitleView(_ pageTitleView: LivePageTitleView, didSelectedIndex index: Int)
}

class LivePageTitleView: UIView {
    
    /// 嫩否滚动
    private var isScrollEnable: Bool
    
    /// 标题组
    private var titles: [String]
    
    /// 记录当前位置
    private var currentIndex: Int = 0
    
    /// labels
    private var titleLabels: [UILabel]
    
    /// 设置当前滑动的位置
    var currentPage: Int? {
        didSet {
            if currentPage! == 0 || currentPage! > titles.count {return}
            scrollToIndex(currentPage!,false)
        }
    }
    
    /// ScrollView
    private lazy var scrollView: UIScrollView = { [unowned self] in
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
        }()
    
    /// 下标线
    private lazy var scrollLine: UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = .white
        
        return lineView
    }()
    
    /// 记录字体数组的宽度
    private lazy var titleLabelWidth: [CGFloat] = []
    
    weak open var delegate: LivePageTitleViewDelegate?
    
    // MARK: - 构造方法
    init(frame: CGRect, isScrollEnable: Bool, titles: [String]) {
        
        self.isScrollEnable = isScrollEnable
        self.titles = titles
        self.titleLabels = [UILabel]()
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func setupUI() {
        // 1.添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2.初始化labels
        setupTitleLabels()
        
        // 3.添加定义的线段和滑动的滑块
        setupBottomLineAndScrollLine()
        
        if isScrollEnable == true {
            scrollView.contentSize = CGSize(width: titleLabels.last!.right + 0.5 * S.titleMargin, height: 0)
        }
    }
    
    
    private func setupTitleLabels() {
        
        let titleY: CGFloat = 0
        let titleH: CGFloat = bounds.height - S.scrollLineH
        let count = titles.count
        
        for (index, title) in titles.enumerated() {
            // 创建Label
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = normalColor
            titleLabels.append(label)
            
            // 设置frame
            var titleW: CGFloat = 0
            var titleX: CGFloat = 0
            
            if !isScrollEnable {
                titleW = bounds.width / CGFloat(count)
                titleX = CGFloat(index) * titleW
            }else {
                
                let size = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
                
                titleW = size.width
                if index != 0 {
                    titleX = titleLabels[index - 1].right + S.titleMargin
                }
                if index == 0 {
                    titleX = 0.5 * S.titleMargin
                }
                
            }
            
            // 缓存宽度
            titleLabelWidth.append(titleW)
            
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            // 添加Label
            scrollView.addSubview(label)
            
            // 监听Label的点击
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
        
    }
    
    
    private func setupBottomLineAndScrollLine() {
        
        // 设置滑动的View
        scrollView.addSubview(scrollLine)
        guard let firstLabeld = titleLabels.first else {
            return
        }
        var x = firstLabeld.left + S.scrollLineMargin
        let y = bounds.height - S.scrollLineH
        var w = firstLabeld.width - S.scrollLineMargin * 2
        let h = S.scrollLineH
        if isScrollEnable == true {
            x = 0
            w = firstLabeld.width + S.scrollLineMargin
        }
        scrollLine.frame = CGRect(x: x, y: y, width: w, height: h)
        
        firstLabeld.textColor = .white
    }
    
    
    @objc private func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        
        // 获取点击的下标
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        if currentLabel.tag == currentIndex { return }
        
        let index = currentLabel.tag
        
        scrollToIndex(index, true)
        
        delegate?.pageTitleView(self, didSelectedIndex: index)
    }
    
    
    private func scrollToIndex(_ index: Int, _ animated: Bool) {
        // 获取最新的label和之前的label
        // 设置
        let newLabel = titleLabels[index]
        let oldLabel = titleLabels[currentIndex]
        
        newLabel.textColor = .white
        oldLabel.textColor = normalColor
        
        var scrollEndX = (scrollLine.width + 2 * S.scrollLineMargin) * CGFloat(index) + S.scrollLineMargin
        if isScrollEnable == true {
            scrollEndX = newLabel.left - 0.5 * S.scrollLineMargin
        }
        if animated == true {
            UIView.animate(withDuration: 0.25) {
                self.scrollLine.left = scrollEndX
                self.scrollLine.width = self.titleLabelWidth[index] + S.scrollLineMargin
            }
        }else {
            self.scrollLine.left = scrollEndX
        }
        
        // 将点击的label移到中心点
        let centerX = newLabel.centerX
        
        if centerX > scrollView.width * 0.5 {
            let offset = centerX - HmhDevice.screenW * 0.5
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }else { // 前端不可以超过
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        
        if (scrollView.contentSize.width - centerX) < scrollView.width * 0.5 {
            // 最后不可以超过
            scrollView.setContentOffset(CGPoint(x: (titleLabels.last?.right)! + 0.5 * S.scrollLineMargin - scrollView.width, y: 0) , animated: true)
        }
        
        // 记录当前位置
        currentIndex = index
    }
    
    
    
    /// 设置label变化
    public func setCurrentTitle(sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        let kNormalRGB: (CGFloat, CGFloat, CGFloat) = (230, 230, 230)
        let kSelectRGB: (CGFloat, CGFloat, CGFloat) = (255, 255, 255)
        let kDeltaRGB = (kSelectRGB.0 - kNormalRGB.0, kSelectRGB.1 - kNormalRGB.1, kSelectRGB.2 - kNormalRGB.2)
        
        guard sourceIndex < titleLabels.count && targetIndex < titleLabels.count else { return }
        
        
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveMargin = targetLabel.left - sourceLabel.left
        let centerMargin = targetLabel.centerX - sourceLabel.centerX
        
        if isScrollEnable == true {
            scrollLine.left = sourceLabel.left + moveMargin * progress - 0.5 * S.titleMargin
            scrollLine.width = sourceLabel.width + S.titleMargin + (targetLabel.width - sourceLabel.width) * progress
            
            // 移动scrollView
            let oldCenterX = sourceLabel.centerX
            let newCenterX = targetLabel.centerX
            
            if newCenterX > scrollView.width * 0.5 {
                let offset = oldCenterX - HmhDevice.screenW * 0.5
                scrollView.setContentOffset(CGPoint(x: offset + centerMargin * progress , y: 0), animated: true)
            }else { // 前端不可以超过
                scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
            
            if (scrollView.contentSize.width - oldCenterX) < scrollView.width * 0.5 {
                // 最后不可以超过
                scrollView.setContentOffset(CGPoint(x: (titleLabels.last?.right)! + 0.5 * S.scrollLineMargin - scrollView.width, y: 0) , animated: true)
            }
            
        }else {
            scrollLine.left = sourceLabel.left + moveMargin * progress
        }
        
        sourceLabel.textColor = UIColor(red: (kSelectRGB.0 - kDeltaRGB.0 * progress) / 255.0, green: (kSelectRGB.1 - kDeltaRGB.1 * progress) / 255.0, blue: (kSelectRGB.2 - kDeltaRGB.2 * progress) / 255.0, alpha: 1.0)    //normal
        targetLabel.textColor = UIColor(red: (kNormalRGB.0 + kDeltaRGB.0 * progress)/255.0, green: (kNormalRGB.1 + kDeltaRGB.1 * progress)/255.0, blue: (kNormalRGB.2 + kDeltaRGB.2 * progress)/255.0, alpha: 1.0)      //select
        
        currentIndex = targetIndex
    }
    
    
    /// 更新标题数组
    public func uploadTitle(_ titles: [String]) {
        self.titles = titles
        
        /// 清空视图上的UI
        scrollView.removeFromSuperview()
        for label in titleLabels {
            label.removeFromSuperview()
        }
        titleLabels.removeAll()
        scrollLine.removeFromSuperview()
        titleLabelWidth.removeAll()
        isScrollEnable = true
        
        setupUI()
        currentIndex = 0
        currentPage = 1
    }
    
}


