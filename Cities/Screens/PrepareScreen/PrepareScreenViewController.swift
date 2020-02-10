//
//  CiteiesPrepare.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class PrepareScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameType = GameType.city
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func countPlayersChanged(_ sender: UIStepper) {
        usersNameTable.reloadData()
        let newHeight = CGFloat(sender.value) * startTableHeight
        if newHeight > 289 {
            usersTableHeight.constant = 290.0
            usersNameTable.scrollToRow(at: IndexPath(row: Int(sender.value-1), section: 0), at: .bottom, animated: true)
        } else {
            usersTableHeight.constant = newHeight
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func start(_ sender: UIButton) {
        let gameCore = GameCore(type: gameType)
        let helpCount = helpSwitch.isOn ? AppSettings.global.getHelpCount() : 0
        //TODO: Continue Game Coordinator
        let gameSettings = GameInitialSettings(playerNames: self.getPlayers(), gameCore: gameCore, hintsCount: helpCount)
        let gameCoordinator = GameCoordinator(prepareViewController: self, gameSettings: gameSettings)
        gameCoordinator.startGame()
    }
    
    @IBOutlet weak var usersNameTable: UITableView!
    @IBOutlet weak var countPlayers: UIStepper!
    @IBOutlet weak var helpSwitch: UISwitch!
    @IBOutlet weak var usersTableHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let startTableHeight: CGFloat = 60.0
    var playersName: [String] = []
    
    deinit {
        print("prepare screen deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.title = translate(gameType.rawValue)
        backgroundImage.image = GameImage.getFor(gameType: gameType)
        navigationItem.leftBarButtonItem?.setTextFontToDefault()
        
        usersNameTable.estimatedRowHeight = 60
        usersNameTable.rowHeight = UITableView.automaticDimension
        
        usersNameTable.delegate = self
        usersNameTable.dataSource = self
        
        usersTableHeight.constant = startTableHeight
    }
    
    private func getPlayers() -> [String] {
        return playersName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = Int(countPlayers.value)
        if playersName.count > 0 && playersName.count > count {
            playersName.removeLast()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userName") as! CellWithTextField
        var name: String? = nil
        if playersName.indices.contains(indexPath.row) {
            name = playersName[indexPath.row]
        } else {
            let playerString = NSLocalizedString("player", comment: "")
            playersName.insert(name ?? "\(playerString) \(indexPath.row+1)", at: indexPath.row)
        }
        cell.textField.text = playersName[indexPath.row]
        cell.textField.didChange = { [weak self] (text) in
            self?.playersName[indexPath.row] = text ?? ""
        }
        return cell
    }


}
