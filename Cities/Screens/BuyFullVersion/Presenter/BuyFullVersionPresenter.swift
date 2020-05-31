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
        }
    }
    
    func checkPromo(_ promo: String) {
        if promo.count < 3 {
            view?.showAlert(text: translate("invalid_promo"))
            return
        }
        self.view?.showLoading()
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (t) in
            self.successPurchase()
        }
        print("Promocode: \(promo)")
    }
    
    func buy() {
        iapManager.buyFull { (status) in
            if status == .success {
                AppSettings.global.isFullVersion = true
                self.successPurchase()
            }
        }
    }
    
    func restore() {
        
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
