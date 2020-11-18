//
//  SettingsView.swift
//  Cities
//
//  Created by Владислав Казмирчук on 13.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class SettingsView: UIViewController {
    
    let timeHelper = TimeStringHelper()

    @IBAction func onClose(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var keyboardHintsSwitch: UISwitch!
    @IBAction func kyeboardHintsSwitchOnChange(_ sender: UISwitch) {
        AppSettings.global.keyboardHints = sender.isOn
    }
    @IBOutlet weak var gameHintsStepper: UIStepper!
    
    @IBAction func gameHintsSteppChange(_ sender: UIStepper) {
        AppSettings.global.gameHints = Int(sender.value)
        updateGameHints()
    }
    @IBOutlet weak var gameHintsLabel: UILabel!
    
    @IBAction func clearScores(_ sender: UIButton) {
        AppSettings.global.clearBestScores()
        showAlert(text: translate("scores_cleared"))
    }
    
    @IBOutlet weak var answerTimeLabel: UILabel!
    @IBOutlet weak var answerTimeStepper: UIStepper!
    @IBAction func answerTimeStepChanged(_ sender: UIStepper) {
        AppSettings.global.answerTime = Int(sender.value*15)
        updateAnswerTime()
    }
    
    deinit {
        print("Settings ViewController deinited")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.title = translate("Settings")
        updateSettings()
        // Do any additional setup after loading the view.
    }
    
    private func updateSettings() {
        updateKeyboardHints()
        updateGameHints()
        updateAnswerTime()
    }
    
    private func updateKeyboardHints() {
        keyboardHintsSwitch.isOn = AppSettings.global.keyboardHints
    }
    
    private func updateGameHints() {
        let hintsCount = AppSettings.global.gameHints
        gameHintsStepper.value = Double(hintsCount)
        gameHintsLabel.text = String(hintsCount)
    }
    
    private func updateAnswerTime() {
        let answerTime = AppSettings.global.answerTime
        answerTimeLabel.text = timeHelper.toUserString(seconds: answerTime)
        answerTimeStepper.value = Double(answerTime/15)
        
    }
    
    private func showAlert(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: translate("Ok"), style: .default) { [weak alert] (action) in
            alert?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}
