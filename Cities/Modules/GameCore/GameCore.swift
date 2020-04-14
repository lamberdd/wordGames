//
//  GameCore.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

enum GameType: String, CaseIterable {
    case cities, countries, names, chemElems
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
        return current()
    }
    
    func generateWith(firstLetter: String, noSave: Bool = false) -> String {
        let filterWords = arrayHelper.filter(words: words, firstLetter: firstLetter)
        let obj = arrayHelper.getRandom(words: filterWords, exclude: used)
        if !noSave {
            used.append(obj)
            if let deleteIndex = words.firstIndex(where: { $0["search"] == obj["search"] }) {
                words.remove(at: deleteIndex)
            }
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
        let last = lastLetter().lowercased().last
        if search.first != last && last != nil {
            if replaceableLetter[String(last!)] == nil {
                return .invalid
            }
        }
        for userWord in used {
            if userWord["search"] == search {
                return .alreadyUsed
            }
        }
        for index in 0...words.count-1 {
            let obj = words[index]
            if search == obj["search"] {
                updateCurrentWord(object: obj)
                self.words.remove(at: index) // Удаляем слово, т.к оно больше не нужно для поиска
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
        var name = currentWord["name"] ?? ""
        if let description = currentWord["description"] {
            name.append(" \(description)")
        }
        return name
    }
    
    private let replaceableLetter = ["й":"и", "ё":"е"]
    
    func getChagedLastLetter() -> (from: String, to: String)? {
        let allowChange = getAllowChangeLetter()
        if let key = allowChange?.key, let value = allowChange?.value {
            return (key.uppercased(), value.uppercased())
        }
        return nil
    }
    
    private var startedLastLetter: String? = nil
    func setReplaceableLastLetter() {
        startedLastLetter = lastLetter()
        currentWord["lastLetter"] = replaceableLetter[startedLastLetter!]
    }
    func resetLastLetter() {
        currentWord["lastLetter"] = startedLastLetter
    }
    
    private func getAllowChangeLetter() -> (key: String, value: String?)? {
        let letter = lastLetter()
        return replaceableLetter.first(where: { $0.key == letter })
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
        
        var isCorrect = true
        isCorrect = arrayHelper.existWordWith(firstLetter: letter, in: words)
        
        return isCorrect
    }
}
