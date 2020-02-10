//
//  GameImage.swift
//  Cities
//
//  Created by Влад Казмирчук on 2/7/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
import UIKit

class GameImage {
    private static let images: [GameType: String] = [.city: "cities", .country: "countries"]
    private static let defaultImage = UIImage()
    
    static func getFor(gameType: GameType) -> UIImage {
        guard let imageName = images[gameType] else { return defaultImage }
        return UIImage(named: imageName) ?? defaultImage
    }
}
