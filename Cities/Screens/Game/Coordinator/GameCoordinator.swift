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
    private var fullScreenAd: FullScreenAd? = nil
    var onCloseToMainScreen: (()->Void)? = nil
    
    deinit {
        print("Coordinator deinited")
    }
    
    init(prepareViewController: PrepareScreenViewController, gameSettings: GameInitialSettings) {
        self.prepareVC = prepareViewController
        self.gameSettings = gameSettings
    }
    
    private var presentedVC: UIViewController? {
        get {
            guard let gameView = gameView else { return nil }
            return gameView.presentedViewController ?? gameView
        }
    }
    
    func startGame() {
        let navigationController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GameView") as! UINavigationController
        gameView = navigationController.topViewController as! GameView
        gameView?.viewDidLoaded = {
            self.gameView?.controller = GameController(view: self.gameView!, gameSettings: self.gameSettings, coordinator: self)
        }
        fullScreenAd = FullScreenAd(rootViewController: gameView!)
        prepareVC.present(navigationController, animated: true, completion: nil)
    }
    
    func showAlreadyUsedWords(usedWords: [UsedWord]) {
        guard let usedWordsScreen = UIStoryboard(name: "AlreadyUsedWords", bundle: nil).instantiateInitialViewController() as? AlreadyUsedWordsViewController else { return }
        usedWordsScreen.update(usedWords: usedWords)
        gameView?.present(usedWordsScreen, animated: true)
    }
    
    func showNotFoundView(word: String, gameType: GameType, after time: TimeInterval, onAdd: @escaping ()->Void) {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { (t) in
            let notFoundVC = UIStoryboard(name: "NotExist", bundle: nil).instantiateInitialViewController() as! NotFoundViewController
            notFoundVC.onAddWord = onAdd
            self.gameView?.present(notFoundVC, animated: true, completion: nil)
            notFoundVC.setup(word: word, type: gameType)
        }
    }
    
    func showConfirmExit(onConfirm: (()->Void)?) {
        let viewController = UIStoryboard(name: "Confirm", bundle: nil).instantiateInitialViewController()
        guard let confirm = viewController as? ConfirmViewController else { return }
        confirm.set(title: translate("complete_game"), description: translate("are_you_sure_complete"))
        confirm.set(confirmTitle: translate("finish_game"), cancelTitle: nil)
        if let onConfirmFunc = onConfirm {
            confirm.onConfirm(onConfirmFunc)
        }
        confirm.onCancel { [weak confirm] in
            confirm?.dismiss(animated: true, completion: nil)
        }
        gameView?.present(confirm, animated: true)
    }
    
    func showGameScores(players: [Player], onContinue: @escaping ()->Void) {
        let scoresScreen = UIStoryboard(name: "Scores", bundle: nil).instantiateInitialViewController() as! ScoresViewController
        scoresScreen.playersArray = players
        scoresScreen.onContinue = onContinue
        if let presented = gameView?.presentedViewController {
            presented.dismiss(animated: true) {
                self.presentedVC?.present(scoresScreen, animated: true, completion: nil)
            }
        }
    }
    
    func showAlert(title: String, text: String, onContinue: @escaping ()->Void) {
        guard let alertScreen = UIStoryboard(name: "Alert", bundle: nil).instantiateInitialViewController() as? AlertViewController else { return }
        presentedVC?.present(alertScreen, animated: true, completion: nil)
        alertScreen.setup(title: title, text: text, callback: onContinue)
    }
    
    func closeGame() {
        gameView?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: { self.onCloseToMainScreen?()} )
    }
    
    func closeGameToPrepare() {
        gameView?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAd(onShow: (()->Void)?, onClose: (()->Void)?) {
        fullScreenAd?.show(onShow: onShow, onClose: onClose)
    }
}
