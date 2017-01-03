
//
//  MHNavTitleView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/16.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

let kButtonWidth: CGFloat = 50

@objc protocol MHNavTitleViewDelegate: class {
    
    /// 点击某个label
    @objc optional func navTitleView(_ navTitleView: MHNavTitleView, didSelectedIndex index: Int)
    
    /// 点击下拉按钮
    @objc optional func navTitleView(_ navTitleView: MHNavTitleView, didSelectItemCell indexPath: IndexPath)
}


class MHNavTitleView: UIView {
    
    /// 标题组
    private var titles: [String]
    
    /// labels
    fileprivate var titleLabels: [UILabel]
    
    /// 记录当前位置
    fileprivate var currentIndex: Int = 0
    
    /// 缓存label宽度
    fileprivate lazy var titleLabelWidth: [CGFloat] = []
    
    /// 代理
    weak open var delegate: MHNavTitleViewDelegate?
    
    /// 设置当前滑动的位置
    var currentPage: Int? {
        didSet {
            if currentPage! == 0 || currentPage! > titles.count {return}
            scrollToIndex(currentPage!)
        }
    }
    
    /// 下拉框数据源
    var dataArray: [LiveAnchorTitleModel]? {
        didSet {
            if dataArray == nil {return}
            collectionView.reloadData()
        }
    }
    
    
    /// 当前选中哪个Cell
    var selectedItem: IndexPath = IndexPath(row: 0, section: 0)
    
    /// 下拉按钮
    fileprivate lazy var dowmBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "three_column_view_open"), for: .normal)
        button.setImage(UIImage(named: "column_up_icon"), for: .selected)
        button.addTarget(self, action: #selector(downButtonDidClick(_:)), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: -1, height: -1)
        button.layer.shadowOpacity = 1
        return button
    }()
    
    /// ScrollView
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    /// 筛选栏目
    fileprivate lazy var chooseLabel: UILabel = {
        let label = UILabel()
        label.text = "   筛选栏目"
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    /// 下拉框底部遮罩
    fileprivate lazy var bottomView: UIView = {
        let blureffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blureffect)
        effectView.alpha = 0.3
        return effectView
    }()
    
    /// 弹出视图
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = HmhDevice.screenW / 3
        let height = width
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RecomGameViewCell.self, forCellWithReuseIdentifier: CellID.RecommentGameCellID)
        collectionView.backgroundColor = C.column_normalColor
        collectionView.delegate = self
        collectionView.bounces = true
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    /// 构造方法
    init(frame: CGRect, titles: [String]) {
        
        self.titles = titles
        self.titleLabels = [UILabel]()
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        addSubview(scrollView)
        addSubview(dowmBtn)
        addSubview(chooseLabel)
        addSubview(collectionView)
        let width = self.width - kButtonWidth
        let height = self.height
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        dowmBtn.frame = CGRect(x: width, y: 0, width:kButtonWidth, height: height)
        chooseLabel.frame = scrollView.frame
        collectionView.frame = CGRect(x: 0, y: chooseLabel.frame.maxY, width: self.width, height: 0)
        
        dowmBtn.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: height)).cgPath
        
        // 初始化Label
        setupTitleLabels()
        
        // 添加底部线段
        setupBottomLine()
        
        // collectionView底部遮罩
        setupBootomView()
        
        scrollView.contentSize = CGSize(width: titleLabels.last!.right + S.scrollLineMargin, height: 0)
    }
    
    private func setupTitleLabels() {
        
        let titleY: CGFloat = S.scrollLineMargin
        let titleH: CGFloat = bounds.height - S.titleMargin
        
        for (index, title) in titles.enumerated() {
            // 创建Label
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = index == 0 ? C.mainColor : C.mainTextColor
            label.layer.borderWidth = 1
            label.layer.borderColor = index == 0 ? C.mainColor.cgColor : C.mainTextColor.cgColor
            label.layer.cornerRadius = 12
            label.layer.masksToBounds = true
            titleLabels.append(label)
            
            // 设置frame
            var titleW: CGFloat = 0
            var titleX: CGFloat = 0
            
            let size = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
            
            titleW = size.width + S.titleMargin
            titleX = index == 0 ? S.scrollLineMargin : titleLabels[index - 1].right + S.titleMargin
            
            // 缓存高度
            titleLabelWidth.append(size.width)
            
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            // 添加Label
            scrollView.addSubview(label)
            
            // 监听Label的点击
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
        
    }
    
    private func setupBottomLine () {
        // 添加底部Line
        let bottomLine = UIView()
        bottomLine.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
        bottomLine.backgroundColor = .lightGray
        addSubview(bottomLine)
    }
    
    private func setupBootomView() {
        
        bottomView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeView(_:)))
        bottomView.addGestureRecognizer(tap)
        UIApplication.shared.keyWindow?.addSubview(bottomView)
    }
    
    @objc func closeView(_ tap: UITapGestureRecognizer) {
        isHiddenDownView(false)
    }
    
    
    /// 更新标题数组
    public func uploadTitle(_ titles: [String]) {
        self.titles = titles
        
        /// 清空视图上的UI
        scrollView.removeFromSuperview()
        for label in titleLabels {
            label.removeFromSuperview()
        }
        bottomView.removeFromSuperview()
        dowmBtn.removeFromSuperview()
        collectionView.removeFromSuperview()
        chooseLabel.removeFromSuperview()
        dataArray?.removeAll()
        titleLabels.removeAll()
        titleLabelWidth.removeAll()
        
        setupUI()
        scrollView.setContentOffset(.zero, animated: false)
        currentIndex = 0
        currentPage = 0
    }
}


extension MHNavTitleView {
    
    @objc fileprivate func downButtonDidClick(_ sender: UIButton) {
        
        let isSelected = sender.isSelected
        sender.isSelected = !isSelected
        
        // 显示下拉视图
        isHiddenDownView(sender.isSelected)
    }
    
    
    fileprivate func isHiddenDownView(_ ishidden: Bool) {
        
        if !ishidden { // 隐藏
            UIView.animate(withDuration: 0.1, animations: { [unowned self] in
                self.bottomView.height = 0
                }, completion: { (bool) in
                    guard bool == true else {return}

                    UIView.animate(withDuration: 0.1, animations: { [unowned self] in
                            self.collectionView.height = 0
                        }, completion: { (bool) in
                            guard bool == true else {return}
                            self.chooseLabel.isHidden = true
                            self.dowmBtn.isSelected = false
                    })
            })
            
        }else { //显示
            UIView.animate(withDuration: 0.1, animations: { [unowned self] in
                self.chooseLabel.isHidden = false
                self.bottomView.isHidden = true
                }, completion: { (bool) in
                    guard bool == true else {return}
                    
                    UIView.animate(withDuration: 0.1, animations: { [unowned self] in
                        self.collectionView.height = HmhDevice.screenH * 0.7
                        self.bottomView.top = self.collectionView.frame.maxY + HmhDevice.navigationBarH
                        self.bottomView.height = HmhDevice.screenH - self.collectionView.frame.maxY - HmhDevice.navigationBarH
                        }, completion: { (bool) in
                            guard bool == true else {return}
                            
                            self.bottomView.isHidden = false
                            self.dowmBtn.isSelected = true
                    })
            })
        }
    }
    
    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 获取点击的下标
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        if currentLabel.tag == currentIndex { return }
        let index = currentLabel.tag
        
        scrollToIndex(index)
        
        delegate?.navTitleView!(self, didSelectedIndex: index)
    }
    
    
    fileprivate func scrollToIndex(_ index: Int) {
        // 获取最新的label和之前的label
        // 设置
        let newLabel = titleLabels[index]
        let oldLabel = titleLabels[currentIndex]
        
        newLabel.textColor = C.mainColor
        newLabel.layer.borderColor = C.mainColor.cgColor
        oldLabel.textColor = C.mainTextColor
        oldLabel.layer.borderColor = C.mainTextColor.cgColor
        let offsetX = newLabel.left - kButtonWidth
        
        // 将点击的label往前移
        if index == 0 {
            scrollView.setContentOffset(.zero, animated: true)
        }else if offsetX + HmhDevice.screenW - kButtonWidth > scrollView.contentSize.width {
            
            var lastX = titleLabels.last!.right + S.scrollLineMargin - scrollView.width
            if lastX < 0 { lastX = 0 }
            scrollView.setContentOffset(CGPoint(x: lastX, y: 0), animated: true)
            
        }else {
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
        
        // 记录当前位置
        currentIndex = index
        
        // 设置下拉框选中item
        selectedItem(IndexPath(row: index, section: 0))
        collectionView.reloadData()
    }
    
    
    /// 选中了某个cell
    fileprivate func selectedItem(_ newIndex: IndexPath) {
        let oldCell = collectionView.cellForItem(at: selectedItem) as? RecomGameViewCell
        let newCell = collectionView.cellForItem(at: newIndex) as? RecomGameViewCell
        oldCell?.contentView.backgroundColor = C.column_normalColor
        newCell?.contentView.backgroundColor = C.column_selectedColor
        oldCell?.isSelectedView = true
        newCell?.isSelectedView = false
        selectedItem = newIndex
    }
}


// MARK: - UICollectionViewDataSource
extension MHNavTitleView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray?.count == 0 ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray?.count ?? 0) + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentGameCellID, for: indexPath) as! RecomGameViewCell
        
        if indexPath.item == 0 {
            cell.title = "全部"
            cell.iconImage.image = UIImage(named: "column_all_live")
        }else {
            cell.title = dataArray?[indexPath.item - 1].tag_name
            cell.imageURL = dataArray?[indexPath.item - 1].icon_url
        }
        
        cell.contentView.backgroundColor = indexPath == selectedItem ? C.column_selectedColor : C.column_normalColor
        cell.isSelectedView = indexPath == selectedItem ? false : true
        
        // 是否显示添加分割线
        cell.isHiddenCutLine = false
        
        return cell
    }
    
    
    @objc(collectionView:willDisplayCell:forItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentGameCellID, for: indexPath) as! RecomGameViewCell
        if indexPath.item == 0 {
            cell.title = "全部"
            cell.iconImage.image = UIImage(named: "column_all_live")
        }
        
        cell.contentView.backgroundColor = indexPath == selectedItem ? C.column_selectedColor : C.column_normalColor
        cell.isSelectedView = indexPath == selectedItem ? false : true
    }

}


// MARK: - UICollectionViewDelegateFlowLayout
extension MHNavTitleView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath != selectedItem {
            selectedItem(indexPath)
            
            scrollToIndex(indexPath.item)
            delegate?.navTitleView!(self, didSelectItemCell: indexPath)
        }
        
        isHiddenDownView(false)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        return super.hitTest(point, with: event)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard !collectionView.frame.contains(point), !bottomView.frame.contains(point) else { return true }
        return super.point(inside: point, with: event)
    }
    
}
