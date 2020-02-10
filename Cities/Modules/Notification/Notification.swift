//
//  Notification.swift
//  Cities
//
//  Created by Влад Казмирчук on 9/11/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class Notification {
    unowned let viewController: UIViewController
    unowned let rootView: UIView
    let notificationView: NotificationView
    var interactive: InteractiveNotification? = nil
    
    private let margin: CGFloat = 18
    private let height: CGFloat = 100
    private let animationTime = 0.5
    private var topAnchor: NSLayoutConstraint!
    private let durationShow = 5.0
    private let closeTopConstant: CGFloat
    
    private var isShow = false
    
    deinit {
        print("Notification deinited")
    }
    init(viewController: UIViewController) {
        self.viewController = viewController
        rootView = viewController.navigationController?.view ?? viewController.view!
        notificationView = NotificationView(frame: .zero)
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(notificationView)
        closeTopConstant = -height-10
        setupLayout()
        interactive = InteractiveNotification(notificationView: notificationView, rootView: rootView, topConstraint: topAnchor, openConstant: margin, closeConstant: closeTopConstant)
    }
    
    private func setupLayout() {
        if #available(iOS 11.0, *) {
            notificationView.leadingAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
        } else {
            notificationView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: margin).isActive = true
        }
        topAnchor = notificationView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: closeTopConstant)
        topAnchor.isActive = true
        if #available(iOS 11.0, *) {
            notificationView.widthAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.widthAnchor, constant: -(margin*2)).isActive = true
        } else {
            notificationView.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -(margin*2)).isActive = true
        }
        notificationView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    //MARK: - Public methods
    func show(text: String, image: UIImage) {
        if !isShow {
            notificationView.setText(text)
            notificationView.setImage(image)
            showAnimation(closeAfter: durationShow)
            isShow = true
        } else {
            notificationView.setText(text)
            notificationView.setImage(image)
        }
    }
    
    //MARK: - Private methods
    //MARK: Animations
    private func showAnimation(closeAfter timeout: Double) {
        UIView.animate(withDuration: animationTime, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
            self.topAnchor.constant = self.margin
            self.rootView.layoutIfNeeded()
        }) { (finished) in
            let closeTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { (t) in
                self.closeAnimation()
            })
            self.interactive?.onClose = {
                self.isShow = false
                closeTimer.invalidate()
            }
        }
    }
    
    func closeAnimation() {
        guard isShow else { return }
        
        if interactive?.isActive != true {
            UIView.animate(withDuration: animationTime/2, animations: {
                self.topAnchor.constant = self.closeTopConstant
                self.rootView.layoutIfNeeded()
            }) { (finish) in
                self.isShow = false
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (t) in
                self.closeAnimation()
            }
        }
    }
    
}
