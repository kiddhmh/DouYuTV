//
//  MHQRResultController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/20.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import WebKit

class MHQRResultContoller: UIViewController {
    
    /// 扫描结果
    var urlString:String = ""
    
    /// 返回类型
    enum ValidatedType {
        case email          //邮箱
        case phoneNumber    //手机号码
        case url            //网址
    }
    
    /// 视图消失回调，重新开始扫描
    var resumeClosure: moreBtnClosure?
    
    fileprivate lazy var progressViwe: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: HmhDevice.navigationBarH, width: HmhDevice.screenW, height: 2))
        progressView.progress = 0
        return progressView
    }()
    
    fileprivate var loadCount: Float? {
        didSet {
            guard let loadCount = loadCount else { return }
            if loadCount == 0 {
                progressViwe.isHidden = true
                progressViwe.setProgress(0, animated: false)
            }else {
                progressViwe.isHidden = false
                let old = progressViwe.progress
                var new = (1.0 - old) / (loadCount + 1.0) + old
                if new > 0.95 { new = 0.95}
                progressViwe.setProgress(new, animated: true)
            }
        }
    }
    
    fileprivate lazy var webView: WKWebView = {
        let webView: WKWebView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        return webView
    }()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard  let resume = resumeClosure else { return }
        resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCount = 0.0
        
        if ValidateText(validatedType: .email, validateString: urlString)||ValidateText(validatedType: .url, validateString: urlString) {
            
            webView.load(URLRequest(url: URL(string: urlString)!))
            view.addSubview(webView)
            view.addSubview(progressViwe)
            
            // 监听状态
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        }else {
            let label:UILabel = UILabel(frame:CGRect(x:0, y:0, width:view.width, height:view.height) )
            label.text = urlString
            label.textAlignment = NSTextAlignment.center
            label.textColor = .randomColor
            view.addSubview(label)
        }
    }
    
    
    private func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
        do {
            let pattern: String
            
            switch type {
            case ValidatedType.email:
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                
            case ValidatedType.url:
                pattern = "[a-zA-z]+://[^\\s]*"
                
            default:
                pattern = "^1[0-9]{10}$"
                
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: validateString, options: .reportProgress, range: NSMakeRange(0, validateString.characters.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
}


// MARK: - KVO
extension MHQRResultContoller {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loading" {
            // dosomething
        }else if keyPath == "title" {
            title = webView.title
        }else if keyPath == "URL" {
            // dosomething
        }else if keyPath == "estimatedProgress" {
            progressViwe.progress = Float(webView.estimatedProgress)
        }
        
        if (object as AnyObject) as! NSObject == webView && keyPath! == "estimatedProgress" {
            let newProgress = change?[NSKeyValueChangeKey.newKey] as? Float
            if newProgress == 1 {
                progressViwe.isHidden = true
                progressViwe.setProgress(0, animated: false)
            }else {
                progressViwe.isHidden = false
                progressViwe.setProgress(newProgress!, animated: false)
            }
        }
        
    }
}


extension MHQRResultContoller: WKNavigationDelegate {
    
    /// 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadCount! += 1.0
    }
    
    
    /// 内容返回时
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loadCount! -= 1.0
    }
    
    /// 失败时
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadCount! -= 1.0
    }
    
}
