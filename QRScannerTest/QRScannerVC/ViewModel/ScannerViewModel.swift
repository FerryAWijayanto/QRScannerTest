//
//  ScannerViewModel.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation
import Combine

protocol ScannerViewModelProtocolInput {
//    var eventMerchantInfo: PublishSubject<PaymentViewModel.Input> { get }
    var eventMerchantInfo: PassthroughSubject<PaymentViewModel.Input, Never> { get }
}

protocol ScannerViewModelProtocolOutput {
    func getQRMerchantInfo(value: String)
}

struct Merchant {
    var id: String = ""
    var source: String = ""
    var merchant: String = ""
    var transaction: String = ""
    var nominal: Double = 0
}

typealias ScannerViewModelProtocol = ScannerViewModelProtocolInput & ScannerViewModelProtocolOutput

final class ScannerViewModel: ScannerViewModelProtocol {

    var eventMerchantInfo: PassthroughSubject<PaymentViewModel.Input, Never> = .init()

    func getQRMerchantInfo(value: String) {
        let components = value.components(separatedBy: ".")

        var merchant = Merchant()
        merchant.source = components[safe: 0] ?? ""
        merchant.id = components[safe: 1] ?? ""
        merchant.merchant = components[safe: 2] ?? ""
        merchant.nominal = Double(components[safe: 3] ?? "") ?? 0

        let input: PaymentViewModel.Input = .init(merchant: merchant)
        eventMerchantInfo.send(input)
    }

}
