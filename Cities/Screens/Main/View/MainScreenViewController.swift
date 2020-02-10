//
//  MainScreenViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/28/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, MainScreenViewProtocol {
    
    var presenter: MainScreenPresenter? = nil
    private var coordinator: MainScreenCoordinator? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator = MainScreenCoordinator(viewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        coordinator?.prepare(for: segue)
    }
    
    @IBAction func showBestScores(_ sender: UIButton) {
        presenter?.showBestScores()
    }
    
}
