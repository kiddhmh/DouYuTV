//
//  MHTransitionZoom.swift
//  DouYuTV
//
//  Created by 胡明昊 on 16/12/23.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class MHTransitionZoom: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        
        var fromView = fromViewController?.view
        var toView = toViewController?.view
        
        if transitionContext.responds(to: #selector(UIViewControllerTransitionCoordinatorContext.view(forKey:))) {
            fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        }
        
        fromView?.frame = transitionContext.initialFrame(for: fromViewController!)
        toView?.frame = transitionContext.finalFrame(for: toViewController!)
        
        fromView?.alpha = 1.0
        toView?.alpha = 0.0
        
        containerView.addSubview(toView!)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            fromView!.alpha = 0.0
            toView!.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}
