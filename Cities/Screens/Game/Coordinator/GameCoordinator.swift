//
//  GameCoordinator.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/23/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
import UIKit

class GameCoordinator {
    
    private unowned let prepareVC: PrepareScreenViewController
    private let gameSettings: GameInitialSettings
    private weak var gameView: GameView? = nil
    
    deinit {
        print("Coordinator deinited")
    }
    
    init(prepareViewController: PrepareScreenViewController, gameSettings: GameInitialSettings) {
        self.prepareVC = prepareViewController
        self.gameSettings = gameSettings
    }
    
    func startGame() {
        let navigationController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameView") as! UINavigationController
        gameView = navigationController.topViewController as! GameView
        gameView?.viewDidLoaded = {
            self.gameView?.controller = GameController(view: self.gameView!, players: self.gameSettings.playerNames, gameCore: self.gameSettings.gameCore, helpCount: self.gameSettings.hintsCount, coordinator: self)
        }
        prepareVC.present(navigationController, animated: true, completion: nil)
    }
    
    func showAlreadyUsedWords(usedWords: [UsedWord]) {
        guard let usedWordsScreen = UIStoryboard(name: "AlreadyUsedWords", bundle: nil).instantiateInitialViewController() as? AlreadyUsedWordsViewController else { return }
        usedWordsScreen.update(usedWords: usedWords)
        gameView?.present(usedWordsScreen)
    }
}
