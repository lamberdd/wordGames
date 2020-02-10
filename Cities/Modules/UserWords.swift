//
//  UserWords.swift
//  Cities
//
//  Created by Влад Казмирчук on 11/28/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation

class UserWords {
    
    private let langDir = "ru"
    private let pathToCities = "cities.json"
    
    var wordsArray: [[String: String]]
    let fileUrl: URL
    
    init(gameType: GameType) {
        var filePath = ""
        switch gameType {
        case .city:
            filePath = pathToCities
        default:
            filePath = pathToCities
        }
        let fileManager = FileManager.default
        var wordFileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        wordFileUrl.appendPathComponent("\(langDir)")
        try? fileManager.createDirectory(atPath: wordFileUrl.path, withIntermediateDirectories: true, attributes: nil)
        wordFileUrl.appendPathComponent(filePath)
        
        fileUrl = wordFileUrl
        let isExist = fileManager.fileExists(atPath: wordFileUrl.path)
        if !isExist {
            do {
                try "[]".write(to: wordFileUrl, atomically: true, encoding: .utf8)
            } catch {
                print("Error write to file \(error)")
            }
            wordsArray = [[:]]
        } else {
            let fileData = try! Data(contentsOf: wordFileUrl)
            wordsArray = try! JSONSerialization.jsonObject(with: fileData, options: []) as! [[String: String]]
            print(wordsArray)
        }
    }
    
    func appendWord(_ object: [String: String]) {
        wordsArray.append(object)
        if let newFileData = try? JSONSerialization.data(withJSONObject: wordsArray, options: []) {
            try? newFileData.write(to: fileUrl)
        }
    }
}
