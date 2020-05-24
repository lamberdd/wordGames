//
//  Player.swift
//  Cities
//
//  Created by Влад Казмирчук on 8/20/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

struct Player {
    var name: String
    var score: Int = 0
    var helps: Int
    var left = false
    var timeLeft: Int? = nil
    
    mutating func decrementHelps() {
        helps = (helps == 0) ? 0 : helps-1
    }
    
    mutating func incrementScore() {
        score = score+1
    }
}
