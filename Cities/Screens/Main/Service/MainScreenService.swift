//
//  MainScreenService.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/28/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

enum compass: CaseIterable {
    case north, south, eath
}

class MainScreenService {
    
    func getBestPlayerForAllGames() -> [GameBestScoresModel] {
        let appSettings = AppSettings.global
        var result: [GameBestScoresModel] = []
        for game in GameType.allCases {
            let bestPlayer = appSettings.getBestScores(for: game)
            result.append(GameBestScoresModel(gameType: game, players: bestPlayer))
        }
        
        return result
        
        /*let bestPlayers = AppSettings.global.getBestScores()
        if bestPlayers.count == 0 { return [:] }
        let sortedBestPlayers = bestPlayers.sorted(by: { $0.score > $1.score })
        return sortedBestPlayers*/
    }
}
