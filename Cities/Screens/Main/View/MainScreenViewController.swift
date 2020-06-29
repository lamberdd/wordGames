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
    @IBOutlet weak var firstnameGameIcon: MenuButton!
    @IBOutlet weak var chemElemsGameIcon: MenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = MainScreenCoordinator(viewController: self)
    }
    
    @IBAction func firsnamesClick(_ sender: UIButton) {
        presenter?.firstnamesClick()
    }
    @IBAction func chemElemsClick(_ sender: UIButton) {
        presenter?.chemElemsClick()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        coordinator?.prepare(for: segue)
    }
    
    @IBAction func showBestScores(_ sender: UIButton) {
        presenter?.showBestScores()
    }
    
    func disablePaidGame() {
        firstnameGameIcon.alpha = 0.5
        chemElemsGameIcon.alpha = 0.5
    }
    
    func enablePaidGame() {
        firstnameGameIcon.alpha = 1.0
        chemElemsGameIcon.alpha = 1.0
    }
    
}
