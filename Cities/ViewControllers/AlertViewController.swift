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
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func onContinue(_ sender: UIButton) {
        callback?()
    }
    
    override func viewDidLoad() {
        continueButton.setTitle(translate("continue"), for: .normal)
    }
    
    var continueCallback: (()->Void)? = nil
    
    func setup(title: String, text: String, callback: @escaping ()->Void) {
        titleLabel.text = title
        textLabel.text = text
        self.callback = callback
    }
}

