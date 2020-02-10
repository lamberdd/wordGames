//
//  MainScreenService.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/28/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

class MainScreenService {
    
    func getBestPlayer() -> [Player] {
        let bestPlayers = AppSettings.global.getBestScores()
        if bestPlayers.count == 0 { return [] }
        let sortedBestPlayers = bestPlayers.sorted(by: { $0.score > $1.score })
        return sortedBestPlayers
    }
}
