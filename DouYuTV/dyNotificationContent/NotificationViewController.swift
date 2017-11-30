//
//  NotificationViewController.swift
//  dyNotificationContent
//
//  Created by 胡明昊 on 17/1/18.
//  Copyright © 2017年 CMCC. All rights reserved.
// Tips: NotificationContent中的不允许滑动手势的交互

import UIKit
import UserNotifications
import UserNotificationsUI
import ImageIO
import AVFoundation

// 用于判断数据类型
private let pngHeader: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
private let jpgHeaderSOI: [UInt8] = [0xFF, 0xD8]
private let jpgHeaderIF: [UInt8] = [0xFF]
private let gifHeader: [UInt8] = [0x47, 0x49, 0x46]

private let topMargin: CGFloat = 8.5
private let needleAngle = Double.pi / 2 / 3

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 副标题
    @IBOutlet weak var subTitleLabel: UILabel!
    
    /// 内容
    @IBOutlet weak var body: UILabel!
    
    /// 附件图片
    @IBOutlet weak var imageView: UIImageView!
    
    /// 附件图片高度
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    /// 附件多媒体视图
    @IBOutlet weak var mediaView: UIView!
    
    /// 附件多媒体视图高度
    @IBOutlet weak var mediaViewHeight: NSLayoutConstraint!
    
    /// 多媒体加载进度
    @IBOutlet weak var mediaProgress: UIProgressView!
    
    // 总时间
    @IBOutlet weak var totalLabel: UILabel!
    
    // 当前时间
    @IBOutlet weak var currentLabel: UILabel!
    
    // 背景蒙层
    @IBOutlet weak var backgroundEffectView: UIImageView!
    
    @IBOutlet weak var backEffectViewHeight: NSLayoutConstraint!
    
    // 旋转图片
    fileprivate var rotationView: UIImageView?
    
    // 留声机效果图片
    fileprivate var needleView: UIImageView?
    
    /// 多媒体播放相关
    fileprivate var player: AVPlayer?
    
    fileprivate var playerItem: AVPlayerItem?
    
    fileprivate var playerLayer: AVPlayerLayer?
    
    fileprivate var link: CADisplayLink?
    
    fileprivate var isPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if player != nil {
            player = nil
            player?.pause()
        }
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let content = notification.request.content
//        print(content)
        
        let category = content.categoryIdentifier
        if category == "CustomCategory" {
            titleLabel.text = content.title
            subTitleLabel.text = content.subtitle
            body.text = content.body
            
            // 判断是否有附件
            let count = content.attachments.count
            if count == 0 { //没有附件
                imageView.removeFromSuperview()
                preferredContentSize = CGSize.init(width: UIScreen.main.bounds.width, height: body.frame.size.height + body.frame.origin.y)
                return
            }
            
            // 附件URL
            let fileURL = content.attachments[0].url
            
            // 加载沙盒中的附件(Tips:不同的extension之间沙盒路径不一样)
            if fileURL.startAccessingSecurityScopedResource() {
                guard let data = NSData(contentsOf: fileURL) else {
                    return
                }
                let result: ImageFormat = data.mh_imageFormat
                
                // 判断类型
                switch result {
                case .JPEG, .PNG:
                    let img = UIImage(data: data as Data)
                    imageView.image = img
                    imageView.isHidden = false
                    imageHeight.constant = (view.frame.size.width / img!.size.width) * img!.size.height
                    preferredContentSize = CGSize(width: view.frame.size.width, height: imageHeight.constant + body.frame.size.height + body.frame.origin.y + topMargin)
                    
                case .GIF:
                    let gifImage = creatGifImage(data)
                    imageHeight.constant = (view.frame.size.width / gifImage.0.first!.size.width) * gifImage.0.first!.size.height
                    imageView.animationImages = gifImage.0
                    imageView.animationDuration = gifImage.1
                    imageView.animationRepeatCount = 0
                    imageView.isHidden = false
                    imageView.startAnimating()
                    preferredContentSize = CGSize(width: view.frame.size.width, height: imageHeight.constant + body.frame.size.height + body.frame.origin.y + topMargin)
                    
                case .Unknown: // video/audio
                    if fileURL.pathExtension == "mp4" {
                        // init AVPlayer
                        initAVPlayer(fileURL)
                    }else if fileURL.pathExtension == "mp3" {
                        totalLabel.textColor = .white
                        initAVPlayer(fileURL)
                        // 设置背景图
                        creatMP3Background()
                    }
                }
                
                fileURL.stopAccessingSecurityScopedResource()
            }
        }
    }
    
    
    
    var mediaPlayPauseButtonType: UNNotificationContentExtensionMediaPlayPauseButtonType {
        return .default
    }

    var mediaPlayPauseButtonFrame: CGRect {
        let sliderRight: CGFloat = 15
        let sliderTop: CGFloat = 417.5
        let width: CGFloat = 20
        let height = width
        return CGRect(x: sliderRight, y: sliderTop, width: width, height: height)
    }
    
    var mediaPlayPauseButtonTintColor: UIColor {
        return .orange
    }
    
    func mediaPlay() {
        print("开始播放")

        // 先执行留声机动画
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.needleView?.transform = CGAffineTransform.identity
        }) { [unowned self] (bool) in
            
            self.isPlaying = true
            self.player?.play()
            self.extensionContext?.mediaPlayingStarted()
            
            let currentTime = CMTimeGetSeconds(self.player!.currentTime())
            if currentTime == 0 {
                self.addRotationAnimation()
            }else {
                self.rotationView?.layer.resumeAnimate()
            }
        }
    }
    
    func mediaPause() {
        print("暂停播放")
        isPlaying = false
        player?.pause()
        self.extensionContext?.mediaPlayingPaused()
        
        rotationView?.layer.pauseAnimate()
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.needleView?.transform = CGAffineTransform(rotationAngle: -CGFloat(needleAngle))
        })
    }

    
    // 创建gif图片
    private func creatGifImage(_ imageData: NSData) -> ([UIImage], TimeInterval) {
        
        var images = [UIImage]()
        var gifDuration = 0.0
        
        guard let imageSource = CGImageSourceCreateWithData(imageData, nil) else {
            return (images, gifDuration)
        }
        
        // 获取gif帧数
        let frameCount = CGImageSourceGetCount(imageSource)
        
        for i in 0..<frameCount {
            // 获取对应帧的 CGImage
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                return (images, gifDuration)
            }
            if frameCount == 1 {
                // 单帧
                gifDuration = Double.infinity
            } else {
                // gif 动画
                // 获取到 gif每帧时间间隔
                guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil), let gifinfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary, let frameDuration = (gifinfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else {
                    return (images, gifDuration)
                }
                gifDuration += frameDuration.doubleValue
                // 获取帧的img
                let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
                images.append(image)
            }
        }
        return (images, gifDuration)
    }
    
    
    private func initAVPlayer(_ fileURL: URL) {
        creatAVPlayer(withurl: fileURL)
        mediaViewHeight.constant = view.frame.size.width
        preferredContentSize = CGSize(width: view.frame.size.width, height: mediaViewHeight.constant + body.frame.size.height + body.frame.origin.y + topMargin)
        playerLayer?.frame = CGRect(x: 0, y: 0, width: preferredContentSize.width, height: mediaViewHeight.constant)
    }
    
    
    /// 当资源是MP3时设置背景图
    private func creatMP3Background() {
        
        let prefeWidth = preferredContentSize.width
        let prefeHeight = preferredContentSize.height
        let top = body.frame.size.height + body.frame.origin.y + topMargin
        let backHeight = prefeHeight - top
        
        backgroundEffectView.isHidden = false
        let path = Bundle.main.path(forResource: "邓紫棋.jpg", ofType: nil)
        let image = UIImage(contentsOfFile: path!)
        backgroundEffectView.image = image
        backEffectViewHeight.constant = prefeWidth
        
        // 设置毛玻璃
        let blurView = UIToolbar()
        blurView.barStyle = .black
        blurView.frame = CGRect(x: 0, y: 0, width: prefeWidth, height: backHeight)
        backgroundEffectView.addSubview(blurView)
        
        // 设置旋转图片
        let rWidth: CGFloat = 250
        rotationView = UIImageView(image: image)
        backgroundEffectView.insertSubview(rotationView!, aboveSubview: blurView)
        rotationView?.frame = CGRect(x: 0, y: 0, width: rWidth, height: rWidth)
        rotationView?.center = CGPoint(x: prefeWidth * 0.5, y: backHeight * 0.5)
        rotationView?.layer.masksToBounds = true
        rotationView?.layer.cornerRadius = rWidth * 0.5
        rotationView?.layer.borderWidth = 40
        rotationView?.layer.borderColor = UIColor(red: 27/255.0, green: 27/255.0, blue: 27/255.0, alpha: 1).cgColor
        
        // 设置留声机效果图片
        let needlePath = Bundle.main.path(forResource: "play_needle.png", ofType: nil)
        let needleImg = UIImage(contentsOfFile: needlePath!)!
        needleView = UIImageView(image: needleImg)
        needleView?.contentMode = .scaleAspectFill
        backgroundEffectView.insertSubview(needleView!, aboveSubview: rotationView!)
        let needleScale = needleImg.size.width / needleImg.size.height
        let needleHeight = rotationView!.frame.origin.y + 45
        let needleWidth = needleHeight * needleScale
        let needleY = CGFloat(-15)
        let needleX = prefeWidth / 2 - needleWidth / 2
        needleView?.frame = CGRect(x: needleX, y: needleY, width: needleWidth, height: needleHeight)
        needleView?.layer.anchorPoint = CGPoint(x: 0.3, y: 0)
        needleView?.layer.position = CGPoint(x: prefeWidth / 2 , y: -15)
        needleView?.transform = CGAffineTransform(rotationAngle: -CGFloat(needleAngle))
    }
    
    // 添加旋转动画
    private func addRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = 35
        rotationView?.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 初始化播放器
    private func creatAVPlayer(withurl fileURL: URL) {
        
        playerItem = AVPlayerItem(url: fileURL)
        // 监听加载进度
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听播放状态
        playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听视频播放完成
        NotificationCenter.default.addObserver(self, selector: #selector(didEndPlay(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.anchorPoint = CGPoint.zero
        
        // 设置模式
        playerLayer?.videoGravity = AVLayerVideoGravity.resize
//        playerLayer?.contentsScale = 0.5
        
        // 设置静音模式依然下播放音乐
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback)
        
        link = CADisplayLink(target: self, selector: #selector(updateTime))
        link?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        
        guard fileURL.pathExtension == "mp4" else { return }
        mediaView.layer.insertSublayer(playerLayer!, at: 0)
    }
    
    
    @objc fileprivate func updateTime() {
        // 如果暂停
        guard isPlaying == true else { return }

        let currentTime = CMTimeGetSeconds(player!.currentTime())
        let totalTime   = TimeInterval(playerItem!.duration.value) / TimeInterval(playerItem!.duration.timescale)
        
        if currentTime < 60 {
            currentLabel.text = "00:\(String(format: "%02d", Int(currentTime)))"
        }else {
            currentLabel.text = "\(Int(currentTime) / 60):\(Int(currentTime) % 60)"
        }
        
        mediaProgress.progress = Float(currentTime / totalTime)
    }
    
    
    /// 播放完成
    @objc fileprivate func didEndPlay(_ noti: Notification) {
        // 从头播放
        player?.seek(to: kCMTimeZero)
        currentLabel.text = "00:00"
        mediaPause()
        
        // 移除动画
        guard let rotationView = rotationView else { return }
        rotationView.layer.removeAllAnimations()
        rotationView.transform = CGAffineTransform.identity
    }
    
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning")
    }
}


// MARK: - 监听方法
extension NotificationViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges" { // 设置缓冲进度
//            let loadTime = avalableDurationWithplayerItem()
//            let total = CMTimeGetSeconds(playerItem.duration)
//            let percent = loadTime / total
//            mediaProgress.progress = Float(percent)
            
        }else if keyPath == "status" {
            if playerItem.status == .readyToPlay { // 准备播放
                // 获取当前时间
                let totalTime = Int(CMTimeGetSeconds(playerItem.duration))
                if totalTime < 60 {
                    totalLabel.text = "/00:\(String(format: "%02d", totalTime))"
                }else {
                    totalLabel.text = "/\(totalTime / 60):\(totalTime % 60)"
                }
                mediaView.isHidden = false
                
            }else {
               print("播放异常")
            }
        }
    }
    
    
    // 计算缓冲时间
    private func avalableDurationWithplayerItem() -> TimeInterval {
        
        guard let loadedTimeRanges = player?.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else {
            return 0
        }
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        return startSeconds + durationSecound
    }
    
}


// 控制动画
extension CALayer {
    
    // 暂停动画
    @objc public func pauseAnimate() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    
    // 恢复动画
    @objc public func resumeAnimate() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}


// 数据类型
enum ImageFormat {
    case Unknown, PNG, JPEG, GIF
}

// 判断数据类型
extension NSData {
    var mh_imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 8)
        self.getBytes(&buffer, length: 8)
        if buffer == pngHeader {
            return .PNG
        } else if buffer[0] == jpgHeaderSOI[0] &&
            buffer[1] == jpgHeaderSOI[1] &&
            buffer[2] == jpgHeaderIF[0]
        {
            return .JPEG
        } else if buffer[0] == gifHeader[0] &&
            buffer[1] == gifHeader[1] &&
            buffer[2] == gifHeader[2]
        {
            return .GIF
        }
        
        return .Unknown
    }
}
