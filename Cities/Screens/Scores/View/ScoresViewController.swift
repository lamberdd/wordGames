//
//  ScoresViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 11/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var personalScoreView: UIView!
    @IBOutlet weak var scoreField: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
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
            tableView.delegate = self
            tableView.dataSource = self
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 0.55)
        }
    }
    
    func dismissAnimation(_ finish: (()->Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.clear
        }) { (complete) in
            finish?()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerScore", for: indexPath)
        guard let player = playersArray?[indexPath.row] else { return cell }
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = String(player.score)
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
