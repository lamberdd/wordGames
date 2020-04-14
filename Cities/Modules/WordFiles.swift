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
                                    "countriesEn": "country_en.json", "countriesRu": "country_ru.json",
                                    "namesEn": "names_en.json", "namesRu": "names_ru.json",
                                    "chemElemsEn": "chemElems_en.json", "chemElemsRu": "chemElems_ru.json"]
    
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
        case .names:
            if gameLang == "ru" {
                return filePaths["namesRu"]!
            } else {
                return filePaths["namesEn"]!
            }
        case .chemElems:
            if gameLang == "ru" {
                return filePaths["chemElemsRu"]!
            } else {
                return filePaths["chemElemsEn"]!
            }
        default:
            return ""
        }
    }
}
