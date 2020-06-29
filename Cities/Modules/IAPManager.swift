//
//  IAPManager.swift
//  Cities
//
//  Created by Владислав Казмирчук on 28.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
import StoreKit

enum PurchaseStatus {
    case success, paymentProblem, error, noPurchases, canceled
}

enum IAPManagerError: Error {
    case noProductIDsFound
    case noProductsFound
    case paymentWasCancelled
    case productRequestFailed
}

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    private var fullVersionProduct: SKProduct? = nil
    private let fullVersionProductID = "ru.vladkazmirchuk.fullversion"
    
    private var dataReceived = false
    private var onGetPriceForFullVersion: ((String?)->Void)?
    
    private var onPurchaseCallback: ((PurchaseStatus)->Void)? = nil
    private var onRestoreCallback: ((PurchaseStatus)->Void)? = nil
    
    private var totalRestoredPurchases = 0
    
    override init() {
        super.init()
        getProducts()
        startObserving()
        startErrorTimeout()
    }
    
    deinit {
        stopObserving()
    }
    
    //MARK: - Public methods
    func buyFull(callback: @escaping (PurchaseStatus)->Void) {
        guard let product = fullVersionProduct else { callback(.error); return }
        if canMakePayments() {
            onPurchaseCallback = callback
            buy(product: product)
        } else {
            callback(.paymentProblem)
        }
    }
    
    func restore(callback: @escaping (PurchaseStatus)->Void) {
        onRestoreCallback = callback
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getPriceForFullVersion(callback: @escaping (String?)->Void) {
        onGetPriceForFullVersion = callback
        if fullVersionProduct != nil {
            callFullVersionPriceHandler()
        }
    }
    
    //MARK: - Private methods
    private func getProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(arrayLiteral: fullVersionProductID))
        request.delegate = self
        request.start()
    }
    
    private func callFullVersionPriceHandler() {
        guard let product = fullVersionProduct else { onGetPriceForFullVersion?(nil); return }
        let price = getPriceFormatted(for: product)
        onGetPriceForFullVersion?(price)
        onGetPriceForFullVersion = nil
    }
    
    private func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    private func returnError(for callback: ((PurchaseStatus)->Void)?, error: Error) {
        print(error.localizedDescription)
        guard let callback = callback else { return }
        if let skError = error as? SKError {
            if skError.code != .paymentCancelled {
                callback(.error)
            } else {
                callback(.canceled)
            }
        }
    }
    
    private func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    private func startErrorTimeout() {
        // Если в течении 15 секунд не получаем ответ в productRequest, то вызываем handler и возвращаем ошибку
        Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { (timer) in
            if !self.dataReceived {
                self.callFullVersionPriceHandler()
            }
        }
    }
    
    //MARK: - Products and payment delegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        dataReceived = true
        fullVersionProduct = products.first(where: { $0.productIdentifier == fullVersionProductID })
        callFullVersionPriceHandler()
        return
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchased:
                print("Purchased")
                onPurchaseCallback?(.success)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                totalRestoredPurchases += 1
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Restored")
            case .failed:
                if let error = transaction.error {
                    returnError(for: onPurchaseCallback, error: error)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases != 0 {
            onRestoreCallback?(.success)
        } else {
            onRestoreCallback?(.noPurchases)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        returnError(for: onRestoreCallback, error: error)
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
     
     
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
}
