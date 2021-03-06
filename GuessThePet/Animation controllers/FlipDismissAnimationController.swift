//
//  FlipDismissAnimationController.swift
//  Guess the Pet
//
//  Created by Bao Nguyen on 9/15/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var animationDuration: TimeInterval = 0.6
    var destinationFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
        let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView

        AnimationHelper.perspectiveTransformForContainerView(containerView)

        // 1
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        let finalFrame = destinationFrame

        // 2
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        snapshot?.layer.cornerRadius = 25
        snapshot?.layer.masksToBounds = true

        // 3
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        fromVC.view.isHidden = true

        AnimationHelper.perspectiveTransformForContainerView(containerView)

        // 4
        toVC.view.layer.transform = AnimationHelper.yRotation(-(.pi/2))

        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(withDuration:
            duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                // 1
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 1/3,
                                   animations: {
                                    snapshot?.frame = finalFrame
                })

                UIView.addKeyframe(withRelativeStartTime:1/3,
                                   relativeDuration: 1/3,
                                   animations: {
                                    snapshot?.layer.transform = AnimationHelper.yRotation(.pi/2)
                })

                UIView.addKeyframe(withRelativeStartTime:2/3,
                                   relativeDuration: 1/3,
                                   animations: {
                                    toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                })
        },
            completion: { _ in
                // 2
                fromVC.view.isHidden = false
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
