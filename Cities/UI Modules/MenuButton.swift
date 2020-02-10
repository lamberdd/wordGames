//
//  MenuButton.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class MenuButton: UIButton {

    let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 50.0
        layer.borderColor = Constants.colors.main.cgColor
        layer.borderWidth = 2.0
    }
    
    override func awakeFromNib() {
        initAnimation()
        layer.shadowColor = Constants.colors.main.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
        layer.add(borderColorAnimation, forKey: "borderColor")
    }
    
    private func initAnimation() {
        borderColorAnimation.fromValue = Constants.colors.main.cgColor
        borderColorAnimation.toValue = UIColor.yellow.cgColor
        borderColorAnimation.duration = 2
        borderColorAnimation.repeatCount = .infinity
        borderColorAnimation.autoreverses = true
        borderColorAnimation.isRemovedOnCompletion = false
    }
 

}
