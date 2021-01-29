//
//  MainScreenViewMock.swift
//  CitiesTests
//
//  Created by Владислав Казмирчук on 28.01.2021.
//  Copyright © 2021 Влад Казмирчук. All rights reserved.
//

import UIKit
@testable import Cities

class MainScreenViewMock: MainScreenViewProtocol {
    
    var disablePaidGameCalled = false
    var enablePaidGameCalled = false
    
    func disablePaidGame() {
        disablePaidGameCalled = true
    }
    
    func enablePaidGame() {
        enablePaidGameCalled = true
    }
    
    
    func clearStates() {
        disablePaidGameCalled = false
        enablePaidGameCalled = false
    }
    
}
