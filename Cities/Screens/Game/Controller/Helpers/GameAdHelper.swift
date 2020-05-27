//
//  GameAdHelper.swift
//  Cities
//
//  Created by Владислав Казмирчук on 26.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

class GameAdHelper {
    
    let numberClicksToShow = 17
    var clicksCount = 0
    
    weak var coordinator: GameCoordinator?
    
    init(gameCoordinator: GameCoordinator) {
        coordinator = gameCoordinator
    }
    
    func showIfNeeded(onShow: (()->Void)?, onClose: (()->Void)?) {
        Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { [weak self] (t) in
            self?.clicksCount += 1
            guard let clicksCount = self?.clicksCount, let numberClicksToShow = self?.numberClicksToShow else { return }
            if clicksCount >= numberClicksToShow {
                self?.coordinator?.showAd(onShow: onShow, onClose: onClose)
                self?.clicksCount = 0
            }
        }
    }
}
