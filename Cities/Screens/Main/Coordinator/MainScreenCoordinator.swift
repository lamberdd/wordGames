//
//  MainScreenCoordinator.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/28/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
import UIKit

class MainScreenCoordinator {
    
    private let mainVC: MainScreenViewController
    private var onUpdateScreen: (()->Void)? = nil
    private var prepareScreenCoordinator: PrepareScreenCoordinator? = nil
    
    init(viewController: MainScreenViewController) {
        self.mainVC = viewController
        
        viewController.presenter = MainScreenPresenter(view: viewController, coordinator: self)
    }
    
    func setUpdateHandler(_ handler: @escaping ()->Void) {
        onUpdateScreen = handler
    }
    
    func showBestScores(bestPlayers: [GameBestScoresModel]) {
        let gamesScoresVC = GameBestScoresVC.get(for: bestPlayers)
        
        let bestScores = BestScoresViewController()
        bestScores.gamesScores = gamesScoresVC
        mainVC.present(bestScores, animated: true, completion: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "cities":
            setupPrepareScreen(segue.destination, gameType: .cities)
        case "countries":
            setupPrepareScreen(segue.destination, gameType: .countries)
        case "names":
            setupPrepareScreen(segue.destination, gameType: .names)
        case "chemElems":
            setupPrepareScreen(segue.destination, gameType: .chemElems)
        case "buyFull":
            if let buyFullView = segue.destination as? BuyFullVersionView {
                buyFullView.onClose = onUpdateScreen
            }
        default:
            print("Game undefined. Select cities")
        }
    }
    
    func prepareFirstnamesGame() {
        mainVC.performSegue(withIdentifier: "names", sender: nil)
    }
    
    func prepareChemElemsGame() {
        mainVC.performSegue(withIdentifier: "chemElems", sender: nil)
    }
    
    func openPurchaseScreen() {
        mainVC.performSegue(withIdentifier: "buyFull", sender: nil)
    }

    private func setupPrepareScreen(_ viewController: UIViewController, gameType: GameType) {
        guard let navigationPrepare = viewController as? UINavigationController else { return }
        guard let prepareScreen = navigationPrepare.topViewController as? PrepareScreenViewController else { return }
        let prepareViewModel = PrepareScreenViewModel(gameType: gameType)
        prepareScreenCoordinator = PrepareScreenCoordinator(rootController: mainVC, prepareView: prepareScreen, viewModel: prepareViewModel)
        prepareScreenCoordinator?.onClose = { print("Prepare coordinator onClose"); self.prepareScreenCoordinator = nil }
        prepareScreen.viewModel = prepareViewModel
    }
}
