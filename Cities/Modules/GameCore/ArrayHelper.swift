//
//  ArrayHelper.swift
//  Cities
//
//  Created by Влад Казмирчук on 8/13/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

class ArrayHelper {

    func getRandom(words: [[String: String]], exclude: [[String: String]]) -> [String: String] {
        let countElems = words.count
        var finish = false
        var usedNumbers: [Int] = []
        var foundItem: [String: String] = [:]
        while !finish {
            let random = Int.random(in: 0..<countElems)
            foundItem = words[random]
            var alreadyInclude = false
            for elem in exclude {
                if elem["name"] == foundItem["name"] {
                    alreadyInclude = true
                    break
                }
            }
            if !alreadyInclude {
                finish = true
            }
        }
        return foundItem
    }
    
    func filter(words: [[String: String]], firstLetter: String) -> [[String: String]] {
        let newWords = words.filter({ $0["search"]?.first?.description == firstLetter })
        return newWords
    }
}
