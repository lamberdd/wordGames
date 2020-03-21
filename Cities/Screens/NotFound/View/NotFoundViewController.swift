//
//  AlreadyUsedViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 10/8/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit
import SafariServices

class NotFoundViewController: UIViewController {

    public var onAddWord: (()->Void)? = nil
    
    private var gameType: GameType = .cities
    
    @IBOutlet weak var wordName: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBAction func checkInInternet(_ sender: UIButton) {
        guard let percentageWordString = wordName.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let searchUrl = URL(string: "https://google.com/search?q=\(percentageWordString)") else { return }
        let safariViewController = SFSafariViewController(url: searchUrl)
        safariViewController.modalPresentationStyle = .overFullScreen
        present(safariViewController, animated: true, completion: nil)
        //UIApplication.shared.open(searchUrl, options: [:], completionHandler: nil)
    }
    @IBAction func addWord(_ sender: UIButton) {
        onAddWord?()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func continueClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateDescription() {
        let notExistPhrase = translate("\(gameType)_not_exist")
        let addWordPhrase = translate("you_may_add_it")
        descriptionText.text = "\(notExistPhrase) \(addWordPhrase)"
    }
    
    func setup(word: String, type: GameType) {
        gameType = type
        wordName.text = word
        updateDescription()
    }

}
