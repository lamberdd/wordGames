//
//  PrepareScreenCoordinator.swift
//  Cities
//
//  Created by Владислав Казмирчук on 16.11.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit
import RxSwift

class PrepareScreenCoordinator {
    
    private let bag = DisposeBag()
    
    private let rootController: UIViewController
    private weak var prepareView: PrepareScreenViewController?
    private weak var prepareViewModel: PrepareScreenViewModel?
    
    public var onClose: (()->Void)? = nil
    
    deinit {
        print("PrepareCoordinator deinited")
    }
    
    init(rootController: UIViewController, prepareView: PrepareScreenViewController, viewModel: PrepareScreenViewModel) {
        self.rootController = rootController
        self.prepareView = prepareView
        self.prepareViewModel = viewModel
        
        self.prepareViewModel?.didClose.subscribe(onNext: { [weak self] _ in
            self?.prepareView?.navigationController?.popViewController(animated: true)
            self?.prepareView?.view.endEditing(true)
            self?.prepareView?.dismiss(animated: true, completion: nil)
            self?.onClose?()
        }).disposed(by: bag)
        
        self.prepareViewModel?.didStartGame.subscribe(onNext: { [weak self] gameSettings in
            self?.openGameController(gameSettings: gameSettings)
        }).disposed(by: bag)
    }
    
    private func openGameController(gameSettings: GameInitialSettings) {
        guard let prepareView = prepareView else { return }
        let gameCoordinator = GameCoordinator(prepareViewController: prepareView, gameSettings: gameSettings)
        gameCoordinator.onCloseToMainScreen = onClose
        gameCoordinator.startGame()
    }
}
