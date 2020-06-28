//
//  BuyFullVersionPresenter.swift
//  Cities
//
//  Created by Владислав Казмирчук on 28.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

class BuyFullVersionPresenter: ProtocolBuyFullVersionPresenter {
    
    weak var view: ProtocolBuyFullVersionView?
    let iapManager = IAPManager()
    
    init(view: ProtocolBuyFullVersionView) {
        self.view = view
        if AppSettings.global.isFullVersion {
            setSuccessState()
        } else {
            view.buttonLoading(true)
            iapManager.getPriceForFullVersion {  [weak self] (price) in
                DispatchQueue.main.async {
                    guard let price = price else {
                        self?.view?.showError()
                        return
                    }
                    let translateText = translate("get_for")
                    view.setPurchaseButtonTitle("\(translateText) \(price)")
                    view.buttonLoading(false)
                }
            }
        }
    }
    
    func checkPromo(_ promo: String) {
        if promo.count < 3 {
            view?.showAlert(text: translate("invalidCode"))
            return
        }
        self.view?.showLoading()
        let promoService = PromocodeService()
        promoService.checkCode(code: promo) { (status) in
            DispatchQueue.main.async {
                self.view?.stopLoading()
                switch status {
                case .success:
                    self.successPurchase()
                default:
                    self.view?.showAlert(text: translate(status.rawValue))
                }
            }
        }
    }
    
    func buy() {
        view?.showLoading()
        iapManager.buyFull { [weak self] (status) in
            print("Buy status: \(status)")
            switch status {
            case .success:
                self?.successPurchase()
            case .error:
                self?.view?.showAlert(text: translate("purchase_error"))
            case .paymentProblem:
                self?.view?.showAlert(text: translate("cannot_purchase"))
            default: break;
            }
            self?.view?.stopLoading()
        }
    }
    
    func restore() {
        self.view?.showLoading()
        iapManager.restore { [weak self] (status) in
            print("Restore status: \(status)")
            switch status {
            case .success:
                self?.successPurchase()
            case .error:
                self?.view?.showAlert(text: translate("purchase_error"))
            case .noPurchases:
                self?.view?.showAlert(text: translate("no_restore_purchases"))
            default: break;
            }
            self?.view?.stopLoading()
        }
    }
    
    private func successPurchase() {
        AppSettings.global.isFullVersion = true
        setSuccessState()
    }
    
    private func setSuccessState() {
        view?.stopLoading()
        view?.showSuccessPurchase()
    }
}
