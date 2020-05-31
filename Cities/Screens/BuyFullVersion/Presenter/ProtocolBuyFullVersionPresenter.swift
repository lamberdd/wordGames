//
//  ProtocolBuyFullVersionPresenter.swift
//  Cities
//
//  Created by Владислав Казмирчук on 28.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation

protocol ProtocolBuyFullVersionPresenter {
    func checkPromo(_ promo: String)
    func buy()
    func restore()
}
