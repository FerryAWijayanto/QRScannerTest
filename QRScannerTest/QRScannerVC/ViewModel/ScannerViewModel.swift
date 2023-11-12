//
//  ScannerViewModel.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation
import Combine

protocol ScannerViewModelProtocolInput {
    var eventMerchantInfo: PassthroughSubject<PaymentViewModel.Input, Never> { get }
}

protocol ScannerViewModelProtocolOutput {
    func getQRMerchantInfo(value: String)
}

typealias ScannerViewModelProtocol = ScannerViewModelProtocolInput & ScannerViewModelProtocolOutput

final class ScannerViewModel: ScannerViewModelProtocol {

    class Input {
        let saldo: Double

        init(saldo: Double) {
            self.saldo = saldo
        }
    }

    private let input: Input

    init(input: Input) {
        self.input = input
    }

    var eventMerchantInfo: PassthroughSubject<PaymentViewModel.Input, Never> = .init()

    func getQRMerchantInfo(value: String) {
        let components = value.components(separatedBy: ".")

        var merchant = Merchant()
        merchant.source = components[safe: 0] ?? ""
        merchant.id = components[safe: 1] ?? ""
        merchant.merchant = components[safe: 2] ?? ""
        merchant.nominal = Double(components[safe: 3] ?? "") ?? 0

        let input: PaymentViewModel.Input = .init(merchant: merchant, saldo: input.saldo)
        eventMerchantInfo.send(input)
    }

}
