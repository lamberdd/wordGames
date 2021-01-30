//
//  PromocodeServiceMock.swift
//  CitiesTests
//
//  Created by Владислав Казмирчук on 29.01.2021.
//  Copyright © 2021 Влад Казмирчук. All rights reserved.
//

import Foundation
@testable import Cities

class PromocodeServiceMock: PromocodeService {
    
    var successCode: String = "success"
    var notExistCode: String = "not_exist"
    var overCode: String = "over"
    
    
    override func checkCode(code: String, callback: @escaping (PromocodeStatus) -> Void) {
        switch code {
        case successCode:
            callback(.success)
        case notExistCode:
            callback(.codeNotExist)
        case overCode:
            callback(.codeOver)
        default:
            callback(.invalidCode)
        }
    }
}
