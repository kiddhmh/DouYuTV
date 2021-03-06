//
//  RecommendViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//  推荐

import UIKit
import MBProgressHUD

private let kCycleViewH = ceil(HmhDevice.screenW * 3 / 8)

class RecommentViewController: BaseAnchorViewController, StartLiveViewDelegate {
    
    fileprivate lazy var recomVM: RecomViewModel = RecomViewModel()
    
    fileprivate lazy var cycleView: MHCycleView = {
        let cycleView = MHCycleView(frame: CGRect(x: 0, y: -(kCycleViewH + S.GameViewH), width: HmhDevice.screenW, height: kCycleViewH))
        cycleView.delegate = self
        return cycleView
    }()
    
    fileprivate lazy var gameView: RecomGameView = {
        let gameView = RecomGameView(frame: CGRect(x: 0, y: -S.GameViewH, width: HmhDevice.screenW, height: S.GameViewH))
        return gameView
    }()
    
    fileprivate lazy var startLiveView: StartLiveView = StartLiveView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.addSubview(cycleView)
        collectionView.addSubview(gameView)
        
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + S.GameViewH, left: 0, bottom: 0, right: 0)
        
        gameView.moreClosure = {
            // 切换直播页面
            MHNotification.postNotification(notification: .changeSelectedVC)
        }
     
        /// 添加录制按钮
        view.insertSubview(startLiveView, aboveSubview: collectionView)
        startLiveView.delegate = self
        startLiveView.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.bottom.equalTo(view).offset(-15)
            make.right.equalTo(view).offset(-15)
        }
    }
}


// MARK: - 请求数据
extension RecommentViewController {

    override func loadData() {
        super.loadData()
        
        recomVM.requestData(complectioned: { [weak self] in
            guard let sself = self else { return }
            sself.gameView.groups = self?.recomVM.hotGroup
            if sself.gameView.groups?.count == 0 {return}
            sself.collectionView.reloadData()
            sself.loadDataFinished()
            
            // 结束刷新
            sself.refreshControl?.endRefreshing()
            }, failed: {[weak self] (error) in
                guard let sself = self else { return }
                MBProgressHUD.showError(error.errorMessage!)
                sself.loadDataFailed()
        })
        
        
        recomVM.requestCycleData(complectioned: { [weak self] in
            guard let sself = self else { return }
            sself.cycleView.dataArr = self?.recomVM.cycleGroup
            }, failed: { [weak self] (error) in
                guard let sself = self else { return }
                MBProgressHUD.showError(error.errorMessage!)
                sself.loadDataFailed()
        })
    }
}


extension RecommentViewController {
    
    func loadDataDidClick(failedView: BaseFailedView, _ button: UIButton) {
        failedView.removeFromSuperview()
        startAnimation()
        
        loadData()
    }
}


extension RecommentViewController: MHCycleViewDelegate {
    
    func cycleViewDidSelected(cycleView: MHCycleView, selectedIndex: NSInteger) {
        
        print("点击了第\(selectedIndex)张图片")
    }
}


extension RecommentViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recomVM.bigGroup.count == 0 ? 0 : kSectionCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {   // 最热
            return 8
        }else if section == 1 { // 颜值
            return 4
        }else { // 推荐
            let hotModels = recomVM.hotGroup.filter { ($0.room_list?.count)! > 0 }
            let anchorModels = hotModels[section - 2].room_list
            return anchorModels?.count == 4 ? 4 : 2
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return indexPath.section == 1 ? CGSize(width: kItemW, height: kPrettyItemH) : CGSize(width: kItemW, height: kNormalItemH)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.RecommentPrettyCellID, for: indexPath) as! RecommendPrettyCell
            cell.faceModel = recomVM.faceGroup[indexPath.row]
            return cell
        }else {
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! RecommentNormalCell
            
            if indexPath.section == 0 {
                cell.anchorModel = recomVM.bigGroup[indexPath.row]
            }else {
                let hotModels = recomVM.hotGroup.filter { ($0.room_list?.count)! > 0 }
                let anchorModels = hotModels[indexPath.section - 2].room_list
                cell.anchorModel = anchorModels?[indexPath.row]
            }
            
            return cell
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) as! RecommendSectionHeaderView

        if indexPath.section == 0 {
            sectionHeaderView.titleLabel.text = "最热"
            sectionHeaderView.iconImage.image = UIImage(named: "home_header_hot")
        }
        
        if indexPath.section == 1 {
            sectionHeaderView.titleLabel.text = "颜值"
            sectionHeaderView.iconImage.image = UIImage(named: "columnYanzhiIcon")
        }
        
        if indexPath.section > 1 {
            let hotModels = recomVM.hotGroup.filter { ($0.room_list?.count)! > 0 }
            sectionHeaderView.dataModel = hotModels[indexPath.section - 2]
        }
        
        return sectionHeaderView
    }
    
    
    // 点击进入直播页面
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 { // 颜值
             anchorLiveModel = recomVM.faceGroup[indexPath.item]
        }else if indexPath.section == 0 { //普通 (暂时沿用颜值，后面抓到接口再换)
             anchorLiveModel = recomVM.bigGroup[indexPath.item]
        }else {
            let totalModel = recomVM.hotGroup[indexPath.section].room_list
             anchorLiveModel = totalModel?[indexPath.item]
        }
        
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}




