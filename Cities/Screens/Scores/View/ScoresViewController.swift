//
//  ScoresViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 11/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class ScoresViewController: BlackoutViewController {

    @IBOutlet weak var personalScoreView: UIView!
    @IBOutlet weak var scoreField: UILabel!
    
    @IBOutlet weak var tableScores: ScoresTable!
    
    public var onContinue: (()->Void)? = nil
    
    var playersArray: [Player]? = nil
    
    @IBAction func continueClick(_ sender: UIButton) {
        onContinue?()
    }
    
    deinit {
        print("Score screen deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard playersArray != nil else { return }
        
        if playersArray!.count == 1 {
            scoreField.text = String(playersArray![0].score)
        } else {
            personalScoreView.isHidden = true
            var scores: [ScoresTableModel] = []
            playersArray?.forEach({ scores.append(ScoresTableModel(name: $0.name, score: $0.score)) })
            tableScores.update(data: scores)
        }
        // Do any additional setup after loading the view.
    }
    
}
