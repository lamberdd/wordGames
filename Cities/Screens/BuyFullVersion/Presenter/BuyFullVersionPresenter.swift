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
