//
//  LivePrettyLayerView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/31.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD
import BarrageRenderer

class LivePrettyLayerView: UIView {
    
    // 模型
    var model: AnchorModel? {
        didSet {
            guard let model = model else { return }
            
            iconView.model = model
        }
    }
    
    // 分享链接
    var shareURL: String?
    
    // 头像视图
    fileprivate var iconView: LivePrettyIconView = {
        let iconView: LivePrettyIconView = LivePrettyIconView(frame: CGRect(x: 0, y: 0, width: HmhDevice.screenW / 2, height: 40))
        return iconView
    }()
    
    
    // 底部工具栏
    fileprivate var bottomView: LivePrettyBottomView = {
        let bottomView: LivePrettyBottomView = LivePrettyBottomView()
        return bottomView
    }()
    
    // 粒子动画(点赞)
    fileprivate var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        // 发射器在xy平面的中心位置
        emitterLayer.position = CGPoint(x: HmhDevice.screenW - 40, y: HmhDevice.screenH - 40)
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSize(width: 32, height: 32)
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered
        
        // 开启三维效果
        //    _emitterLayer.preservelsDepth = true
        let imageList: [String] = ["dyla_zan_0", "dyla_zan_1", "dyla_zan_2", "dyla_zan_3"]
        
        // 存放粒子数组
        var array: [CAEmitterCell] = []
        
        // 创建粒子
        for imgName in imageList {
            // 发射单元
            let cell =  CAEmitterCell()
            // 粒子的创建速率，默认为1/s
            cell.birthRate = 1
            // 粒子存活时间
            cell.lifetime = Float(arc4random_uniform(4)) + 1
            // 粒子的生存时间容差
            cell.lifetimeRange = 1.5
            // 颜色
            let image: UIImage = UIImage(named: imgName)!
            // 粒子显示的内容
            cell.contents = image.cgImage
            // 粒子的运动速度
            cell.velocity = CGFloat(arc4random_uniform(100)) + 100
            // 粒子速度的容差
            cell.velocityRange = 80
            // 粒子在xy平面的发射角度
            cell.emissionLongitude = CGFloat(M_PI + M_PI_2)
            // 粒子发射角度的容差
            cell.emissionRange = CGFloat(M_PI_2 / 6)
            // 缩放比例
            cell.scale = 0.5
            
            array.append(cell)
        }
        
        emitterLayer.emitterCells = array
        return emitterLayer
    }()
    
    fileprivate var timer: Timer?
    
    /// 弹幕View
    fileprivate var renderer: BarrageRenderer?
    
    fileprivate var pan: UIPanGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureView(_:)))
        addGestureRecognizer(pan!)
        
        setupUI()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(autoSendBarrage), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        // 添加粒子动画
        layer.addSublayer(emitterLayer)
        
        addSubview(iconView)
        
        addSubview(bottomView)
        bottomView.clickBtnClosure = { [unowned self] (type, btn) in
            
            switch type {
            case .message:
                btn.isSelected = !btn.isSelected
                btn.isSelected == true ? self.renderer?.start() : self.renderer?.stop()
            case .share:
                self.showShareView()
            case .gift:
                MBProgressHUD.showTips("点击了礼物")
            case .praise:
                MBProgressHUD.showTips("点击了点赞")
            }
        }
    
        iconView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(HmhDevice.screenW / 2)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(30)
        }
        
        let color = UIColor(r: 0, g: 0, b: 0, a: 0.5)
        iconView.addCorner(radius: 20, borderWidth: 1, backgroundColor: color, borderColor: color)
        
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(HmhDevice.screenW)
            make.left.bottom.equalTo(self)
        }
        
        renderer = BarrageRenderer()
        renderer?.canvasMargin = UIEdgeInsetsMake(HmhDevice.screenH * 0.2, 15, HmhDevice.screenH * 0.5, 15)
        addSubview((renderer?.view)!)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        renderer?.stop()
        renderer?.view.removeFromSuperview()
        renderer = nil
        timer?.invalidate()
        timer = nil
        self.removeGestureRecognizer(pan!)
    }
}


extension LivePrettyLayerView {
    
    // 弹出分享页面(直接使用UMeng自带界面,懒得写~😝)
    fileprivate func showShareView() {
        
        guard !Platform.isSimulator else { // 模拟器无法测试
            MBProgressHUD.showError("请使用真机测试")
            return
        }
        
        UMSocialUIManager.showShareMenuViewInWindow { [unowned self] (type, userInfo) in
            self.shareTextImageToPlatformType(type)
        }
    }
    
    private func shareTextImageToPlatformType(_ platformType: UMSocialPlatformType) {
        
        let messageObjc = UMSocialMessageObject()
        messageObjc.text = "老司机~快来呀~"
        let webPageObjc = UMShareWebpageObject()
        webPageObjc.webpageUrl = shareURL ?? "http://blog.csdn.net/hmh007/article/details/53837859"
        webPageObjc.title = "快快点击链接，你懂得~"
        webPageObjc.descr = "老司机，带带我，我要上昆明呀~"
        webPageObjc.thumbImage = model?.avatar_small ?? UIImage(named: "萌妹子")
        messageObjc.shareObject = webPageObjc
        
        UMSocialManager.default().share(to: platformType, messageObject: messageObjc, currentViewController: self) { (data, error) in
            
            if error != nil {
                print("************Share fail with error \(error)*********")
                MBProgressHUD.showError("分享失败")
            }else{
                let response = data as? UMSocialShareResponse
                MBProgressHUD.showSuccess(response?.message ?? "分享成功")
            }
        }
    }
    
    
    // 发送弹幕
    @objc fileprivate func autoSendBarrage() {
        
        let spriteNumber = renderer?.spritesNumber(withName: nil) ?? 0
        guard spriteNumber <= 30 else { return } // 限制屏幕上的弹幕量
        
        renderer?.receive(walkTextSpriteDescriptorWithDirection(.R2L))
    }
    
    // 创建弹幕
    private func walkTextSpriteDescriptorWithDirection(_ direction: BarrageWalkDirection) -> BarrageDescriptor {
        
        let descriptor = BarrageDescriptor()
        descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self)
        let random = arc4random_uniform(UInt32(danMuText().count))
        descriptor.params["text"] = danMuText()[Int(random)]
        descriptor.params["textColor"] = UIColor.randomColor
        descriptor.params["speed"] = 100 * Int(random) / Int(RAND_MAX) + 60
        descriptor.params["direction"] = direction.rawValue
        descriptor.params["clickAction"] = {
            
            let alertView = UIAlertView.init(title: "提示", message: "弹幕被点击", delegate: nil, cancelButtonTitle: "取消")
            alertView.show()
        }
        
        return descriptor
    }
    
    private func danMuText() -> [String] {
        let url = Bundle.main.path(forResource: "danmu.plist", ofType: nil)
        return NSArray(contentsOfFile: url ?? "") as! [String]
    }
}

// MARK: - 手势事件
extension LivePrettyLayerView {
    
    @objc fileprivate func panGestureView(_ pan: UIPanGestureRecognizer) {
        
        let point = pan.translation(in: self)
        switch pan.state {
        case .changed:
            guard point.x > 0 else { return }
            self.left = point.x
        case .ended:
            if point.x < HmhDevice.screenW / 4 {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.left = 0
                })
            }else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.left = HmhDevice.screenW
                })
            }
            
        default:
            break
        }
    }
    
}
