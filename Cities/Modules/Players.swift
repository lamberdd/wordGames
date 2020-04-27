//
//  Players.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/24/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

class Players {
    
    private var players: [Player] = []
    private var currentNumber = 0
    
    var isMultiplayer: Bool {
        get { players.count > 1 }
    }
    
    var count: Int {
        get {
            return players.count
        }
    }
    
    var current: String {
        get {
            return players[currentNumber].name
        }
    }
    
    init(players: [String], helpCount: Int = 0) {
        for playerName in players {
            let player = Player(name: playerName, score: 0, helps: helpCount)
            self.players.append(player)
        }
    }
    
    func scoreForCurrent() -> Int {
        return players[currentNumber].score
    }
    
    func incrementCurrentScore() {
        players[currentNumber].incrementScore()
    }
    
    func decrementHelpForCurrent() {
        players[currentNumber].decrementHelps()
    }
    
    func helpsForCurrent() -> Int {
        return players[currentNumber].helps
    }
    
    func nextPlayer() {
        let newNumber = currentNumber + 1
        if players.count == newNumber {
            currentNumber = 0
        } else {
            currentNumber = newNumber
        }
        if players[currentNumber].left && existActivePlayers() {
            nextPlayer()
        }
    }
    
    func leftCurrent() {
        players[currentNumber].left = true
    }
    
    func getPlayers() -> [Player] {
        return players
    }
    
    func totalScore() -> Int {
        var total = 0
        for player in players {
            total += player.score
        }
        return total
    }
    
    func existActivePlayers() -> Bool { // Остались ли игроки, которые не вылетели
        let activePlayer = players.first(where: { $0.left == false })
        return (activePlayer != nil)
    }
}
