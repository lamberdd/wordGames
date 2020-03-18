//
//  ConstraintConfiguratorBestScores.swift
//  Cities
//
//  Created by Влад Казмирчук on 2/20/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class ConstraintConfiguratorBestScores {
    
    private let buttonHeight: CGFloat = 36
    private let bottomMargin: CGFloat = -30.0
    
    func setupContinueButton(button: UIButton, in view: UIView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.76, constant: 0.0)
        widthConstraint.priority = UILayoutPriority(950.0)
        let maxWidthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1.0, constant: 500.0)
        
        var constraints = [
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: bottomMargin),
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonHeight)
        ]
        constraints.append(widthConstraint)
        constraints.append(maxWidthConstraint)
        button.layer.cornerRadius = buttonHeight/2
        view.addConstraints(constraints)
    }
    
    func setupPageControl(_ pageControl: UIPageControl, in view: UIView) {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: bottomMargin-buttonHeight-20),
            NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        ]
        view.addConstraints(constraints)
    }
}
