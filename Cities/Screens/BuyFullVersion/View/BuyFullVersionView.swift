//
//  BuyFullVersionView.swift
//  Cities
//
//  Created by Владислав Казмирчук on 27.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class BuyFullVersionView: BlackoutViewController, ProtocolBuyFullVersionView {

    var presenter: ProtocolBuyFullVersionPresenter!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var successView: UIView!
    
    var onClose: (()->Void)? = nil
    
    @IBAction func close(_ sender: UIButton) {
        onClose?()
        dismiss(animated: true)
    }
    @IBAction func restore(_ sender: UIButton) {
        presenter.restore()
    }
    @IBAction func buy(_ sender: UIButton) {
        presenter.buy()
    }
    @IBAction func enterPromo(_ sender: UIButton) {
        showInputAlert(title: translate("promocode")) { [weak self] (code) in
            self?.presenter.checkPromo(code)
        }
    }
    
    deinit {
        print("ButFullView deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = BuyFullVersionPresenter(view: self)
        // Do any additional setup after loading the view.
    }
    
    func showLoading() {
        loaderView.isHidden = false
    }
    
    func stopLoading() {
        loaderView.isHidden = true
    }
    
    func showSuccessPurchase() {
        successView.isHidden = false
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