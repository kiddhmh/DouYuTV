//
//  MHPushViewCell.swift
//  DouYuTV
//
//  Created by 胡明昊 on 17/1/11.
//  Copyright © 2017年 CMCC. All rights reserved.
//

import UIKit

private let PushViewCellID = "MHPushViewCellID"
private let PushSwitchCellID = "MHPushSwitchViewID"

class MHPushViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    public func setTitle(title: String?, withText text: String?, andIndexPath indexPath: IndexPath) {
        
        titleLabel.text = title
        textField.text = text
        textField.indexPath = indexPath
    }
    
    
    /*
        class修饰的类方法可以被子类重写，static修饰的类方法不能
     */
    static public func creatCellWith(_ tableView: UITableView) -> MHPushViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: PushViewCellID) as? MHPushViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MHPushViewCell", owner: nil, options: nil)?.first as? MHPushViewCell
        }
        
        return cell!
    }
}


class MHPushSwitchViewCell: UITableViewCell, MHSwitchDelegate {
    
    var stateChangeClosure: ((_ isOn: Bool) -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var repeatSwitch: MHSwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        repeatSwitch.delegate = self
    }
    
    public func setTitle(title: String?, isRepeat: Bool) {
        
        titleLabel.text = title
        repeatSwitch.isOn = isRepeat
    }
    
    
    static public func creatCellWith(_ tableView: UITableView) -> MHPushSwitchViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: PushSwitchCellID) as? MHPushSwitchViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MHPushViewCell", owner: nil, options: nil)?.last as? MHPushSwitchViewCell
        }
        
        return cell!
    }
    
    
    func valueDidChanged(mhSwitch: MHSwitch, isOn: Bool) {
        guard let stateChangeClosure = stateChangeClosure else { return }
        stateChangeClosure(isOn)
    }
}
