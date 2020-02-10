//
//  UIBarButtonItem.swift
//  Cities
//
//  Created by Влад Казмирчук on 12/2/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    func setTextFont(family: String, size: CGFloat) {
        var attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: family, size: size),
        ]
        self.setTitleTextAttributes(attributes, for: .normal)
        self.setTitleTextAttributes(attributes, for: .highlighted)
        self.setTitleTextAttributes(attributes, for: .disabled)
    }
    
    func setTextFontToDefault() {
        self.setTextFont(family: Constants.font.family, size: Constants.font.barButtonSize)
    }
}
