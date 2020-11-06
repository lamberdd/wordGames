//
//  BuyFullVersionView.swift
//  Cities
//
//  Created by Владислав Казмирчук on 27.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BuyFullVersionView: BlackoutViewController {

    let bag = DisposeBag()
    let viewModel: PurchaseViewModel = PurchaseViewModel()
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var buttonLoader: UIActivityIndicatorView!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var restoreButton: UIButton!
    var onClose: (()->Void)? = nil
    var purchaseText: String = ""
    
    @IBAction func close(_ sender: UIButton) {
        onClose?()
        dismiss(animated: true)
    }
 
    @IBAction func enterPromo(_ sender: UIButton) {
        showInputAlert(title: translate("promocode")) { [weak self] (code) in
            self?.viewModel.checkPromo.accept(code)
        }
    }
    
    deinit {
        print("PurchaseView deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buyButton.rx.tap.bind(to: viewModel.purchaseClick).disposed(by: bag)
        restoreButton.rx.tap.bind(to: viewModel.restoreClick).disposed(by: bag)
        
        viewModel.purchaseButtonLoader.asDriver().drive(buttonLoader.rx.isAnimating).disposed(by: bag)
        viewModel.purchaseButtonTitle.asDriver().drive(buyButton.rx.title()).disposed(by: bag)
        
        viewModel.loading.asDriver().map({ !$0 }).drive(loaderView.rx.isHidden).disposed(by: bag)
        
        //Отрицаем полученное значение для работы с isHidden
        viewModel.error.asDriver().map({ !$0 }).drive(errorView.rx.isHidden).disposed(by: bag)
        viewModel.purchased.asDriver().map({ !$0 }).drive(successView.rx.isHidden).disposed(by: bag)
        
        viewModel.alertText.observeOn(MainScheduler.instance).subscribe(onNext: { (text) in
            self.showAlert(text: text)
        }).disposed(by: bag)
        
    }

    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: translate("Ok"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showInputAlert(title: String, callback: ((String)->Void)?) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = translate("enter_promo")
        }
        alert.addAction(UIAlertAction(title: translate("Ok"), style: .default, handler: { [weak alert] (action) in
            if let text = alert?.textFields?[0].text {
                callback?(text)
            }
        }))
        alert.addAction(UIAlertAction(title: translate("cancel"), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
