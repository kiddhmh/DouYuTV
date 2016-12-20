//
//  MHQRCodeController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/20.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD
import Photos
import AVFoundation

class MHQRCodeController: UIViewController {
    
    fileprivate let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    fileprivate let session = AVCaptureSession()
    fileprivate var layer: AVCaptureVideoPreviewLayer?

    fileprivate lazy var qrCodeView: MHQRCodeView = { [unowned self] in
        let qrCodeView = MHQRCodeView(frame: self.view.bounds)
        return qrCodeView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        qrCodeView.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrCodeView.stopAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNav()
        
        if !cameraPermissions() { return }
        
        scanQRCode()
    }
    
    private func setupNav() {
        title = "扫描二维码"
        
        let rightBtn = UIBarButtonItem(title: "相册", titleColor: .white, target: self, action: #selector(pickPicture))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    
    /// 开始扫描
    private func scanQRCode() {
        
        if !isCameraAvailable(){
            MBProgressHUD.showError("您的设备没有相机或相机损坏")
            return
        }
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        do{
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input){
                session.addInput(input)
            }
        }
        catch{
            MBProgressHUD.showError("初始化失败")
            return
        }
        
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer?.frame = view.frame
        view.layer.addSublayer(layer!)
        
        session.addObserver(self, forKeyPath: "running", options: .new, context: nil)
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized {
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //设置扫描的有效区域
            let w = HmhDevice.screenW / 3 * 2
            let h = w
            let x = (HmhDevice.screenW - w) / 2
            let y = (HmhDevice.screenH - h) / 2
            let rect = CGRect(x: y / HmhDevice.screenH, y: x / HmhDevice.screenW, width: h / HmhDevice.screenH, height: w / HmhDevice.screenW)
            output.rectOfInterest = rect
            if session.canAddOutput(output) {
                session.addOutput(output)
                output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            }
            view.addSubview(qrCodeView)
            session.startRunning()
        }else {
            MBProgressHUD.showError("Authorization is required to use the camera, please check your permission settings: Settings> Privacy> Camera")
        }
    }
    
    
    deinit{
        session.removeObserver(self, forKeyPath: "running", context: nil)
    }
}


extension MHQRCodeController {
    
    @objc fileprivate func pickPicture() {
        
        if PhotoLibraryPermissions() {
            
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //弹出控制器，显示界面
            MBProgressHUD.showLoading()
            present(picker, animated: true, completion: { 
                MBProgressHUD.hideHud()
            })
        }
    }
    
    /// 是否允许打开相册
    fileprivate func PhotoLibraryPermissions() -> Bool {
        
        let library = PHPhotoLibrary.authorizationStatus()
        if library == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (libraryStatus) in
                
            })
        }
        if library == .denied || library == .restricted {
            MBProgressHUD.showTips("请在设置－隐私－相册中打开权限")
            return false
        }else {
            return true
        }
    }
    
    
    /// 是否允许使用相机
    fileprivate func cameraPermissions() -> Bool {
        
        let mediaType = AVMediaTypeVideo
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
        
        if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: mediaType) { (succuss) in }
        }
        
        if authStatus == .denied || authStatus == .restricted {
            MBProgressHUD.showTips("请在设置－隐私－相机中打开权限")
            return false
        }else {
            return true
        }
    }
    
    fileprivate func isCameraAvailable()->Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let ob = object as? AVCaptureSession {
            if ob.isRunning{
                DispatchQueue.main.async(execute: {
                    //需要主线程执行的代码
                    self.qrCodeView.startAnimation()
                })
            }else{
                DispatchQueue.main.async(execute: {
                    //需要主线程执行的代码
                    self.qrCodeView.stopAnimation()
                })
            }
        }
    }
}


// MARK: - UIImagePickerDelegate
extension MHQRCodeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        // 读取二维码并显示
        image.readQRImage({ (result) in // 成功
            // 进入结果界面
            let resultVC = MHQRResultContoller()
            resultVC.urlString = result
            navigationController?.pushViewController(resultVC, animated: true)
        }) { // faild
            return MBProgressHUD.showError($0)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension MHQRCodeController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        var stringValue: String = ""
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        session.stopRunning()
        
        /// 进入结果页面
        let resultVC = MHQRResultContoller()
        resultVC.urlString = stringValue
        resultVC.resumeClosure = { [unowned self] in
            self.session.startRunning()
            self.qrCodeView.startAnimation()
        }
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
}
