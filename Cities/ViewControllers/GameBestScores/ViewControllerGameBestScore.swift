//
//  ViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 2/18/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

struct GameBestScoresModel {
    let gameType: GameType
    let players: [Player]
}

class GameBestScoresVC: UIViewController {
    
    static func get(for gamePlayers: [GameBestScoresModel]) -> [GameBestScoresVC] {
        var viewControllers: [GameBestScoresVC] = []
        for item in gamePlayers {
            let game = item.gameType
            let players = item.players
            var scoresTableModel: [ScoresTableModel] = []
            players.forEach({ scoresTableModel.append(ScoresTableModel(name: $0.name, score: $0.score)) })
            if let viewController = UIStoryboard(name: "GameBestScores", bundle: nil).instantiateInitialViewController() as? GameBestScoresVC {
                viewController.setup(title: translate(game.rawValue), scores: scoresTableModel)
                viewControllers.append(viewController)
            }
        }
        
        return viewControllers
    }

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var scoresTable: ScoresTable!
    
    private var titleName: String = ""
    private var scores: [ScoresTableModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func setup(title: String, scores: [ScoresTableModel]) {
        self.titleName = title
        self.scores = scores
        if gameName != nil && scoresTable != nil {
            updateView()
        }
    }
    
    private func updateView() {
        gameName.text = titleName
        scoresTable.update(data: scores)
    }

}
