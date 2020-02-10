//
//  InteractiveNotification.swift
//  Cities
//
//  Created by Влад Казмирчук on 9/12/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

struct NotificationInteractiveConstraint {
    let topConstraint: NSLayoutConstraint
    let openTopConstant: CGFloat
    let closeTopConstant: CGFloat
}

class InteractiveNotification {
    
    weak var rootView: UIView?
    weak var notificationView: NotificationView?
    
    private let topConstraint: NSLayoutConstraint
    private let openConstant: CGFloat
    private let closeConstant: CGFloat
    private var heighWithMargin: CGFloat = 0
    
    private let animator: UIViewPropertyAnimator
    private let durationAnim: Double = 0.4
    
    
    var isActive = false
    var onClose: (()->Void)? = nil
    
    init(notificationView: NotificationView, rootView: UIView,
         topConstraint: NSLayoutConstraint, openConstant: CGFloat, closeConstant: CGFloat) {
        self.rootView = rootView
        self.notificationView = notificationView
        self.topConstraint = topConstraint
        self.openConstant = openConstant
        self.closeConstant = closeConstant
        
        animator = UIViewPropertyAnimator(duration: durationAnim, curve: .linear, animations: nil)
        
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        notificationView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let rootView = self.rootView else { return }
        let offsetY = recognizer.translation(in: rootView).y
        switch recognizer.state {
        case .began:
            isActive = true
            heighWithMargin = notificationView!.frame.size.height + openConstant
            animator.addAnimations {
                self.topConstraint.constant = self.closeConstant
                self.rootView?.layoutIfNeeded()
            }
            animator.fractionComplete = 0
        case .changed:
            ()
            if offsetY > 0 {
                notificationView?.transform = CGAffineTransform(translationX: 0, y: pow(offsetY, 0.6))
                if animator.fractionComplete != 0 { animator.fractionComplete = 0 }
            } else {
                if notificationView?.transform != .identity { notificationView?.transform = .identity }
                let fraction = abs(offsetY)/heighWithMargin
                animator.fractionComplete = fraction
            }
        case .ended:
            if animator.fractionComplete != 0 {
                animator.addCompletion { (pos) in
                    self.isActive = false
                    self.onClose?()
                }
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            } else if notificationView?.transform != .identity {
                UIView.animate(withDuration: durationAnim, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
                    self.notificationView?.transform = .identity
                }, completion: { finished in
                    self.animator.stopAnimation(true)
                    self.topConstraint.constant = self.openConstant
                    self.isActive = false
                })
            }
        default:
            ()
        }
    }
}
