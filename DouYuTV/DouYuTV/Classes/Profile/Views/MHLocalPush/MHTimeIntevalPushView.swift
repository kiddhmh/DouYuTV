//
//  MHTimeIntevalPushView.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/10.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit
import Spring
import MBProgressHUD
import CoreLocation

public var pushTitleArray = ["标题", "副标题", "内容"]

class MHTimeIntevalPushView: SpringView {
    
    // 导航栏
    @IBOutlet weak var timeIntevalBar: UINavigationBar!
    
    // 导航栏工具栏
    @IBOutlet weak var timeIntevalNavItem: UINavigationItem!
    
    // 右侧确定按钮
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    //  返回上一级回调
    var backClosure: moreBtnClosure?
    
    // 数据
    var model: RLMNotification? {
        didSet {
            guard let model = model else { return }
            // 每种type第五项是不同
            let isRepeat = model.isReapet == true ? "1" : "0"
            dataArray = [model.title, model.subtitle, model.body, model.attactment, "\(model.timeInteval)",  isRepeat]
            tableView.reloadData()
        }
    }
    
    // 当前所选的type
    var trigger: MHNotificationTrigger?
    
    // 用于保存数据
    fileprivate var dataArray: [String]?
    
    // 是否重复
    fileprivate var isRepeat: Bool = false
    
    // 显示设置内容
    @IBOutlet weak var tableView: UITableView!
    
    // 选择附件的pickView
    fileprivate lazy var attachPickView: UIPickerView = {
        let pickView = UIPickerView(frame: CGRect(x: 0, y: HmhDevice.screenH, width: HmhDevice.screenW, height: HmhDevice.screenH * 0.3))
        pickView.backgroundColor = .white
        pickView.delegate = self
        pickView.dataSource = self
        return pickView
    }()
    
    // toolBar
    fileprivate lazy var pickToolBar: UIToolbar = { [unowned self] in
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: HmhDevice.screenH - self.attachPickView.height - 20, width: HmhDevice.screenW, height: 40))
        toolBar.barStyle = .blackOpaque
        return toolBar
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    
    private func setupUI() {
        
       timeIntevalNavItem.leftBarButtonItem  = UIBarButtonItem(image: #imageLiteral(resourceName: "navBackBtnHL"), highlightImage: #imageLiteral(resourceName: "navBackBtnHL"), size: CGSize(width: 18, height: 18), target: self, action: #selector(backTomenu))
        
        // 设置标题字体属性
        timeIntevalBar.titleTextAttributes = [NSForegroundColorAttributeName: C.mainColor]
        
        // 设置导航栏半透明
        timeIntevalBar.isTranslucent = true
        
        // 设置导航栏背景图片
        timeIntevalBar.setBackgroundImage(UIImage(), for: .default)
        
        // 设置导航栏阴影图片
        timeIntevalBar.shadowImage = UIImage()
        
        // 设置弹出视图的工具栏
        let cancelBarbutton = UIBarButtonItem.init(title: "取消", titleColor: .white, target: self, action: #selector(cancelClick))
        let doneBarbutton = UIBarButtonItem.init(title: "确定", titleColor: C.mainColor, target: self, action: #selector(sureClick))
        pickToolBar.items = [cancelBarbutton, doneBarbutton]
    }
    
    
    // 工具栏取消按钮
    @objc private func cancelClick() {
        let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! MHPushViewCell
        cell.textField.text = dataArray?[3]
        cell.textField.resignFirstResponder()
    }
    
    // 工具栏确定按钮
    @objc private func sureClick() {
        let seleRow = attachPickView.selectedRow(inComponent: 0)
        dataArray?[3] = HmhTools.resources[seleRow]
        
        let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! MHPushViewCell
        cell.textField.text = HmhTools.resources[seleRow]
        cell.textField.resignFirstResponder()
    }
    
    // 返回上级菜单
    @objc private func backTomenu() {
        
        self.snp.updateConstraints { (make) in
            make.center.equalTo(CGPoint(x: HmhDevice.screenW + HmhDevice.screenW * 0.4, y: (HmhDevice.screenH - HmhDevice.navigationBarH) / 2))
        }
        
        animation = "slideRight"
        animateNext {
            self.removeFromSuperview()
        }
        
        guard let backClosure = backClosure else { return }
        backClosure()
    }
    
    // 保存输入的信息
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let dataArray = dataArray else { return }
        
        // 更新数据库
        try! RealmTool.userReaml.write {
            model?.title = dataArray[0]
            model?.subtitle = dataArray[1]
            model?.body = dataArray[2]
            model?.attactment = dataArray[3]
            model?.timeInteval = Double(dataArray[4]) ?? 0
            model?.isReapet = (dataArray.last ?? "0") == "0" ? false : true
        }
        
        animation = "fall"
        animateNext {
            self.removeFromSuperview()
            MHBlurEffctView.mhBlurEffectView.removeFromSuperview()
        }
        
        // 注册本地通知
        self.register()
    }
    
    
    @objc func textDidChange(_ noti: Notification) {
        
        let textField = noti.object as! UITextField
        let indexPath = textField.indexPath
        
        dataArray?[indexPath!.row] = textField.text ?? ""
    }
    
    // 注册推送通知(后面会封装，根据type进行设置,先test)
    private func register() {
        
        guard let trigger = trigger, let model = model else { return }
        
        let content = JPushNotificationContent()
        content.title = model.title
        content.subtitle = model.subtitle
        content.body = model.body
        content.badge = 1
        
        content.categoryIdentifier = "CustomCategory"
        
        let pushTrigger = JPushNotificationTrigger()
        pushTrigger.repeat = isRepeat
        let request = JPushNotificationRequest()
        
        switch trigger {
        case .timeInterval:
            
            // 不足60s给出提示
            let timeIntevl: Double = Double(dataArray?[4] ?? "0")!
            let isRepeat: Bool = (dataArray?.last ?? "0") == "0" ? false : true
            guard timeIntevl >= 60.0 else {
                if isRepeat == true {
                    MBProgressHUD.showError("如果重复提醒，时间必须大于60秒")
                }
                return
            }
            
            if #available(iOS 10, *) {
                // 如果重复，时间间隔最少60s
                pushTrigger.timeInterval = timeIntevl
            } else {
                pushTrigger.fireDate = Date(timeIntervalSinceNow: timeIntevl)
            }
            pushTrigger.repeat = isRepeat
            request.requestIdentifier = "MHTimeIntevalPush"
            
        case .calendar:
            
            let calendar = model.calendar
            if #available(iOS 10, *) {
                pushTrigger.dateComponents.hour = calendar?.hour
                pushTrigger.dateComponents.minute = calendar?.minute
                pushTrigger.dateComponents.weekday = calendar?.weakDay
            } else {
                MBProgressHUD.showTips("该功能仅支持iOS10")
            }
            request.requestIdentifier = "MHCalendarPush"

        case .location:
            
            let coordinate = CLLocationCoordinate2DMake(Double(model.coordinateLatitude)!, Double(model.coordinateLongitude)!)
            let region = CLCircularRegion(center: coordinate, radius: 0.0, identifier: "MHRegion\(coordinate.latitude)\(coordinate.longitude)")
            pushTrigger.region = region
            request.requestIdentifier = "MHLocationPush"
        }
        
        // 设置附件
        let path = Bundle.main.path(forResource: model.attactment, ofType: nil, inDirectory: "NotificationResource.bundle")
        let url = URL(fileURLWithPath: path!)
        if #available(iOS 10, *) {
            do {
                let attachment = try UNNotificationAttachment.init(identifier: "LocationAttachment", url: url, options: [:])
                content.attachments = [attachment]
            }catch let error {
                print("LocationAttachmentError == \(error.localizedDescription)")
            }
        }
        
        request.content = content
        request.trigger = pushTrigger
        request.completionHandler = { result in
            print(result ?? "")
        }
        
        JPUSHService.addNotification(request)
    }
}


extension MHTimeIntevalPushView {
    
    // 快速创建
    class func timeIntevalPushView() -> MHTimeIntevalPushView {
        return HmhTools.createView("MHTimeIntevalPushView") as! MHTimeIntevalPushView
    }
}


// MARK: - UITableViewDataSource
extension MHTimeIntevalPushView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pushTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = creatCell(indexPath, tableView)
        
        setupCell(indexPath, cell: cell)
        
        return cell
    }
    
    // 根据位置加载不同的Cell
    private func creatCell(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        
        guard indexPath.row != 5 else {
            return MHPushSwitchViewCell.creatCellWith(tableView)
        }
        return MHPushViewCell.creatCellWith(tableView)
    }
    
    // 加载cell的数据
    private func setupCell(_ indexPath: IndexPath, cell: Any) {
        
        guard let dataArray = dataArray, dataArray.count != 0 else { return }
        let title = pushTitleArray[indexPath.row]
        
        if indexPath.row == 5 {
            
            let isrepeat = dataArray.last! == "0" ? false : true
            (cell as! MHPushSwitchViewCell).setTitle(title: title, isRepeat: isrepeat)
            (cell as! MHPushSwitchViewCell).stateChangeClosure = { [unowned self] isOn in
                
                let isRepeat = isOn == false ? "0" : "1"
                self.dataArray?[indexPath.row] = isRepeat
            }
            
        }else {

            (cell as! MHPushViewCell).setTitle(title: title, withText: dataArray[indexPath.row], andIndexPath: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 设置弹起键盘类型
        guard indexPath.row != 5 else { return }
        setupKetBoardType(trigger!, (cell as! MHPushViewCell).textField)
    }
    
    private func setupKetBoardType(_ type: MHNotificationTrigger, _ textField: UITextField) {
        switch type {
        case .timeInterval:
            if textField.indexPath?.row == 4 { // 设置重复时间
                textField.keyboardType = .decimalPad
            }
            if textField.indexPath?.row == 3 { // 设置附件
                textField.placeholder = "点击选择附件"
                textField.inputView = attachPickView
                textField.inputAccessoryView = pickToolBar
            }
            
        case .calendar:
            break
        case .location:
            break
        }
    }
    
}


// MARK: - UITableViewDelegate
extension MHTimeIntevalPushView: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UIPickerViewDataSource
extension MHTimeIntevalPushView: UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return HmhTools.resources.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = HmhTools.resources[row]
        return NSAttributedString.init(string: title, attributes: [NSForegroundColorAttributeName : C.mainColor])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! MHPushViewCell
        cell.textField.text = HmhTools.resources[row]
    }
}

