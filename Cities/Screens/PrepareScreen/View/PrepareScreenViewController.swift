//
//  CiteiesPrepare.swift
//  Cities
//
//  Created by Влад Казмирчук on 6/23/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PrepareScreenViewController: UIViewController {
    
    var viewModel: PrepareScreenViewModel!
    let bag = DisposeBag()
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var usersNameTable: UITableView!
    @IBOutlet weak var countPlayers: UIStepper!
    @IBOutlet weak var helpSwitch: UISwitch!
    @IBOutlet weak var timeGameSwitch: UISwitch!
    @IBOutlet weak var usersTableHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var exitButton: UIBarButtonItem!
    
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
        self.navigationItem.leftBarButtonItem?.setTextFontToDefault()
        
        setupTable()
        setupViewModel()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: 	#selector(dismissKeyboard)))
    }
    
    private func setupViewModel() {
        viewModel.gameType.drive(onNext: { [weak self] type in
            self?.title = translate(type.rawValue)
            self?.backgroundImage.image = GameImage.getFor(gameType: type)
        }).disposed(by: bag)

        countPlayers.rx.value.bind(to: viewModel.countPlayers).disposed(by: bag)
        helpSwitch.rx.value.bind(to: viewModel.hintEnable).disposed(by: bag)
        timeGameSwitch.rx.value.bind(to: viewModel.timeGameEnable).disposed(by: bag)

        viewModel.startButtonEnabled.distinctUntilChanged().drive(onNext: { [weak self] value in
            self?.startButton.isEnabled = value
            self?.startButton.alpha = value ? 1.0 : 0.5
        }).disposed(by: bag)

        viewModel.players.drive(usersNameTable.rx.items(cellIdentifier: "userName", cellType: CellWithTextField.self)) { [weak self] row, element, cell in
            cell.textField.text = element
            cell.textField.didChange = { [weak self] (text) in
                guard let text = text else { return }
                self?.viewModel.changedPlayerName.accept([row: text])
            }
        }.disposed(by: bag)


        viewModel.players.drive(onNext: { [weak self] players in
            //Update tableview height
            guard let self = self else { return }
            let countPlayers = self.countPlayers.value
            let newHeight = CGFloat(countPlayers) * self.startTableHeight
            if newHeight > 289 {
                self.usersTableHeight.constant = 290.0
                self.usersNameTable.scrollToRow(at: IndexPath(row: Int(countPlayers-1), section: 0), at: .bottom, animated: true)
            } else {
                self.usersTableHeight.constant = newHeight
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }).disposed(by: bag)

        startButton.rx.tap.bind(to: viewModel.startClick).disposed(by: bag)
        exitButton.rx.tap.bind(to: viewModel.exit).disposed(by: bag)
    }
    
    func setupTable() {
        usersNameTable.estimatedRowHeight = 60
        usersNameTable.rowHeight = UITableView.automaticDimension
        usersTableHeight.constant = startTableHeight
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


}
