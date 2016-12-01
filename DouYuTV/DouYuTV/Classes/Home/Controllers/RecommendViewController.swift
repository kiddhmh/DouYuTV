//
//  RecommendViewController.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/11/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//  推荐

import UIKit

private let kCycleViewH = HmhDevice.screenW * 3 / 8
private let kGameViewH: CGFloat = 90

class RecommentViewController: BaseViewController {
    
    fileprivate lazy var recomVM: RecomViewModel = RecomViewModel()
    
    fileprivate lazy var cycleView: MHCycleView = {
        let cycleView = MHCycleView(frame: CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: HmhDevice.screenW, height: kCycleViewH))
        cycleView.delegate = self
        return cycleView
    }()
    
    fileprivate lazy var gameView: RecomGameView = {
        let gameView = RecomGameView(frame: CGRect(x: 0, y: -kGameViewH, width: HmhDevice.screenW, height: kGameViewH))
        return gameView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.addSubview(cycleView)
        collectionView.addSubview(gameView)
        
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
    
}


// MARK: - 请求数据
extension RecommentViewController {

    override func loadData() {
        
        recomVM.requestData(complectioned: { [weak self] in
            self?.collectionView.reloadData()
            
            self?.gameView.groups = self?.recomVM.hotGroup
            
            self?.loadDataFinished()
            }, failed: {[weak self] (error) in
            
            self?.loadDataFailed(error)
        })
        
        
        recomVM.requestCycleData(complectioned: { [weak self] in
            self?.cycleView.dataArr = self?.recomVM.cycleGroup
            }, failed: { [weak self] (error) in
                self?.loadDataFailed(error)
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
        if recomVM.bigGroup.count == 0 {
            return 0
        }else {
            return kSectionCount
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }else {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
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
    
}




