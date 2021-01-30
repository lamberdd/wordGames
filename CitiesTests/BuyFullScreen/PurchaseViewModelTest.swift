//
//  PurchasePresenterTest.swift
//  CitiesTests
//
//  Created by Владислав Казмирчук on 29.01.2021.
//  Copyright © 2021 Влад Казмирчук. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
@testable import Cities

fileprivate var iapManager = IAPManagerMock()
fileprivate var promoService = PromocodeServiceMock()
fileprivate var storedPurchase = AppSettings.global.isFullVersion

class PurchaseViewModelTest: XCTestCase {
    
    var bag = DisposeBag()
    var viewModel: PurchaseViewModel!
    var scheduler: TestScheduler!
    
    override class func tearDown() {
        AppSettings.global.isFullVersion = storedPurchase // Восстанавливаем начальное состояние, которые было до тестов
    }
    
    override func setUp() {
        AppSettings.global.isFullVersion = false
        viewModel = PurchaseViewModel(iapManager: iapManager, promoService: promoService)
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testPurchase() throws {
        XCTAssertEqual(try viewModel.purchased.toBlocking().first(), false, "Отображается полная версия")
        
        iapManager.currentStatus = .paymentProblem
        let alert = scheduler.createObserver(String.self)
        viewModel.alertText.subscribe(alert).disposed(by: bag)
        viewModel.purchaseClick.accept(())
        XCTAssertEqual(alert.events, [.next(0, translate("cannot_purchase"))], "Текст alert не совпадает с ошибкой .paymentProblem")
                
        iapManager.currentStatus = .success
        viewModel.purchaseClick.accept(())
        XCTAssertEqual(try viewModel.purchased.toBlocking().first(), true, "После покупки не отображается информация, что полная версия приобретена")
        XCTAssert(AppSettings.global.isFullVersion, "Приложение не сохранило, что поная версия приобретена")
    }
    
    func testRestore() throws {
        iapManager.currentStatus = .noPurchases
        let alert = scheduler.createObserver(String.self)
        viewModel.alertText.subscribe(alert).disposed(by: bag)
        viewModel.restoreClick.accept(())
        XCTAssertEqual(alert.events, [.next(0, translate("no_restore_purchases"))], "Текст alert не совпадает с ошибкой .noPyrchases")
                
        iapManager.currentStatus = .success
        viewModel.restoreClick.accept(())
        XCTAssertEqual(try viewModel.purchased.toBlocking().first(), true, "Не отображается, что полная версия приобретена")
        XCTAssert(AppSettings.global.isFullVersion, "Приложение не сохранило, что поная версия приобретена")
    }
    
    func testPromocode() throws {
        let alert = scheduler.createObserver(String.self)
        viewModel.alertText.subscribe(alert).disposed(by: bag)
        viewModel.checkPromo.accept(".") // Invalid
        
        XCTAssertEqual(alert.events,
                           [.next(0, translate("invalidCode"))])
        
        
        viewModel.checkPromo.accept("not_exist") // Код, указанный в mock сервисе для возвращения ошибки codeNotExist
        XCTAssertEqual(try viewModel.alertText.toBlocking().first(), translate(PromocodeStatus.codeNotExist.rawValue))
        
        viewModel.checkPromo.accept("over") // Код для возвращения codeOver
        XCTAssertEqual(try viewModel.alertText.toBlocking().first(), translate(PromocodeStatus.codeOver.rawValue))
        
        
        // Проверка success (асинхронный ответ)
        let expextation = expectation(description: "Async success promocode")
        expextation.expectedFulfillmentCount = 2
        var currentExpectationNum = 1
        
        viewModel.checkPromo.accept("success")
        viewModel.purchased.subscribe(onNext: { (purchased) in
            if currentExpectationNum == 1 {
                XCTAssertFalse(purchased) // Т.к viewModel.purchased Behavior - вначале придет начальное значение false
            } else if currentExpectationNum == 2 {
                XCTAssertTrue(purchased, "Не приобретена полная версия для success кода")
            }
            
            currentExpectationNum += 1
            
            expextation.fulfill()
        }).disposed(by: bag)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

}
