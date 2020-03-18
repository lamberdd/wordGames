//
//  GameController.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/24/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation
import UIKit

class GameController {
    
    private let computerName = translate("computer")
    
    unowned let view: GameViewProtocol
    unowned let gameCore: GameCore
    private let coordinator: GameCoordinator
    
    private let players: Players
    private var usedWords: [UsedWord]
    
    deinit {
        print("GameController deinited")
    }
    
    init(view: GameViewProtocol, players: [String], gameCore: GameCore, helpCount: Int, coordinator: GameCoordinator) {
        self.view = view
        self.gameCore = gameCore
        self.players = Players(players: players, helpCount: helpCount)
        self.coordinator = coordinator
        
        self.usedWords = []
        
        let randomWord = gameCore.getRandom()
        let lastLetter = gameCore.lastLetter().uppercased()
        
        addUsedWord(for: computerName)

        view.setBackgroundImage(GameImage.getFor(gameType: gameCore.type))
        view.setWord(randomWord)
        view.setLastLetter(lastLetter)
        view.setCurrentPlayer(name: self.players.current, score: self.players.scoreForCurrent())
        
        if helpCount == 0 {
            view.hideHelps()
            view.hideHelpsBlock()
        } else {
            view.setHelpsCount(helpCount)
        }
        if self.players.count == 1 {
            view.hideSkip()
        }
        
    }
    
    func answer(word: String) {
        guard word.count > 1 else {
            view.shakeErrorTextField()
            return
        }
        let status = gameCore.answer(word)
        if status == .success {
            successAnswer()
        } else if status == .alreadyUsed {
            view.animateAlreadyUsed()
        } else if status == .notFound {
            view.shakeErrorTextField()
            coordinator.showNotFoundView(word: word, gameType: gameCore.type, after: 0.2) { [weak self] in
                // Если нажал "Добавить"
                self?.gameCore.addUserWordAndAnswer(word)
                self?.successAnswer()
            }
        } else if status == .invalid {
            view.shakeErrorTextField()
        }
    }
    
    func skip() {
        players.nextPlayer()
        updateView(animateSuccess: false, updateWord: false)
    }
    
    func showUsedWords() {
        coordinator.showAlreadyUsedWords(usedWords: usedWords)
    }
    
    func exit() {
        
        coordinator.showConfirmExit(onConfirm: { [weak self] in
            if let players = self?.players, players.totalScore() > 0 {
                self?.coordinator.showGameScores(players: players.getPlayers()) {
                    if let core = self?.gameCore {
                        AppSettings.global.updateScores(for: core.type, players: players.getPlayers())
                    }
                    self?.coordinator.closeGame()
                }
            } else {
                self?.coordinator.closeGameToPrepare()
            }
        })
//        let titleSheet = NSLocalizedString("complete_game", comment: "")
//        let messageScheet = NSLocalizedString("are_you_sure_somplete", comment: "")
//        let destructiveText = NSLocalizedString("finish_game", comment: "")
//        let actionSheet = UIAlertController(title: titleSheet, message: messageScheet, preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: destructiveText, style: .destructive, handler: { [weak actionSheet] (action) in
//            actionSheet?.dismiss(animated: true, completion: nil)
//            guard self.players.totalScore() > 0 else {
//                self.view.closeView()
//                return
//            }
//            let scoresScreen = UIStoryboard(name: "Scores", bundle: nil).instantiateInitialViewController() as! ScoresViewController
//            scoresScreen.playersArray = self.players.getPlayers()
//            scoresScreen.onContinue = {
//                AppSettings.global.updateScores(for: self.gameCore.type, players: self.players.getPlayers())
//                self.view.closeGame()
//            }
//            self.view.present(scoresScreen)
//        }))
//        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { [weak actionSheet] (action) in
//            actionSheet?.dismiss(animated: true, completion: nil)
//        }))
//        view.present(actionSheet)
    }
    
    func help() {
        let lastLetter = gameCore.lastLetter()
        let helpWord = gameCore.generateWith(firstLetter: lastLetter, noSave: true)
        view.setTextField(word: helpWord)
        players.decrementHelpForCurrent()
        updateHelpButton()
    }
    
    private func successAnswer() {
        players.incrementCurrentScore()
        let currentSuccessWord = gameCore.current()
        addUsedWord(for: players.current)
        // Multiplayer
        let isMultiplayer = players.count > 1
        if isMultiplayer {
           players.nextPlayer()
        } else { // Single player
           let lastLetter = gameCore.lastLetter()
           let _ = gameCore.generateWith(firstLetter: lastLetter)
            addUsedWord(for: computerName)
        }
        if isMultiplayer {
            updateView(animateSuccess: true, updateWord: true)
        } else {
            view.setWord(currentSuccessWord) // Если играем с компьютером, то отображаем пользовательское слово, чтобы было видно что оно было введено
            self.updateView(animateSuccess: true, updateWord: false)
            //view.showLoaderIndicator() // Отображаем индикатор, что типо компьютер думает
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (timer) in
                self.view.hideLoaderIndicator()
                self.updateView(animateSuccess: false, updateWord: true)
            }
        }
    }
    
    func addUsedWord(for playerName: String) {
        self.usedWords.append(UsedWord(word: gameCore.current(), playerName: playerName))
    }
    
    private func updateView(animateSuccess: Bool, updateWord: Bool) {
        let curentWord = gameCore.current()
        let lastLetter = gameCore.lastLetter()
        
        view.setCurrentPlayer(name: players.current, score: players.scoreForCurrent())
        view.setLastLetter(lastLetter)
        if updateWord {
            view.setWord(curentWord)
        }
        if animateSuccess {
            view.animateSuccess()
        }
        updateHelpButton()
    }
    
    private func updateHelpButton() {
        let helpsCount = players.helpsForCurrent()
        if helpsCount <= 0 {
            view.hideHelps()
        } else {
            view.showHelps()
        }
        view.setHelpsCount(helpsCount)
    }
}
