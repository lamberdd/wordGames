//
//  PrepareScreenViewModel.swift
//  Cities
//
//  Created by Владислав Казмирчук on 10.11.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PrepareScreenViewModel {

    private let bag = DisposeBag()
    
    private var playersName = [translate("player")+" 1"]
    
    private var playersRelay: BehaviorRelay<[String]>!
    private var gameTypeRelay = BehaviorRelay<GameType>(value: .cities)
    private var startButtonRelay = BehaviorRelay<Bool>(value: true)
    
    //Events
    private let _didClose = PublishRelay<Void>()
    var didClose: Observable<Void> { return _didClose.asObservable() }
    
    private let _didStartGame = PublishRelay<GameInitialSettings>()
    var didStartGame: Observable<GameInitialSettings> { return _didStartGame.asObservable() }
    
    //Input
    let countPlayers = BehaviorRelay<Double>(value: 1)
    let changedPlayerName = PublishRelay<[Int: String]>()
    let startClick = PublishRelay<Void>()
    let hintEnable = BehaviorRelay<Bool>(value: true)
    let timeGameEnable = BehaviorRelay<Bool>(value: true)
    let exit = PublishRelay<Void>()
    
    //Output
    var players: Driver<[String]>!
    var gameType: Driver<GameType>!
    var startButtonEnabled: Driver<Bool>!
    
    deinit {
        print("Prepare screen ViewModel deinited")
    }
    init(gameType: GameType) {
        gameTypeRelay.accept(gameType)
        setup()
    }
    
    private func setup() {
        playersRelay = BehaviorRelay<[String]>(value: playersName)
        players = playersRelay.asDriver()
        
        gameType = gameTypeRelay.asDriver()
        startButtonEnabled = startButtonRelay.asDriver()
        
        handleCountPlayers()
        handleChangePlayerName()
        handleStart()
        handleExit()
    }
    
    private func handleCountPlayers() {
        countPlayers.subscribe(onNext: { [weak self] value in
            guard let currentPlayersCount = self?.playersName.count else { return }
            let newCount = Int(value)
            if newCount > currentPlayersCount {
                self?.playersName.append(translate("player")+" \(newCount)")
            } else {
                self?.playersName.removeLast()
            }
            if self?.playersName != nil {
                self?.playersRelay.accept(self!.playersName)
            }
            print("count players is \(value)")
        }).disposed(by: bag)
    }
    
    private func handleChangePlayerName() {
        changedPlayerName.subscribe(onNext: { [weak self] value in
            guard let row = value.keys.first, let newName = value.first?.value else { return }
            self?.playersName[row] = newName
            self?.updateStartButtonState()
        }).disposed(by: bag)
    }
    
    private func handleStart() {
        startClick.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let gameCore = GameCore(type: self.gameTypeRelay.value)
            let helpCount = self.hintEnable.value ? AppSettings.global.gameHints : 0
            //TODO: Continue Game Coordinator
            let gameSettings = GameInitialSettings(playerNames: self.playersName, gameCore: gameCore, hintsCount: helpCount, timeGame: self.timeGameEnable.value)
            self._didStartGame.accept(gameSettings)
        }).disposed(by: bag)
    }
    
    private func handleExit() {
        exit.bind(to: _didClose).disposed(by: bag)
    }
    
    private func updateStartButtonState() {
        let existEmptyName = playersName.filter({ $0.count == 0 })
        if existEmptyName.count > 0 {
            startButtonRelay.accept(false)
        } else {
            startButtonRelay.accept(true)
        }
    }
    
}
