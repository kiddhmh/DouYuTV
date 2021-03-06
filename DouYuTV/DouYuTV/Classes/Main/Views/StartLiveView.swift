//
//  StartLiveView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/3.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit

private let margin: CGFloat = 16

enum LiveType {
    case live
    case video
}

protocol StartLiveViewDelegate: class {
    
    func startLiveDidClick(_ liveView: StartLiveView, _ type: LiveType)
}

class StartLiveView: UIView {
    
    // MARK: - public
    weak open var delegate: StartLiveViewDelegate?
    
    open var dragEnable: Bool = true    // 是否可以拖拽
    
    // MARK: - private
    fileprivate var isOpen: Bool = false    // 是否打开菜单
    
    fileprivate var startPoint: CGPoint = CGPoint(x: 0, y: 0)        // 启始位置
    
    fileprivate lazy var startLiveBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_livevideo_start_home"), for: .normal)
        btn.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        return btn
    }()
    
    // 直播
    fileprivate lazy var liveBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_live_home"), for: .normal)
        btn.addTarget(self, action: #selector(menuLiveClick), for: .touchUpInside)
        btn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        return btn
    }()
    
    // 录制
    fileprivate lazy var videoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_video_home"), for: .normal)
        btn.addTarget(self, action: #selector(menuVideoClick), for: .touchUpInside)
        btn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
        
        addSubview(liveBtn)
        liveBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.top.left.equalTo(self)
        }
        
        addSubview(videoBtn)
        videoBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.top.left.equalTo(self)
        }
        
        addSubview(startLiveBtn)
        startLiveBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
        // 添加手势，可以拖拽
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:)))
        panGes.minimumNumberOfTouches = 1
        panGes.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension StartLiveView {
    
    public static let liveView: StartLiveView = StartLiveView()
    
//    public var liveView: StartLiveView<self> {
//        get { return StartLiveView(self) }
//    }
}

// MARK: - UIButtonAction
extension StartLiveView {
    
    // startLiveBtn.ImageView.alpha
    private func hiddenImageView() {
        
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.startLiveBtn.imageView?.alpha = self.isOpen ? 0 : 1
        }
    }
    
    // startLiveBtn.ImageView.alpha && startLiveBtn.transform
    private func showImageView() {
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            
            if self.isOpen { self.startLiveBtn.imageView?.alpha = 1 }
            // 旋转45度
            let angle = self.isOpen ? CGFloat(M_PI_4) : 0
            self.startLiveBtn.transform = CGAffineTransform(rotationAngle: angle)
            
        }) { [unowned self] (bool) in
            if !self.isOpen {
                self.startLiveBtn.setImage(UIImage(named: "btn_livevideo_start_home"), for: .normal)
                
            }
        }
    }
    
    // 弹出菜单
    @objc fileprivate func openMenu() {
        
        isOpen = !isOpen
        
        if isOpen { // 弹出
            
            hiddenImageView()
            startLiveBtn.setImage(UIImage(named: "btn_livevideo_close_home"), for: .normal)
            showImageView()
            
        }else {  // 收起
            showImageView()
            hiddenImageView()
        }
        
        
        /// 动画方式
        // 缩放动画
        let fromV = isOpen ? [0.1, 0.1] : [1.0, 1.0]
        let toV   = isOpen ? [1.0, 1.0] : [0.1, 0.1]
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = fromV
        scaleAnimation.toValue = toV
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.duration = 0.5
        
        /* center：圆心的坐标
           radius：半径
           startAngle：起始的弧度
           endAngle：圆弧结束的弧度
           clockwise：YES为顺时针，No为逆时针
        */
        // 圆心
        let vCenter = CGPoint(x: startLiveBtn.centerX, y: startLiveBtn.top - 0.5 * margin)
        let lCenter = CGPoint(x: startLiveBtn.left - 0.5 * margin, y: startLiveBtn.centerY)
        
        // 起始角度
        let vStartAngle = isOpen ? CGFloat(M_PI_2) : CGFloat(M_PI * 1.5)
        let lStartAngle = isOpen ? 0 : CGFloat(M_PI)
        
        // 结束角度
        let vEndAngle = isOpen ? CGFloat(M_PI * 1.5) : CGFloat(M_PI_2)
        let lEndAnlge = isOpen ? CGFloat(M_PI) : 0
        
        let clockwise = isOpen
        
        let videoPath = UIBezierPath(arcCenter: vCenter, radius: (startLiveBtn.height + margin) / 2, startAngle: vStartAngle, endAngle: vEndAngle, clockwise: clockwise)
        let livePath  = UIBezierPath(arcCenter: lCenter, radius: (startLiveBtn.height + margin) / 2, startAngle: lStartAngle, endAngle: lEndAnlge, clockwise: clockwise)
        
        // 沿圆弧运动
        let vStartValue = [startLiveBtn.centerX, startLiveBtn.centerY]
        let vEndValue   =  [startLiveBtn.centerX, startLiveBtn.centerY - startLiveBtn.height - margin]
        
        let arcVideoAnimation = CAKeyframeAnimation(keyPath: "position")
        arcVideoAnimation.values = isOpen ? [vStartValue, vEndValue] : [vEndValue, vStartValue]
        arcVideoAnimation.keyTimes = [0, 0.5, 1]
        arcVideoAnimation.duration = 0.5
        arcVideoAnimation.isRemovedOnCompletion = false
        arcVideoAnimation.fillMode = kCAFillModeForwards
        arcVideoAnimation.path = videoPath.cgPath
        
        // 沿圆弧运动
        let lStartValue = [startLiveBtn.centerX, startLiveBtn.centerY]
        let lEndValue   = [startLiveBtn.centerX - startLiveBtn.width - margin, startLiveBtn.centerY]
        
        let arcLiveAnimation = CAKeyframeAnimation(keyPath: "position")
        arcVideoAnimation.values = isOpen ? [lStartValue, lEndValue] : [lEndValue, lStartValue]
        arcLiveAnimation.keyTimes = [0, 0.5, 1]
        arcLiveAnimation.duration = 0.5
        arcLiveAnimation.isRemovedOnCompletion = false
        arcLiveAnimation.fillMode = kCAFillModeForwards
        arcLiveAnimation.path = livePath.cgPath
        
        // 动画组
        let videGroupAnimation = CAAnimationGroup()
        videGroupAnimation.duration = 0.5
        videGroupAnimation.isRemovedOnCompletion = false
        videGroupAnimation.fillMode = kCAFillModeForwards
        videGroupAnimation.animations = [scaleAnimation, arcVideoAnimation]
        
        // 动画组
        let liveGroupAnimation = CAAnimationGroup()
        liveGroupAnimation.duration = 0.5
        liveGroupAnimation.isRemovedOnCompletion = false
        liveGroupAnimation.fillMode = kCAFillModeForwards
        liveGroupAnimation.animations = [scaleAnimation, arcLiveAnimation]
        liveGroupAnimation.delegate = self
        
        videoBtn.layer.add(videGroupAnimation, forKey: "videoAnimation")
        liveBtn.layer.add(liveGroupAnimation, forKey: "liveAnimation")
    }
    
    
    // 点击直播
    @objc fileprivate func menuLiveClick() {
        
        openMenu()
        guard let delegate = delegate else { return }
        delegate.startLiveDidClick(self, .live)
    }
    
    // 点击录制
    @objc fileprivate func menuVideoClick() {
        
        openMenu()
        guard let delegate = delegate else { return }
        delegate.startLiveDidClick(self, .video)
    }
    
}


// MARK: - UIPanGestureRecognizerAction
extension StartLiveView {
    
    @objc fileprivate func dragAction(_ pan: UIPanGestureRecognizer) {
        // 判断是否可以拖拽
        guard dragEnable else { return }
        
        switch pan.state {
        case .began:
            guard !isOpen else {
                openMenu()
                return
            }
            //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加
            pan.setTranslation(CGPoint(x: 0, y: 0), in: self)
            startPoint = pan.translation(in: self)
        case .changed:
            let point = pan.translation(in: self)
            let dx = point.x - startPoint.x
            let dy = point.y - startPoint.y
            
            //计算移动后的view中心点
            var newCenter = CGPoint(x: self.centerX + dx, y: self.centerY + dy)
            /* 限制用户不可将视图托出给定的范围 */
            let halfw = self.width / 2
            
            // x坐标左边界
            newCenter.x = max(halfw, newCenter.x)
            // x坐标右边界
            newCenter.x = min(HmhDevice.screenW - halfw, newCenter.x)
            
            self.center = newCenter
            pan.setTranslation(CGPoint(x: 0, y: 0), in: self)
            
        case .ended:
            keepBounds()
        default:
            break
        }
    }
    
    
    // 自动贴边
    private func keepBounds() {
        
        // 中心点
        let centerX = (HmhDevice.screenW - self.width) / 2
        let centerY = (HmhDevice.screenH - HmhDevice.tabBarH - HmhDevice.navigationBarH - self.width) / 2
        var leftX   = self.left
        var topY    = self.top
        
        if leftX < centerX { // 左边
            leftX = 15
        }else { // 右边
            leftX = HmhDevice.screenW - self.width - 15
        }
        
        if topY < centerY { // 上边
            topY = 15
        }else { // 下边
            topY = HmhDevice.screenH - HmhDevice.tabBarH - HmhDevice.navigationBarH - self.width - 60
        }
        
       UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveLinear, animations: {
        
        self.left = leftX
        self.top  = topY
        self.startLiveBtn.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
       }, completion: nil)
    }
}


extension StartLiveView: CAAnimationDelegate {
    
    // 动画结束后，更改buttonframe
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard isOpen, anim.isKind(of: CAAnimationGroup.self) else { return }
        
        // 更新约束
        videoBtn.snp.updateConstraints({ (make) in
            make.top.equalTo(self).offset(-(margin + startLiveBtn.height))
        })
        videoBtn.transform = CGAffineTransform.identity
        videoBtn.layer.removeAllAnimations()
        
        liveBtn.snp.updateConstraints({ (make) in
            make.left.equalTo(self).offset(-(margin + startLiveBtn.width))
        })
        
        liveBtn.transform = CGAffineTransform.identity
        liveBtn.layer.removeAllAnimations()
    }
    
}


extension StartLiveView {
    
    // 由于Button-frame超出父视图，更改响应链
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        guard !liveBtn.frame.contains(point) else {
            return true
        }
        guard !videoBtn.frame.contains(point) else {
            return true
        }
        
        return super.point(inside: point, with: event)
    }
    
}


// MARK: - 默认协议的实现，弹出录制页面
extension StartLiveViewDelegate where Self: UIViewController {
    
    func startLiveDidClick(_ liveView: StartLiveView, _ type: LiveType) {
        
        switch type {
        case .live:
            print("点击直播")
        case .video:
            print("点击录制")
            // 进入录制页面
            let videoVC = HmhTools.createViewController("StartVideoController", identifier: "StartVideoController") as! StartVideoController
            UIApplication.shared.keyWindow?.rootViewController!.present(videoVC, animated: true, completion: nil)
        }
    }
}
