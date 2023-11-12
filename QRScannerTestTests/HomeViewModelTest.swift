//
//  HomeViewModelTest.swift
//  QRScannerTestTests
//
//  Created by Ferry Adi Wijayanto on 12/11/23.
//

import XCTest
import Combine

@testable import QRScannerTest

final class HomeViewModelTest: XCTestCase {

    var storeMock: MerchantStoreProtocol!
    var viewModel: HomeViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storeMock = MerchantStoreMock()
        cancellables = .init()
        viewModel = .init(store: storeMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        storeMock = nil
        cancellables = nil
        viewModel = nil
    }

    func testOnQRButtonDidTapped() {
        // Given
        let expectation = XCTestExpectation()
        viewModel.eventNavigateToScanner
            .sink { input in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onQRButtonDidTapped()

        // Then
        wait(for: [expectation], timeout: 10)

    }

    func testOnUpdateSaldo() {
        // Given
        let expectation = XCTestExpectation()
        viewModel.eventUpdateSaldo
            .sink { saldo in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onUpdateSaldo(saldo: 50_000)

        // Then
        wait(for: [expectation], timeout: 10)
    }

    func testOnShowMerchantListDidTapped() {
        // Given
        let expectation = XCTestExpectation()
        viewModel.eventGetMerchantList
            .sink { lists in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onShowMerchantListDidTapped()

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

final class MerchantStoreMock: MerchantStoreProtocol {

    var lists: [Merchant] = []

    func saveListMerchant(list: [QRScannerTest.Merchant]) {
        lists.append(contentsOf: list)
    }
    
    func getListMerchant() -> [QRScannerTest.Merchant] {
        return lists
    }
}
