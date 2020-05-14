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
    
    private let scoreStorageName = "top5scores"
    private let maxScores = 5
    
    private func scoreStoreName(_ game: GameType) -> String {
        return "\(game)_\(scoreStorageName)"
    }
    
    func updateScores(for game: GameType, players: [Player]) {
        var sortedPlayers = players.sorted { $0.score > $1.score }
        var storedScores: [String: Int] = (defaults.dictionary(forKey: scoreStoreName(game)) as? [String: Int]) ?? [:]
        
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
        
        defaults.set(storedScores, forKey: scoreStoreName(game))
    }
    
    func getBestScores(for game: GameType) -> [Player] {
        let scores = (defaults.dictionary(forKey: scoreStoreName(game)) as? [String: Int]) ?? [:]
        var players: [Player] = []
        for (name, score) in scores {
            players.append(Player(name: name, score: score, helps: 0))
        }
        return players
    }
    
    func clearBestScores() {
        GameType.allCases.forEach { (type) in
            defaults.set([:], forKey: scoreStoreName(type))
        }
    }
    
    private let keyboardHintsDefaultEnabled = true
    private let keyboardHintsKey = "keyboardHintsEnabled"
    
    var keyboardHints: Bool {
        get {
            let hints = defaults.integer(forKey: keyboardHintsKey)
            if hints == 0 {
                initKeyboardHints()
                return keyboardHintsDefaultEnabled
            } else {
                return (hints == 1)
            }
        }
        set {
            let value = newValue ? 1 : 2
            defaults.set(value, forKey: keyboardHintsKey)
        }
    }
    
    private func initKeyboardHints() {
        let defaultValue = keyboardHintsDefaultEnabled ? 1 : 2
        defaults.set(defaultValue, forKey: keyboardHintsKey)
    }
    
    
    private let gameHintsDefaultValue = 3
    private let gameHintsKey = "gameHintsCount"
    
    var gameHints: Int {
        get {
            let hints = defaults.integer(forKey: gameHintsKey)
            if hints == 0 {
                initKeyboardHints()
                return gameHintsDefaultValue
            } else {
                return hints
            }
        }
        set {
            defaults.set(newValue, forKey: gameHintsKey)
        }
    }
    
    private func initGameHints() {
        defaults.set(gameHintsDefaultValue, forKey: gameHintsKey)
    }
    
    private let answerTimeDefaultValue: Int = 60
    private let answerTimeKey = "answerTime"
    
    var answerTime: Int {
        get {
            let time = defaults.integer(forKey: answerTimeKey)
            if time == 0 {
                initAnswerTime()
                return answerTimeDefaultValue
            } else {
                return time
            }
        }
        set {
            defaults.set(newValue, forKey: answerTimeKey)
        }
    }
    
    func initAnswerTime() {
        defaults.set(answerTimeDefaultValue, forKey: answerTimeKey)
    }
}
