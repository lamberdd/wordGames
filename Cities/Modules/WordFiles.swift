//
//  WordFiles.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/8/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

class WordFiles {
    
    private static let filePaths = ["citiesEn": "cities_en.json", "citiesRu": "cities.json",
                                    "countriesEn": "country_en.json", "countriesRu": "country_ru.json"]
    
    static func getPathForCurrentLang(gameType: GameType) -> String {
        let gameLang = Locale.current.languageCode ?? "en"
        switch gameType {
        case .cities:
            if gameLang == "ru" {
                return filePaths["citiesRu"]!
            } else {
                return filePaths["citiesEn"]!
            }
        case .countries:
            if gameLang == "ru" {
                return filePaths["countriesRu"]!
            } else {
                return filePaths["countriesEn"]!
            }
        default:
            return ""
        }
    }
}
