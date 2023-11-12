//
//  PaymentViewModelTest.swift
//  QRScannerTestTests
//
//  Created by Ferry Adi Wijayanto on 12/11/23.
//

import XCTest
import Combine

@testable import QRScannerTest

final class PaymentViewModelTest: XCTestCase {

    var inputMock: PaymentViewModel.Input!
    var storeMock: MerchantStoreProtocol!
    var viewModel: PaymentViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        var merchant: Merchant = .init()
        merchant.id = "1"
        merchant.merchant = "warung"
        merchant.source = "BNI"
        merchant.nominal = 100_000

        inputMock = .init(merchant: merchant, saldo: 200_000)
        storeMock = MerchantStoreMock()
        cancellables = .init()
        viewModel = .init(input: inputMock, store: storeMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        inputMock = nil
        storeMock = nil
        viewModel = nil
        cancellables = nil
    }

    func testGetId() {
        // Given

        // When

        // Then
        XCTAssertEqual(viewModel.id, "1")
    }

    func testGetMerchant() {
        // Given

        // When

        // Then
        XCTAssertEqual(viewModel.merchant, "warung")
    }

    func testGetNominal() {
        // Given

        // When

        // Then
        XCTAssertEqual(viewModel.nominal, "Rp100.000")
    }

    func testOnPaymentDidTappedSuccess() {
        // Given
        let expectation = XCTestExpectation()
        viewModel.eventPresentPaymentAlert
            .sink { (title, message) in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onPaymentDidTapped()

        // Then
        wait(for: [expectation], timeout: 10)
    }

    func testOnPaymentDidTappedFailed() {
        // Given
        let expectation = XCTestExpectation()
        var merchant: Merchant = .init()
        merchant.id = "1"
        merchant.merchant = "warung"
        merchant.source = "BNI"
        merchant.nominal = 100_000

        inputMock = .init(merchant: merchant, saldo: 0)
        storeMock = MerchantStoreMock()
        viewModel = .init(input: inputMock, store: storeMock)

        viewModel.eventPresentPaymentAlert
            .sink { (title, message) in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onPaymentDidTapped()

        // Then
        wait(for: [expectation], timeout: 10)
    }

    func testOnCloseButtonDidTappedMoreThanZero() {
        // Given
        let expectation = XCTestExpectation()
        viewModel.eventNavigateBackToHome
            .sink { saldo in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onCloseButtonDidTapped()

        // Then
        wait(for: [expectation], timeout: 10)
    }

    func testOnCloseButtonDidTappedLessThanZero() {
        // Given
        let expectation = XCTestExpectation()
        var merchant: Merchant = .init()
        merchant.id = "1"
        merchant.merchant = "warung"
        merchant.source = "BNI"
        merchant.nominal = 100_000

        inputMock = .init(merchant: merchant, saldo: 0)
        storeMock = MerchantStoreMock()
        viewModel = .init(input: inputMock, store: storeMock)

        viewModel.eventNavigateBackToHome
            .sink { saldo in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onCloseButtonDidTapped()

        // Then
        wait(for: [expectation], timeout: 10)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
