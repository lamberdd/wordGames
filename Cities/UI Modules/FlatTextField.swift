//
//  FlatTextField.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class FlatTextField: UITextField, UITextFieldDelegate {
    
    var underLine: UIView!
    var underLineColor = UIColor.gray
    let activeColor = Constants.colors.main
    var didChange: ((String?)->Void)?
    
    deinit {
        print("FlatTextField deinited")
    }
    
    override func awakeFromNib() {
        delegate = self
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.borderStyle = .none
        underLine = UIView()
        self.addSubview(underLine)
        
        underLine.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: underLine, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: underLine, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: underLine, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: underLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1.0)
            ])
        underLine.backgroundColor = underLineColor
    }
    
    func shake(underLineColor: UIColor) {
        underLine.backgroundColor = underLineColor
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.underLine.backgroundColor = self.isFirstResponder ? self.activeColor : UIColor.gray
        }
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        layer.add(animation, forKey: "position")
        
        CATransaction.commit()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underLineColor = activeColor
        underLine.backgroundColor = underLineColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        underLineColor = UIColor.gray
        underLine.backgroundColor = underLineColor
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        didChange?(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }

}
