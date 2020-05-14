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
    
    private let timeout: TimeoutHelper
    private var timer: Timer? = nil
    
    deinit {
        print("GameController deinited")
    }
    
    init(view: GameViewProtocol, gameSettings: GameInitialSettings, coordinator: GameCoordinator) {
        self.view = view
        self.gameCore = gameSettings.gameCore
        self.players = Players(players: gameSettings.playerNames, helpCount: gameSettings.hintsCount)
        self.coordinator = coordinator
        
        self.usedWords = []
        self.timeout = TimeoutHelper(seconds: AppSettings.global.answerTime)
        
        let randomWord = gameCore.getRandom()
        let lastLetter = gameCore.lastLetter().uppercased()
        
        addUsedWord(for: computerName)

        view.setBackgroundImage(GameImage.getFor(gameType: gameCore.type))
        view.setWord(randomWord)
        view.setLastLetter(lastLetter)
        view.setCurrentPlayer(name: self.players.current, score: self.players.scoreForCurrent())
        view.setTextFieldAutocorrect(AppSettings.global.keyboardHints)
        
        if gameSettings.hintsCount == 0 {
            view.hideHelps()
            view.hideHelpsBlock()
        } else {
            view.setHelpsCount(gameSettings.hintsCount)
        }
        if self.players.count == 1 {
            view.hideSkip()
        }
        
        if gameSettings.timeGame {
            self.view.setTitle(text: timeout.userString, color: nil)
            setupTimer()
        }
        
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (t) in
            self?.timeout.decrement()
            guard let timeLeft = self?.timeout.time, let timeoutUserString = self?.timeout.userString else { return }
            let color = timeLeft < 8 ? UIColor.systemRed : nil
            self?.view.setTitle(text: timeoutUserString, color: color)
            if timeLeft == 0 {
                self?.leftCurrentPlayer()
                self?.timeout.reset()
            }
        }
    }
    
    private func leftCurrentPlayer() {
        players.leftCurrent()
        view.leftPlayer(name: players.current)
        if players.count == 1 || players.existActivePlayers() == false {
            timer?.invalidate()
            coordinator.showAlert(title: "Игра завершена", text: "Время ответа истекло") { [weak self] in
                self?.finishGame()
            }
        } else {
            players.nextPlayer()
            updateView(animateSuccess: false, updateWord: false)
        }
    }
    
    func answer(word: String) {
        guard word.count > 1 else {
            view.shakeErrorTextField()
            return
        }
        let status = gameCore.answer(word)
        if status == .success {
            timeout.reset()
            timer?.fire() // Обновляем таймер
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
            self?.finishGame()
        })
        
    }
    
    private func finishGame() {
        if players.totalScore() > 0 {
            self.coordinator.showGameScores(players: players.getPlayers()) { [weak self] in
                if let core = self?.gameCore, let players = self?.players {
                    AppSettings.global.updateScores(for: core.type, players: players.getPlayers())
                }
                self?.coordinator.closeGame()
            }
        } else {
            coordinator.closeGameToPrepare()
        }
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
        let isMultiplayer = players.isMultiplayer
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
        
        if players.isMultiplayer { view.setCurrentPlayer(name: players.current, score: players.scoreForCurrent()) }
        view.setLastLetter(lastLetter)
        if let changeLetter = gameCore.getChagedLastLetter() {
            saveReplaceableLastLetter(letterInfo: changeLetter)
            setupReplaceableLastLetter()
            view.changeLetterButtonVisible = true
        } else { view.changeLetterButtonVisible = false }
        if updateWord {
            view.setWord(curentWord)
        }
        if animateSuccess {
            view.animateSuccess()
        }
        updateHelpButton()
    }
    
    func changeLetter() {
        guard let from = fromLetter, let to = toLetter else { return }
        view.setLastLetter(to)
        if initialLastLetter == from {
            gameCore.setReplaceableLastLetter()
        } else if initialLastLetter == to {
            gameCore.resetLastLetter()
        }
        fromLetter = to
        toLetter = from
        setupReplaceableLastLetter()
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
    
    private var initialLastLetter: String? = nil
    private var fromLetter: String? = nil
    private var toLetter: String? = nil
    private func saveReplaceableLastLetter(letterInfo: (from: String, to: String)?) {
        guard let letterInfo = letterInfo else { fromLetter = nil; toLetter = nil; return }
        fromLetter = letterInfo.from;
        initialLastLetter = fromLetter
        toLetter = letterInfo.to
    }
    
    private func setupReplaceableLastLetter() {
        guard let from = fromLetter, let to = toLetter else { return }
        let newTitle = "\(from)→\(to)"
        view.setChangeLetterTitle(newTitle)
    }
}
