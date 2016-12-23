//
//  MHHistoryViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

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
        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.SearchHotCellID)
        
        let h = UIView()
        h.backgroundColor = .red
        h.bounds = CGRect(x: 0, y: 0, width: 375, height: 44)
        tableView.tableHeaderView = h
        
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
    
    /// 顶部搜索框
    fileprivate lazy var searchView: MHSearchView = {
        let searView = MHSearchView(frame: CGRect(x: kMargin, y: kSearchY, width: HmhDevice.screenW - kMargin - kCancelBtnW, height: kSearchH))
        return searView
    }()
    
    /// 搜索框下方线
    fileprivate lazy var searchBottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        loadData()
    }
    
    private func setupUI() {
        
        view.addSubview(searchView)
        searchBottomLine.frame = CGRect(x: 0, y: HmhDevice.navigationBarH - 1, width: HmhDevice.screenW, height: 1)
        view.addSubview(searchBottomLine)
        
        cancelBtn.frame = CGRect(x: searchView.right, y: searchView.top, width: kCancelBtnW, height: searchView.height)
        view.addSubview(cancelBtn)
        
        view.addSubview(hotTableView)
    }
    
    
    @objc fileprivate func searchDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension MHSearchViewController {
    
    fileprivate func loadData() {
        
        searchVM.requestHistoryData(complectioned: { [unowned self] in //刷新数据
            guard let models = self.searchVM.searchHotModel else { return }
            print(models.data ?? "1")
            self.hotTableView.reloadData()
            
        }, failed: { (error) in
            
            print(error.errorMessage ?? "")
        })
        
    }
    
}


extension MHSearchViewController: UITableViewDelegate {

    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SearchHotCellID, for: indexPath)
        cell.textLabel?.text = searchVM.searchHotModel?.data?[indexPath.row] ?? ""
        return cell
    }
    
}

