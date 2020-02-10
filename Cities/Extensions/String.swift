//
//  Strin.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/25/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    mutating func replace(symbols: [String], with char: String) {
        for symbol in symbols {
            self = self.replacingOccurrences(of: symbol, with: char)
        }
    }
}
