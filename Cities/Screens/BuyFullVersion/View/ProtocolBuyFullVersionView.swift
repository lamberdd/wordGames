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
    func buttonLoading(_ show: Bool)
    func showSuccessPurchase()
    func setPurchaseButtonTitle(_ title: String)
    func showError()
    func showAlert(text: String)
}
