//
//  MainScreenPresenter.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/28/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

class MainScreenPresenter {
    
    private let view: MainScreenViewProtocol
    private let coordinator: MainScreenCoordinator
    private let service: MainScreenService
    
    private var isFullVersion: Bool {
        return AppSettings.global.isFullVersion
    }
    private var availablePaidGame = false
    
    init(view: MainScreenViewProtocol, coordinator: MainScreenCoordinator, service: MainScreenService = MainScreenService()) {
        self.view = view
        self.coordinator = coordinator
        self.service = service
        
        update()
        coordinator.setUpdateHandler { [weak self] in
            self?.update()
        }
    }
    
    func update() {
        checkFullVersion()
    }
    
    //MARK: - Public methods
    
    func showBestScores() {
        let playerScores = service.getBestPlayerForAllGames()
        coordinator.showBestScores(bestPlayers: playerScores)
    }
    
    func firstnamesClick() {
        if isFullVersion {
            coordinator.prepareFirstnamesGame()
        } else {
            coordinator.openPurchaseScreen()
        }
    }
    
    func chemElemsClick() {
        if isFullVersion {
            coordinator.prepareChemElemsGame()
        } else {
            coordinator.openPurchaseScreen()
        }
    }
    
    
    //MARK: - Private methods
    private func checkFullVersion() {
        if isFullVersion == false {
            view.disablePaidGame()
            availablePaidGame = false
        } else {
            view.enablePaidGame()
            availablePaidGame = true
        }
    }
}
