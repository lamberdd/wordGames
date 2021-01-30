//
//  IAPManagerMock.swift
//  CitiesTests
//
//  Created by Владислав Казмирчук on 29.01.2021.
//  Copyright © 2021 Влад Казмирчук. All rights reserved.
//

import Foundation
@testable import Cities

class IAPManagerMock: IAPManager {
    
    var currentStatus: PurchaseStatus = .error
    
    override func buyFull(callback: @escaping (PurchaseStatus) -> Void) {
        callback(currentStatus)
    }
    
    override func restore(callback: @escaping (PurchaseStatus) -> Void) {
        callback(currentStatus)
    }
}
