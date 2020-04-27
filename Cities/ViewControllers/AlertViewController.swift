//
//  AlertViewController.swift
//  Cities
//
//  Created by Владислав Казмирчук on 21.04.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class AlertViewController: BlackoutViewController {
    
    var callback: (()->Void)? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBAction func onContinue(_ sender: UIButton) {
        callback?()
    }
    
    var continueCallback: (()->Void)? = nil
    
    func setup(title: String, text: String, callback: @escaping ()->Void) {
        titleLabel.text = title
        textLabel.text = text
        self.callback = callback
    }
}

