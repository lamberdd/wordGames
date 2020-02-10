//
//  GameCore.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

enum GameType: String {
    case city, country
}

enum AnswerType {
    case notFound, alreadyUsed, invalid, success
}

class GameCore {
    
    let type: GameType
    
    private var words: [[String: String]]
    private var used: [[String: String]] = []
    private var currentWord: [String: String] = [:]
    private let arrayHelper: ArrayHelper
    private let userWords: UserWords
    
    init(type: GameType) {
        self.type = type
        let fileBundle = Bundle.main.url(forResource: WordFiles.getPathForCurrentLang(gameType: type), withExtension: nil)
        let dataCitiesFile = try! Data(contentsOf: fileBundle!)
        words = (try? JSONSerialization.jsonObject(with: dataCitiesFile, options: []) as? [[String: String]]) ?? []
            
        userWords = UserWords(gameType: type)
        arrayHelper = ArrayHelper()
    }
    
    deinit {
        print("Game Core deinited")
    }
    
    func getRandom() -> String {
        let obj = arrayHelper.getRandom(words: words, exclude: used)
        used.append(obj)
        currentWord = obj
        return obj["name"]!
    }
    
    func generateWith(firstLetter: String, noSave: Bool = false) -> String {
        let filterWords = arrayHelper.filter(words: words, firstLetter: firstLetter)
        let obj = arrayHelper.getRandom(words: filterWords, exclude: used)
        if !noSave {
            used.append(obj)
            currentWord = obj
        }
        return obj["name"]!
        
    }
    
    func lastLetter() -> String {
        guard currentWord["lastLetter"] == nil else {
            return currentWord["lastLetter"]!
        }
        let nowWord = currentWord["search"]!
        var lastLetter = String(nowWord.last!)
        var valid = isCorrectLetter(lastLetter)
        if !valid {
            for i in (0...(nowWord.count-2)).reversed() {
                let newLastLetter = String(nowWord[i])
                if isCorrectLetter(newLastLetter) {
                    lastLetter = newLastLetter
                    break
                }
            }
        }
        currentWord["lastLetter"] = lastLetter
        return lastLetter
    }
    
    func answer(_ word: String) -> AnswerType {
        let search = createSearchWord(from: word)
        if search.first != lastLetter().lowercased().last {
            return .invalid
        }
        for userWord in used {
            if userWord["search"] == search {
                return .alreadyUsed
            }
        }
        for obj in words { // Ищем в основных словах
            if search == obj["search"] {
                updateCurrentWord(object: obj)
                return .success
            }
        }
        for obj in userWords.wordsArray { // Ищем в пользовательских словах
            if search == obj["search"] {
                updateCurrentWord(object: obj)
                return .success
            }
        }
        return .notFound
    }
    
    func addUserWordAndAnswer(_ word: String) {
        let search = createSearchWord(from: word)
        let object = ["name": word, "search": search]
        userWords.appendWord(object)
        updateCurrentWord(object: object)
    }
    
    func current() -> String {
        return currentWord["name"]!
    }
    
    private func updateCurrentWord(object: [String: String]) {
        used.append(object)
        currentWord = object
    }
    
    private func createSearchWord(from word: String) -> String {
        var search = word.lowercased()
        search.replace(symbols: [" ", "-", "_", "'"], with: "")
        return search
    }
    
    private func isCorrectLetter(_ letter: String) -> Bool {
        let invalidLetters = ["ы","ь","ъ"]
        var isValid = true
        for invalidLetter in invalidLetters {
            if invalidLetter == letter {
                isValid = false
                break
            }
        }
        return isValid
    }
}
