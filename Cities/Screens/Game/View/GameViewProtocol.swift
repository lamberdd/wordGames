//
//  GameViewProtocol.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/24/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import Foundation
import UIKit

protocol GameViewProtocol: class {
    func setCurrentPlayer(name: String, score: Int)
    func setWord(_ word: String)
    func setLastLetter(_ letter: String)
    func setTitle(text: String, color: UIColor?)
    func animateSuccess()
    func leftPlayer(name: String)
    func animateAlreadyUsed(gameType: GameType)
    func shakeErrorTextField()
    func showLoaderIndicator()
    func hideLoaderIndicator()
    func hideHelps()
    func showHelps()
    func hideSkip()
    func hideHelpsBlock()
    func setHelpsCount(_ count: Int)
    func setTextField(word: String)
    func setBackgroundImage(_ image: UIImage)
    func setChangeLetterTitle(_ title: String)
    func setTextFieldAutocorrect(_ enable: Bool)
    var changeLetterButtonVisible: Bool { get set }
}
