//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/22.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate: class {
    
    func pageTitleView(_ pageTitleView: PageTitleView, didSelectedIndex index: Int)
}

class PageTitleView: UIView {
    
    /// 嫩否滚动
    private var isScrollEnable: Bool
    
    /// 标题组
    private var titles: [String]
    
    /// 记录当前位置
    private var currentIndex: Int = 0
    
    /// labels
    private var titleLabels: [UILabel]
    
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
        lineView.backgroundColor = C.mainColor
        
        return lineView
    }()
    
    weak open var delegate: PageTitleViewDelegate?
    
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
            label.textColor = S.normalTextColor
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
                    titleX = titleLabels[index].right + S.titleMargin
                }
            }
            
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
        
        // 添加底部Line
        let bottomLine = UIView()
        bottomLine.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
        bottomLine.backgroundColor = .lightGray
        addSubview(bottomLine)

        // 设置滑动的View
        addSubview(scrollLine)
        guard let firstLabeld = titleLabels.first else {
            return
        }
        let x = firstLabeld.left + S.scrollLineMargin
        let y = bounds.height - S.scrollLineH
        let w = firstLabeld.width - S.scrollLineMargin * 2
        let h = S.scrollLineH
        scrollLine.frame = CGRect(x: x, y: y, width: w, height: h)
        
        firstLabeld.textColor = S.selectTextColor
    }
    
    
    
    @objc private func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        
        // 获取点击的下标
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        if currentLabel.tag == currentIndex { return }
        
        let index = currentLabel.tag
        
        scrollToIndex(index)
        
        delegate?.pageTitleView(self, didSelectedIndex: index)
    }
    
    
    private func scrollToIndex(_ index: Int) {
        // 获取最新的label和之前的label
        // 设置
        let newLabel = titleLabels[index]
        let oldLabel = titleLabels[currentIndex]
        
        newLabel.textColor = S.selectTextColor
        oldLabel.textColor = S.normalTextColor
        
        let scrollEndX = (scrollLine.width + 2 * S.scrollLineMargin) * CGFloat(index) + S.scrollLineMargin
        UIView.animate(withDuration: 0.25) {
            self.scrollLine.left = scrollEndX
        }
        
        // 记录当前位置
        currentIndex = index
    }
    
    
    
    /// 设置label变化
    public func setCurrentTitle(sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        
         let kNormalRGB: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
         let kSelectRGB: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)
         let kDeltaRGB = (kSelectRGB.0 - kNormalRGB.0, kSelectRGB.1 - kNormalRGB.1, kSelectRGB.2 - kNormalRGB.2)
         
        
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveMargin = targetLabel.left - sourceLabel.left
        scrollLine.left = sourceLabel.left + moveMargin * progress + S.scrollLineMargin
        
        sourceLabel.textColor = UIColor(red: (kSelectRGB.0 - kDeltaRGB.0 * progress) / 255.0, green: (kSelectRGB.1 - kDeltaRGB.1 * progress) / 255.0, blue: (kSelectRGB.2 - kDeltaRGB.2 * progress) / 255.0, alpha: 1.0)    //normal
        targetLabel.textColor = UIColor(red: (kNormalRGB.0 + kDeltaRGB.0 * progress)/255.0, green: (kNormalRGB.1 + kDeltaRGB.1 * progress)/255.0, blue: (kNormalRGB.2 + kDeltaRGB.2 * progress)/255.0, alpha: 1.0)      //select
        
        currentIndex = targetIndex
    }

}






