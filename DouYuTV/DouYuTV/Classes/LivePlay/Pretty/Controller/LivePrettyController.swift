//
//  LivePrettyController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/31.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD

private let images: [UIImage] = [UIImage(named: "portrait_loading1_107x31_")!, UIImage(named: "portrait_loading2_107x31_")!, UIImage(named: "portrait_loading3_107x31_")!, UIImage(named: "portrait_loading4_107x31_")!, UIImage(named: "portrait_loading5_107x31_")!, UIImage(named: "portrait_loading6_107x31_")!, UIImage(named: "portrait_loading7_107x31_")!, UIImage(named: "portrait_loading8_107x31_")!, UIImage(named: "portrait_loading9_107x31_")!, UIImage(named: "portrait_loading10_107x31_")!]

class LivePrettyController: UIViewController {
    
    var model: AnchorModel? {
        didSet {
            guard let model = model, let backUrl = model.vertical_src else { return }
            UpLayerView.model = model
            
            let url = URL(string: backUrl)
            placeholder.kf.setImage(with: url)
        }
    }
    
    fileprivate lazy var liveVM: LiveViewModel = LiveViewModel()
    
    // 播放地址
    fileprivate var liveURL: String?
    
    // 直播播放器
    fileprivate var moviePlayer: IJKFFMoviePlayerController?
    
    // 关闭按钮
    fileprivate var backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "rank_btn_close"), for: .normal)
        btn.setImage(UIImage(named: "rank_btn_close_pressed"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "Image_clear"), for: .normal)
        btn.addTarget(self, action: #selector(dismissed), for: .touchUpInside)
        return btn
    }()
    
    // 直播上浮层
    fileprivate var UpLayerView: LivePrettyLayerView = {
        let view: LivePrettyLayerView = LivePrettyLayerView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.0)
        return view
    }()
    
    /// 播放器占位图
    fileprivate var placeholder: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame = HmhDevice.screenRect
        let blurEssect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEssect)
        visualEffectView.frame = imageView.bounds
        imageView.addSubview(visualEffectView)
        return imageView
    }()
    
    /// 等待动画Loading
    fileprivate var loadingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.animationDuration = 2.0
        imageView.animationRepeatCount = 0
        imageView.animationImages = images
        return imageView
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        moviePlayer?.shutdown()
        moviePlayer?.view.removeFromSuperview()
        UpLayerView.removeFromSuperview()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 请求播放数据
        loadData()
        
        setupUI()
    }
    
    fileprivate func configIJKPlayView() {
        
        // 本来找到了auth的破解算法，结果斗鱼更新了，算法被换了，无法获取auth，导致无法获取 hls-url 地址，导致无法播放，没办法，准备先用映客的数据进行播放吧
        
        let options: IJKFFOptions = IJKFFOptions.byDefault()
        // 开启硬编码
        options.setPlayerOptionValue("1", forKey: "videotoolbox")
        // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
        options.setPlayerOptionIntValue(Int64(29.97), forKey: "r")
        // -vol——设置音量大小，256为标准音量。
        options.setPlayerOptionIntValue(Int64(256), forKey: "vol")
        moviePlayer = IJKFFMoviePlayerController(contentURL: URL(string: liveURL ?? ""), with: options)
        moviePlayer?.view.frame = view.bounds
        moviePlayer?.scalingMode = .aspectFill
        moviePlayer?.shouldAutoplay = true
        moviePlayer?.shouldShowHudView = false
        view.insertSubview(moviePlayer?.view ?? UIView(), belowSubview: UpLayerView)
        
        moviePlayer?.prepareToPlay()
        
        // 设置监听
        initPlayerObserver()
    }
    
    private func setupUI() {
        
        //添加手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureView(_:)))
        view.addGestureRecognizer(panGesture)
        
        view.addSubview(placeholder)
        
        view.addSubview(UpLayerView)
        UpLayerView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.right.equalTo(view.snp.right).offset(-10)
            make.top.equalTo(view.snp.top).offset(40)
        }
        
        view.addSubview(loadingImage)
        loadingImage.snp.makeConstraints { (make) in
            make.height.equalTo(31)
            make.width.equalTo(107)
            make.center.equalTo(view)
        }
        loadingImage.startAnimating()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 关闭直播页面
    @objc private func dismissed() {
        self.dismiss(animated: true, completion: nil)
        
        if moviePlayer != nil {
            moviePlayer?.shutdown()
            MHNotification.removeAll(observer: self)
        }
        
        UpLayerView.removeFromSuperview()
    }
    
    fileprivate func stopLoading() {
        loadingImage.stopAnimating()
        loadingImage.isHidden = true
    }
    
    deinit {
        MHNotification.removeAll(observer: self)
    }
}


extension LivePrettyController {
    
    fileprivate func loadData() {
        
        liveVM.requestLiveData(complectioned: { [unowned self] in
            
            let models = self.liveVM.liveModels
            let count = UInt32(models.count)
            guard count != 0 else { return }
            let acrNum = Int(arc4random() % count)
            self.liveURL = models[acrNum].stream_addr
            self.UpLayerView.shareURL = models[acrNum].share_addr
            
            // 先判断当前网络环境并给出提示
            guard !HttpReachability.isOnWWAN else { // 使用的是蜂窝数据
                // 弹框提示
                self.showAlert()
                return
            }
            
            // 加载播放器
            self.configIJKPlayView()
        }, failed: { error in
            MBProgressHUD.showError(error.errorMessage ?? "加载失败")
        })
        
    }
    
    
    private func showAlert() {
        
        let alertVC = UIAlertController(title: "提示", message: "正在使用蜂窝数据观看，是否继续", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
            self.configIJKPlayView()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}


// 手势事件
extension LivePrettyController {
    
    @objc fileprivate func panGestureView(_ pan: UIPanGestureRecognizer) {
    
        let point = pan.translation(in: pan.view)
        switch pan.state {
        case .began:
            break
        case .changed:
            UpLayerView.left = HmhDevice.screenW + point.x
            break
        case .ended:
            if UpLayerView.left > HmhDevice.screenW / 2 {
                UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                    self.UpLayerView.left = HmhDevice.screenW
                })
            }else {
                UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                    self.UpLayerView.left = 0
                })
            }
            break
        default:
            break
        }
    }
}


// MARK: - IJKFFMoviePlayerObserver
extension LivePrettyController {
    
    fileprivate func initPlayerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinish), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: moviePlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(stateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: moviePlayer)
    }
    
    
    @objc private func didFinish() {
        
        guard let moviePlayer = moviePlayer else { return }
        print("加载状态 ===>>> \(moviePlayer.loadState)")
        
        // 因为网速或者其他原因导致直播stop了, 也要显示GIF
        if !moviePlayer.loadState.isEmpty && !IJKMPMovieLoadState.stalled.isEmpty {
            if !loadingImage.isAnimating {
                loadingImage.isHidden = false
                loadingImage.startAnimating()
            }
            return
        }
        
        // 发送网络请求确认是否能成功播放，若失败---提示直播结束，关闭直播器
        
    }
    
    
    @objc private func stateDidChange() {
        
        guard let moviePlayer = moviePlayer else { return }
        
        if !moviePlayer.loadState.isEmpty && !IJKMPMovieLoadState.playthroughOK.isEmpty {
            
            if moviePlayer.isPlaying() {
                placeholder.removeFromSuperview()
                stopLoading()
            }
            
            if !moviePlayer.isPlaying() {
                moviePlayer.play()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { [unowned self] in
                    self.placeholder.removeFromSuperview()
                    self.stopLoading()
                })
            }else {
                // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
                if loadingImage.isAnimating {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { [unowned self] in
                        self.stopLoading()
                    })
                }
            }
        }else if !moviePlayer.loadState.isEmpty && !IJKMPMovieLoadState.stalled.isEmpty { //网络不佳,自动暂停状态
            if !loadingImage.isAnimating {
                loadingImage.isHidden = false
                loadingImage.startAnimating()
            }
        }
    }
}

