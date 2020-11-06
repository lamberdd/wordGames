//
//  BuyFullVersionPresenter.swift
//  Cities
//
//  Created by Владислав Казмирчук on 28.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PurchaseViewModel {
    
    let iapManager = IAPManager()
    
    let bag = DisposeBag()
    
    let purchaseClick = PublishRelay<Void>()
    let purchaseButtonLoader = BehaviorRelay<Bool>(value: true)
    let purchaseButtonTitle = BehaviorRelay<String>(value: "")
    let restoreClick = PublishRelay<Void>()
    let checkPromo = PublishRelay<String>()
    
    let alertText = PublishRelay<String>()
    
    let loading = BehaviorRelay<Bool>(value: false)
    let error = BehaviorRelay<Bool>(value: false)
    let purchased = BehaviorRelay<Bool>(value: false)
    
    init() {
        if AppSettings.global.isFullVersion {
            setSuccessState()
        } else {
            purchaseButtonLoader.accept(true)
            iapManager.getPriceForFullVersion {  [weak self] (price) in
                guard let price = price else {
                    self?.error.accept(true)
                    return
                }
                let translateText = translate("get_for")
                self?.purchaseButtonTitle.accept("\(translateText) \(price)")
                self?.purchaseButtonLoader.accept(false)
            }
        }
        
        purchaseClick.subscribe { (_) in
            self.buy()
        }.disposed(by: bag)
        
        restoreClick.subscribe { (_) in
            self.restore()
        }.disposed(by: bag)
        
        checkPromo.subscribe(onNext: { (promoText) in
            self.checkPromo(promoText)
        }).disposed(by: bag)
    }
    
    private func checkPromo(_ promo: String) {
        if promo.count < 3 {
            alertText.accept(translate("invalidCode"))
            return
        }
        loading.accept(true)
        let promoService = PromocodeService()
        promoService.checkCode(code: promo) { (status) in
            DispatchQueue.main.async {
                self.loading.accept(false)
                switch status {
                case .success:
                    self.successPurchase()
                default:
                    self.alertText.accept(translate(status.rawValue))
                }
            }
        }
    }
    
    private func buy() {
        loading.accept(true)
        iapManager.buyFull { [weak self] (status) in
            print("Buy status: \(status)")
            switch status {
            case .success:
                self?.successPurchase()
            case .error:
                self?.alertText.accept(translate("purchase_error"))
            case .paymentProblem:
                self?.alertText.accept(translate("cannot_purchase"))
            default: break;
            }
            self?.loading.accept(false)
        }
    }
    
    private func restore() {
        loading.accept(true)
        iapManager.restore { [weak self] (status) in
            print("Restore status: \(status)")
            switch status {
            case .success:
                self?.successPurchase()
            case .error:
                self?.alertText.accept(translate("purchase_error"))
            case .noPurchases:
                self?.alertText.accept(translate("no_restore_purchases"))
            default: break;
            }
            self?.loading.accept(false)
        }
    }
    
    private func successPurchase() {
        AppSettings.global.isFullVersion = true
        setSuccessState()
    }
    
    private func setSuccessState() {
        purchased.accept(true)
    }
}
