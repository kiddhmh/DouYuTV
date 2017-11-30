//
//  NotificationService.swift
//  dyNotification
//
//  Created by 胡明昊 on 17/1/17.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UserNotifications

// Tips: 如果需要修改推送内容，需要增加字段"mutable-content" : 1

class NotificationService: UNNotificationServiceExtension {

    typealias CompletionHandlerBlock = (UNNotificationAttachment?) -> Void
    @objc var contentHandler: ((UNNotificationContent) -> Void)?
    @objc var bestAttemptContent: UNMutableNotificationContent?

    // 这里可以拿到推送的数据，在展示前进行修改，注意一般是30s时间，可以进行断点下载，数据解密
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title)-修改的"
            
            let userInfo = request.content.userInfo
            // 下载图片/音频/
            let sourceUrl = userInfo["sourceUrl"]
            if sourceUrl != nil{
                
                // 如果说存在附件的话
                loadAttachmentForUrlString(urlStr: sourceUrl as! String, completionHandler: { (attachment) in
                    
                    if attachment != nil{
                        // 如果说 attachment 不为空的话
                        bestAttemptContent.attachments = [attachment!]
                    }
                    contentHandler(bestAttemptContent)
                })
                
            }else{
                // 如果说不存在附件的话
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    
    /*
     options:
     UNNotificationAttachmentOptionsTypeHintKey // 用于手动设置附件类型提示的键
     UNNotificationAttachmentOptionsThumbnailHiddenKey  // 是否隐藏此附件的缩略图
     UNNotificationAttachmentOptionsThumbnailClippingRectKey // 指定裁剪附件的区域
     UNNotificationAttachmentOptionsThumbnailTimeKey // 指定缩略图动画时间的键
     
     */
    
    // 如果超过时间，会强制进入该方法，将原先的内容进行展示
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

// imgurl : http://upload.univs.cn/2012/0104/1325645511371.jpg
//            http://ww3.sinaimg.cn/mw690/6e66a37ajw1fblsx056leg205s05snpd.gif
// video : http://gslb.miaopai.com/stream/r1c5YnPzSGP~D2F9bI0Z6A__.mp4
// audio : http://ring.20cd.com:8001/201003/223ring/897.mp3 //1M 可能会超时
//          http://ring.20cd.com:8001/201003/251ring/940.mp3 // 400KB

extension NotificationService {
    
    // MARK:- 下载相关的附件信息
    @objc func loadAttachmentForUrlString(urlStr:String, completionHandler:@escaping CompletionHandlerBlock) -> Void {
        
        let attachmentURL:URL = URL(string: urlStr)! // 路径URL
        let fileExt = attachmentURL.lastPathComponent   // 文件后缀名
        let fileManager = FileManager.default           // 文件管理者
        // 先删除之前的缓存
        fileManager.removeAllFilesInTemp()
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.downloadTask(with: attachmentURL, completionHandler: { (temURL, response, error) in
            
            // 下载完毕，或者报错，转到主线程中
            var attachment : UNNotificationAttachment? = nil
            
            if error != nil {
                print("session error = \(error?.localizedDescription ?? "")")
            }else {
                let localURL = URL(fileURLWithPath: (temURL!.deletingPathExtension().path + fileExt))
                do {
                    try fileManager.moveItem(at: temURL!, to: localURL)
                }catch let error {
                    print("fileManager error = \(error.localizedDescription)")
                }
                
                do {
                    attachment = try UNNotificationAttachment.init(identifier: "imageAttachment", url: localURL, options: nil)
                }catch let error {
                    print("UNNotificationAttachment error = \(error.localizedDescription)")
                }
                
                completionHandler(attachment)
            }
        })
        
        dataTask.resume()
    }

}


// 获取沙盒地址
extension FileManager {
    
    // 获取caches路径
    @objc var cachesDirectory: String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    // 获取Documents路径
    @objc var documentDirectory: String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    // 获取temp路径
    @objc var tempDirectory: String {
        return NSTemporaryDirectory()
    }
    
    // 删除temp目录下所有文件
    @objc public func removeAllFilesInTemp() {
        
        let url = URL(fileURLWithPath: tempDirectory)
        let urls = try? contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        guard let urlss = urls, urlss.count != 0 else { return }
        for url in urlss {
            do {
                try removeItem(at: url)
            }catch let error {
                print(" removeTempError = \(error.localizedDescription)")
            }
        }
    }
}

