//
//  UILabel.swift
//  Cities
//
//  Created by Владислав Казмирчук on 21.03.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setAnimated(text: String) {
        let animationDuratuin: TimeInterval = 0.17
        UIView.animate(withDuration: animationDuratuin, animations: {
            self.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        }) { (finish) in
            self.text = text
            UIView.animate(withDuration: animationDuratuin) {
                self.transform = .identity
            }
        }
    }
}
