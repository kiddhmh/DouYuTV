//
//  MHTransitionManager.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class MHTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 设置动画的持续时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 设置动画的进行方式
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        // For a Presentation:
        //      fromView = The presenting view.
        //      toView   = The presented view.
        // For a Dismissal:
        //      fromView = The presented view.
        //      toView   = The presenting view.
        var fromView = fromViewController?.view
        var toView = toViewController?.view
        
        // iOS8引入了viewForKey方法，尽可能使用这个方法而不是直接访问controller的view属性
        // 比如在form sheet样式中，我们为presentedViewController的view添加阴影或其他decoration，animator会对整个decoration view
        // 添加动画效果，而此时presentedViewController的view只是decoration view的一个子视图
        if transitionContext.responds(to: #selector(UIViewControllerTransitionCoordinatorContext.view(forKey:))) {
            fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        }
        
        fromView?.frame = transitionContext.initialFrame(for: fromViewController!)
        toView?.frame = transitionContext.finalFrame(for: toViewController!)
        
        fromView?.alpha = 1.0
        toView?.alpha = 0.0
        
        // 在present和，dismiss时，必须将toview添加到视图层次中
        containerView.addSubview(toView!)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        // 动画结束后一定要调用completeTransition方法
        UIView.animate(withDuration: transitionDuration, animations: {
            fromView!.alpha = 0.0
            toView!.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}
