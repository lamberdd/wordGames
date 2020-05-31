//
//  ProtocolBuyFullVersionView.swift
//  Cities
//
//  Created by Владислав Казмирчук on 28.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

protocol ProtocolBuyFullVersionView: class {
    func showLoading()
    func stopLoading()
    func showSuccessPurchase()
    func showAlert(text: String)
}
