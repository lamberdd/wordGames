//
//  TimeStringer.swift
//  Cities
//
//  Created by Владислав Казмирчук on 14.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

class TimeStringHelper {
    
    func toUserString(seconds: Int) -> String {
        if seconds > 59 {
            let minutes = seconds/60
            let seconds = seconds - (minutes*60)
            return "\(minutes):\(doubleSeconds(seconds))"
        } else {
            return "0:\(doubleSeconds(seconds))"
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
