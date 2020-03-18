//
//  BlackoutViewController.swift
//  Cities
//
//  Created by Владислав Казмирчук on 17.03.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class BlackoutViewController: UIViewController {
    
    private let animDuration: TimeInterval = 0.25
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: animDuration) {
            self.view.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 0.55)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: animDuration, animations: {
            self.view.backgroundColor = UIColor.clear
        }) { (_) in
            super.dismiss(animated: flag, completion: completion)
        }
    }
}
