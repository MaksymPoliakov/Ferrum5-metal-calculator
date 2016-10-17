//
//  TransitionAnimator.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 25.09.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    weak var tContext: UIViewControllerContextTransitioning?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        tContext = transitionContext
        guard
        let container = tContext?.containerView,
        let fromVC = tContext?.viewController(forKey: .from),
        let toVC = tContext?.viewController(forKey: .to)
        else {
            return
        }
        let translation = container.frame.width
        let offStageRight = CGAffineTransform(translationX: translation, y: 0)
        let offStageLeft = CGAffineTransform(translationX: -translation, y: 0)
        
        if toVC.index! > fromVC.index! {
            toVC.view.transform = offStageRight
        } else {
            toVC.view.transform = offStageLeft
        }
        
        fromVC.view.layer.anchorPoint = CGPoint.zero
        toVC.view.layer.anchorPoint = CGPoint.zero
        fromVC.view.layer.position = CGPoint.zero
        toVC.view.layer.position = CGPoint.zero
        
        container.addSubview(fromVC.view)
        container.addSubview(toVC.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: tContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            if toVC.index! > fromVC.index! {
                toVC.view.transform = CGAffineTransform.identity
                fromVC.view.transform = offStageLeft
            } else {
                toVC.view.transform = CGAffineTransform.identity
                fromVC.view.transform = offStageRight
            }
        }) { (completed) in
            if self.tContext!.transitionWasCancelled {
                self.tContext!.completeTransition(false)
            } else {
                self.tContext!.completeTransition(true)
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
}
