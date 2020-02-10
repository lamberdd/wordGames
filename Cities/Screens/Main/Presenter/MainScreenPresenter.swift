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
    
    init(view: MainScreenViewProtocol, coordinator: MainScreenCoordinator, service: MainScreenService = MainScreenService()) {
        self.view = view
        self.coordinator = coordinator
        self.service = service
    }
    
    //MARK: - Public methods
    
    func showBestScores() {
        let playerScores = service.getBestPlayer()
        coordinator.showBestScores(players: playerScores)
    }
}
