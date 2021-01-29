//
//  MainScreenCoordinatorMock.swift
//  CitiesTests
//
//  Created by Владислав Казмирчук on 28.01.2021.
//  Copyright © 2021 Влад Казмирчук. All rights reserved.
//

import Foundation
@testable import Cities

class MainScreenCoordinatorMock: MainScreenCoordinator {
    var showBestScores = false
    var bestScores: [GameBestScoresModel] = []
    
    var prepareFirstnames = false
    var prepareChemElems = false
    var purchaseScreenOpen = false
    
    var updateHandler: (()->Void)? = nil
    
    
    
    override func showBestScores(bestPlayers: [GameBestScoresModel]) {
        showBestScores = true
        self.bestScores = bestPlayers
    }
    
    override func openPurchaseScreen() {
        purchaseScreenOpen = true
    }
    
    override func setUpdateHandler(_ handler: @escaping () -> Void) {
        updateHandler = handler
    }
    
    override func prepareFirstnamesGame() {
        self.prepareFirstnames = true
    }
    
    override func prepareChemElemsGame() {
        self.prepareChemElems = true
    }
}
