//
//  MerchantViewModelTest.swift
//  QRScannerTestTests
//
//  Created by Ferry Adi Wijayanto on 12/11/23.
//

import XCTest
import Combine

@testable import QRScannerTest

final class MerchantViewModelTest: XCTestCase {

    var inputMock: MerchantViewModel.Input!
    var viewModel: MerchantViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        var merchant: Merchant = .init()
        merchant.id = "1"
        merchant.merchant = "warung"
        merchant.source = "BNI"
        merchant.nominal = 100_000

        inputMock = .init(merchantList: [merchant])
        viewModel = .init(input: inputMock)
        cancellables = .init()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        inputMock = nil
        viewModel = nil
        cancellables = nil
    }

    func testOnViewDidLoad() {
        // Given
        let expectation = XCTestExpectation()
        viewModel.eventUpdateData
            .sink { _ in
                expectation.fulfill()
            }.store(in: &cancellables)

        // When
        viewModel.onViewDidLoad()

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
