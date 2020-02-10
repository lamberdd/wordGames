//
//  AlreadyUsedViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 1/23/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class AlreadyUsedWordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var usedWords: [UsedWord] = []

    @IBOutlet weak var tableView: UITableView!
    @IBAction func continueClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func update(usedWords: [UsedWord]) {
        self.usedWords = usedWords
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usedWordCell", for: indexPath)
        let wordInfo = usedWords[indexPath.row]
        cell.textLabel?.text = wordInfo.word
        cell.detailTextLabel?.text = wordInfo.playerName
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = Constants.colors.superHighlightGray
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }

}
