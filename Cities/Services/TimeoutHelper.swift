//
//  TimeoutHelper.swift
//  Cities
//
//  Created by Владислав Казмирчук on 15.04.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

class TimeoutHelper {
    
    private let timeout: Int
    private var timeLeft: Int
    
    init(seconds: Int) {
        self.timeout = seconds
        self.timeLeft = self.timeout
    }
    
    func decrement() {
        if timeLeft > 0 {
            timeLeft -= 1
        }
    }
    
    func reset() {
        timeLeft = timeout
    }
    
    var time: Int {
        return timeLeft
    }
    
    var userString: String {
        if timeLeft > 59 {
            let minutes = timeLeft/60
            let seconds = timeLeft - (minutes*60)
            return "\(minutes):\(doubleSeconds(seconds))"
        } else {
            return "0:\(doubleSeconds(timeLeft))"
        }
    }
    
    private func doubleSeconds(_ seconds: Int) -> String {
        if seconds > 9 && seconds > 0 {
            return String(seconds)
        } else {
            return "0\(seconds)"
        }
    }
}
