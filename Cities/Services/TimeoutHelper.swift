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
    private let timeStringHelper = TimeStringHelper()
    
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
        timeStringHelper.toUserString(seconds: timeLeft)
    }
}
