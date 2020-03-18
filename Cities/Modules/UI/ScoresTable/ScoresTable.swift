//
//  ScoresTable.swift
//  Cities
//
//  Created by Влад Казмирчук on 2/18/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

struct ScoresTableModel {
    let name: String
    let score: Int
}

class ScoresTable: UITableView, UITableViewDataSource {
    
    var data: [ScoresTableModel] = []
    
    private let cellId = "ScoreCell"
    
    //MARK: - Public interface
    
    func update(data: [ScoresTableModel]) {
        self.data = data
        
        self.dataSource = self
        
        self.reloadData()
    }
    
    //MARK: - Configured methods

    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(UINib(nibName: "ScoreCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let model = data[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = String(model.score)
        if data.count > 2 && indexPath.row % 2 == 1 {
            cell.backgroundColor = Constants.colors.superHighlightGray
        }

        return cell
    }

}
