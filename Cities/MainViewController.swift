//
//  ViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/21/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 30, y: 30, width: 100, height: 100))
        button.setImage(UIImage(named: "cities"), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 50.0
        
        //view.addSubview(button)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

