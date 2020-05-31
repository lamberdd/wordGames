//
//  IAPManager.swift
//  Cities
//
//  Created by Владислав Казмирчук on 28.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

enum PurchaseStatus {
    case success, canceled
}

class IAPManager {
    
    func buyFull(callback: (PurchaseStatus)->Void) {
        callback(.success)
    }
    
    func restore(callback: (PurchaseStatus)->Void) {
        callback(.success)
    }
}
