//
//  WordsStackView.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/9/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class WordsStackView: UIView {

    private var isFirstSet = true
    
    let nibName = "WordsStack"
    var contentView: UIView?

    @IBOutlet weak var previousWord: UILabel!
    @IBOutlet weak var currentWord: UILabel!
    @IBOutlet weak var animatingMainLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        previousWord.text = ""
        currentWord.text = ""
        
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setNext(word: String) {
        guard !isFirstSet else { self.currentWord.text = word; isFirstSet = false; return }
        
        let currentWordColor = currentWord.textColor
        animatingMainLabel.text = word
        UIView.transition(with: currentWord, duration: 0.5, options: .transitionCrossDissolve, animations: {
            // Вся эта анимация очень жестко подогнана, любое изменение может привести к некорректному отображению
            self.previousWord.alpha = 0.0
            self.currentWord.textColor = self.previousWord.textColor
            self.currentWord.transform = CGAffineTransform(translationX: 0, y: -31).scaledBy(x: 0.82, y: 0.82)
            self.animatingMainLabel.transform = CGAffineTransform(translationX: 0, y: -40)
        }, completion: { (finish) in
            self.previousWord.text = self.currentWord.text
            self.previousWord.alpha = 1.0
            self.animatingMainLabel.transform = .identity
            self.currentWord.transform = .identity
            self.currentWord.text = word
            self.currentWord.textColor = currentWordColor
        })

    }

}
