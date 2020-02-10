//
//  AppSettings.swift
//  Cities
//
//  Created by Влад Казмирчук on 8/20/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

class AppSettings {
    
    static let global = AppSettings()
    let defaults = UserDefaults.standard
    
    private init() {}
    
    let defaultHelpCount = 3
    
    func getHelpCount() -> Int {
        let helpCount = defaults.integer(forKey: "helpCount")
        guard helpCount != 0 else {
            defaults.set(defaultHelpCount, forKey: "helpCount")
            return defaultHelpCount
        }
        return helpCount
    }
    
    private let scoreStorageName = "top5scores"
    private let maxScores = 5
    
    func updateScores(for players: [Player]) {
        var sortedPlayers = players.sorted { $0.score > $1.score }
        var storedScores: [String: Int] = (defaults.dictionary(forKey: scoreStorageName) as? [String: Int]) ?? [:]
        
        if storedScores.count < maxScores {
            var addedPlayers: Int = 0
            for player in sortedPlayers {
                storedScores[player.name] = player.score
                addedPlayers += 1
                if storedScores.count >= maxScores { break; }
            }
            for _ in 0..<addedPlayers {
                sortedPlayers.remove(at: 0)
            }
        }
        for newPlayer in sortedPlayers {
            var nameWithMinimalScore: String? = nil
            for (name, score) in storedScores {
                if newPlayer.score >= score {
                    if nameWithMinimalScore == nil {
                        nameWithMinimalScore = name;
                    } else if (storedScores[nameWithMinimalScore!] ?? 0) > score {
                        nameWithMinimalScore = name
                    }
                }
            }
            if let removeName = nameWithMinimalScore {
                storedScores.removeValue(forKey: removeName)
                storedScores[newPlayer.name] = newPlayer.score
            }
        }
        
        defaults.set(storedScores, forKey: scoreStorageName)
    }
    
    func getBestScores() -> [Player] {
        let scores = (defaults.dictionary(forKey: scoreStorageName) as? [String: Int]) ?? [:]
        var players: [Player] = []
        for (name, score) in scores {
            players.append(Player(name: name, score: score, helps: 0))
        }
        return players
    }
}
