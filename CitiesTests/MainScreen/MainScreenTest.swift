//
//  MainScreenTest.swift
//  CitiesTests
//
//  Created by Владислав Казмирчук on 28.01.2021.
//  Copyright © 2021 Влад Казмирчук. All rights reserved.
//

import Foundation
import XCTest
@testable import Cities

fileprivate var storeIsFullVersionVar = false

fileprivate var mainView: MainScreenViewMock!
fileprivate var mainCoordinator: MainScreenCoordinatorMock!
fileprivate var testPresenter: MainScreenPresenter!

class MainScreenTest: XCTestCase {

        
    override class func setUp() {
        storeIsFullVersionVar = AppSettings.global.isFullVersion
        
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let view = navigationController.topViewController as! MainScreenViewController
        view.loadView()
        
        mainView = MainScreenViewMock()
        mainCoordinator = MainScreenCoordinatorMock(viewController: view)
        testPresenter = MainScreenPresenter(view: mainView, coordinator: mainCoordinator)
        
        mainView.clearStates()
        
    }
    
    override class func tearDown() {
        AppSettings.global.isFullVersion = storeIsFullVersionVar // Возращаем в изначальное состояние после завершения тестов
    }
    
    override func setUp() {
        // Каждый тест будет начинаться с неполной версией
        // В процессе конкретного теста это значение будет меняться
        AppSettings.global.isFullVersion = false
    }

    func testOpenFirstname() {
        // Пробуем открыть с неполной версией, должен открыться экран покупки полной версии
        testPresenter.firstnamesClick()
        XCTAssert(mainCoordinator.purchaseScreenOpen, "Экран покупки не открылся в неполной версии")
        
        AppSettings.global.isFullVersion = true // Полная версия приобретена
        
        testPresenter.firstnamesClick()
        XCTAssert(mainCoordinator.prepareFirstnames, "Экран подготовки не открылся в полной версии")
    }
    
    func testOpenChemElems() {
        // Пробуем открыть с неполной версией, должен открыться экран покупки полной версии
        testPresenter.chemElemsClick()
        XCTAssert(mainCoordinator.purchaseScreenOpen, "Экран покупки не открылся в неполной версии")
        
        AppSettings.global.isFullVersion = true // Полная версия приобретена
        
        testPresenter.chemElemsClick()
        XCTAssert(mainCoordinator.prepareChemElems, "Экран подготовке не открылся в полной версии")
    }
    
    func testUpdateScreenAfterPurchase() {
        testPresenter.update()
        XCTAssert(mainView.disablePaidGameCalled, "Все игры доступны в неполной версии")
        
        AppSettings.global.isFullVersion = true // Полная версия приобретена
        testPresenter.update()
        
        XCTAssert(mainView.enablePaidGameCalled, "Все игры НЕ доступны в полной версии")
    }
    
    func testShowingBestScores() {
        testPresenter.showBestScores()
        XCTAssert(mainCoordinator.showBestScores, "Открытие экрана с результатами не вызвано")
    }

}
