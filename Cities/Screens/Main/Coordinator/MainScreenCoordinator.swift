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
    
    init(viewController: MainScreenViewController) {
        self.mainVC = viewController
        
        viewController.presenter = MainScreenPresenter(view: viewController, coordinator: self)
    }
    
    func showBestScores(players: [Player]) {
        guard let scoresScreen = UIStoryboard(name: "Scores", bundle: nil).instantiateInitialViewController() as? ScoresViewController else { return }
        scoresScreen.playersArray = players
        scoresScreen.onContinue = { [weak scoresScreen] in
            scoresScreen?.dismissAnimation {
                scoresScreen?.dismiss(animated: true, completion: nil)
            }
        }
        mainVC.present(scoresScreen, animated: true, completion: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "cities":
            setupPrepareScreen(segue.destination, gameType: .city)
        case "countries":
            setupPrepareScreen(segue.destination, gameType: .country)
        default:
            print("Game undefined. Select cities")
        }
    }

    private func setupPrepareScreen(_ viewController: UIViewController, gameType: GameType) {
        guard let navigationPrepare = viewController as? UINavigationController else { return }
        guard let prepareScreen = navigationPrepare.topViewController as? PrepareScreenViewController else { return }
        prepareScreen.gameType = gameType
    }
}
