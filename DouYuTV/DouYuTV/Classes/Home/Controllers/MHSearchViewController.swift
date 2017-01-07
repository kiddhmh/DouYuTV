//
//  MHHistoryViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit
import MBProgressHUD
import RealmSwift

private let kCancelBtnW: CGFloat = 40
private let kMargin: CGFloat     = 16
private let kSearchY: CGFloat    = HmhDevice.navigationBarH - HmhDevice.kNavigationBarH
private let kSearchH: CGFloat    = 33

class MHSearchViewController: UIViewController {
    
    fileprivate lazy var searchVM: MHSearchHotViewModel = MHSearchHotViewModel()
    
    fileprivate lazy var hotTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: HmhDevice.navigationBarH, width: HmhDevice.screenW, height: HmhDevice.screenH - HmhDevice.navigationBarH),  style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        // 分割线至屏幕边缘
        tableView.separatorInset = .zero
        
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    /// 取消按钮
    fileprivate lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(C.mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(searchDismiss), for: .touchUpInside)
        return btn
    }()
    
    /// tableView顶部视图
    fileprivate lazy var tableHeaderView: UITableViewHeaderFooterView = {
        
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "SearchTabelHeaderView")
        headerView.contentView.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 43.5))
        label.textColor = C.mainTextColor
        label.text = "今日热搜"
        label.font = UIFont.systemFont(ofSize: 14)
        headerView.contentView.addSubview(label)
        let line = UIView(frame: CGRect(x: 0, y: 43.5, width: HmhDevice.screenW, height: 0.5))
        line.backgroundColor = UIColor(r: 198.9, g: 198.9, b: 204, a: 1)
        headerView.contentView.addSubview(line)
        
        return headerView
    }()
    
    /// 顶部搜索框
    fileprivate lazy var searchView: MHSearchView = {
        let searView = MHSearchView(frame: CGRect(x: kMargin, y: kSearchY, width: HmhDevice.screenW - kMargin - kCancelBtnW, height: kSearchH))
        searView.delegate = self
        return searView
    }()
    
    /// 搜索框下方线
    fileprivate lazy var searchBottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(r: 198.9, g: 198.9, b: 204, a: 1)
        return line
    }()
    
    /// 历史视图
    fileprivate lazy var titleHistoryView: SearchHistoryView = SearchHistoryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 刷新标签
        configTitleHistoryView()
    }
    
    private func setupUI() {
        
        view.addSubview(searchView)
        searchBottomLine.frame = CGRect(x: 0, y: HmhDevice.navigationBarH - 1, width: HmhDevice.screenW, height: 0.5)
        view.addSubview(searchBottomLine)
        
        cancelBtn.frame = CGRect(x: searchView.right, y: searchView.top, width: kCancelBtnW, height: searchView.height)
        view.addSubview(cancelBtn)

        titleHistoryView.frame = CGRect.init(x: hotTableView.left, y: hotTableView.top, width: hotTableView.width, height: 0)
        hotTableView.tableHeaderView = self.titleHistoryView
        view.addSubview(hotTableView)

        // 更新高度, 如何动态改变tableViewHeader高度，改变高度后要重新设置下headerView，否则不会生效
        titleHistoryView.updateHeight = { [unowned self] height in
            self.updateHeaderHeight(height)
        }
    }
    
    
    @objc fileprivate func searchDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateHeaderHeight(_ height: CGFloat) {
        
        hotTableView.tableHeaderView?.height = height
        hotTableView.tableHeaderView = self.titleHistoryView
    }
}


extension MHSearchViewController {
    
    fileprivate func loadData() {
        
        // 判断网络类型
        guard HttpReachability.isReachable == true else {
            MBProgressHUD.showError("当前网络不可用")
            return
        }
        
        searchVM.requestHistoryData(complectioned: { [unowned self] in //刷新数据
            guard self.searchVM.searchHotModel != nil else { return }
            self.hotTableView.reloadData()
            
            self.configTitleHistoryView()
            
        }, failed: { (error) in
            
            print(error.errorMessage ?? "")
        })
        
    }
    
    
    fileprivate func configTitleHistoryView() {
        
        // 获取历史数据
        let history = self.loadHistoryData()
        guard history.count != 0 else { //隐藏历史视图
            titleHistoryView.isHidden = true
            updateHeaderHeight(0)
            return
        }
        
        // 显示标签视图
        titleHistoryView.removeAllTags()
        titleHistoryView.isHidden = false
        titleHistoryView.tags = history
    }
    
    private func loadHistoryData() -> [String] {
        
        let results = RealmTool.userReaml.objects(SearchHistoryModel.self)
        var history: [String] = []
        for obj in results {
            history.append(obj.text)
        }
        return history
    }
    
}


extension MHSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension MHSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchVM.searchHotModel?.data?.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = searchVM.searchHotModel?.data?.count else { return 0 }
        return count == 0 ? 0 : count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SearchHistoryCell.cell(withTableView: tableView, indexPath)
        let title = searchVM.searchHotModel?.data?[indexPath.row] ?? ""
        cell.setTitle(title, withIndex: indexPath.row)
        return cell
    }
}


extension MHSearchViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        let text = textField.text ?? ""
        guard text != "" else { return true}
        
        // 添加到数据库
        let searchObj = SearchHistoryModel()
        searchObj.text = text
        try! RealmTool.userReaml.write {
            RealmTool.userReaml.add(searchObj)
        }
        
        textField.text = ""
        return true
    }
    
}

