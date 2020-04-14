//
//  GameView.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class GameView: UIViewController, GameViewProtocol {

    @IBAction func exit(_ sender: UIBarButtonItem) {
        controller.exit()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender.text!.count == 0 {
            sender.text = lastLetter
        }
    }
    @IBAction func answer(_ sender: UIButton) {
        controller.answer(word: textField.text!)
    }
    @IBAction func onSkip(_ sender: UIButton) {
        controller.skip()
    }
    @IBAction func onHelp(_ sender: UIBarButtonItem) {
        controller.help()
    }
    @IBAction func showUsedWords(_ sender: UIButton) {
        controller.showUsedWords()
    }
    @IBAction func onChangeLetter(_ sender: UIButton) {
        controller.changeLetter()
    }
    
    @IBOutlet weak var wordsStack: WordsStackView!
    
    @IBOutlet weak var titleGame: UILabel!
    @IBOutlet weak var textInfo: UILabel!
    @IBOutlet weak var textField: FlatTextField!
    @IBOutlet weak var changeLetterButton: UIButton!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var helpsBlock: UIView!
    @IBOutlet weak var helpCount: UILabel!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var checkmarkView: CheckmarkView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageLeading: NSLayoutConstraint!
    @IBOutlet weak var backgoundImageTrailing: NSLayoutConstraint!
    
    var viewDidLoaded: (()->Void)? = nil
    var controller: GameController!
    
    private var players: Players!
    private var lastLetter: String = ""
    private var backgroundShifted = true
    private var notification: Notification!
    
    deinit {
        print("GameView deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem?.setTextFontToDefault()
        navigationItem.rightBarButtonItem?.setTextFontToDefault()
        
        viewDidLoaded?()
        changeLetterButtonVisible = false
        backgroundImageLeading.constant = -35
        backgoundImageTrailing.constant = 35
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notification = Notification(viewController: self)
    }
    
    //MARK: View protocol
    func setCurrentPlayer(name: String, score: Int) {
        playerNameLabel.setAnimated(text: name)
        self.score.text = String(score)
    }
    
    func setWord(_ word: String) {
//        titleGame.text = word
        wordsStack.setNext(word: word)
    }
    
    func setLastLetter(_ letter: String) {
        lastLetter = letter.uppercased()
        textInfo.text = "\(NSLocalizedString("you_on", comment: "")) '\(lastLetter)'"
        textField.text = lastLetter
    }
    
    func setChangeLetterTitle(_ title: String) {
        changeLetterButton.setTitle(title, for: .normal)
    }
    
    var changeLetterButtonVisible: Bool {
        get { changeLetterButton.alpha > 0.0 }
        set { changeLetterButton.alpha = newValue ? 1.0 : 0.0 }
    }
    
    func showLoaderIndicator() {
        loaderIndicator.startAnimating()
    }
    
    func hideLoaderIndicator() {
        loaderIndicator.stopAnimating()
    }
    
    func animateSuccess() {
        if backgroundShifted {
            backgroundImageLeading.constant = 35
            backgoundImageTrailing.constant = -35
        } else {
            backgroundImageLeading.constant = -35
            backgoundImageTrailing.constant = 35
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        checkmarkView.show(animate: true)
        backgroundShifted.toggle()
    }
    
    func animateAlreadyUsed() {
        textField.shake(underLineColor: Constants.colors.warning)
        notification.show(text: "Такой город уже был назван", image: NotificationImages.alreadyUsed)
    }
    
    func shakeErrorTextField() {
        textField.shake(underLineColor: Constants.colors.error)
    }
    
    func setTextField(word: String) {
        textField.text = word
    }
    
    func hideHelps() {
        helpButton.isEnabled = false
    }
    
    func showHelps() {
        helpButton.isEnabled = true
    }
    
    func hideSkip() {
        skipButton.isHidden = true
    }
    
    func hideHelpsBlock() {
        helpsBlock.isHidden = true
    }
    
    func setHelpsCount(_ count: Int) {
        helpCount.text = String(count)
    }
    
    func setBackgroundImage(_ image: UIImage) {
        backgroundImage.image = image
    }
    

}
