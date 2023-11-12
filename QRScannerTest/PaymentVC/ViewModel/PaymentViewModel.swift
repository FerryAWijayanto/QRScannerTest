//
//  PaymentViewModel.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation
import Combine

protocol PaymentViewModelProtocolInput {
    var id: String { get }
    var merchant: String { get }
    var nominal: String { get }
    var eventPresentSuccessPayment: PassthroughSubject<Void, Never> { get }
}

protocol PaymentViewModelProtocolOutput {
    func onPaymentDidTapped()
    func onCloseButtonDidTapped()
}

typealias PaymentViewModelProtocol = PaymentViewModelProtocolInput & PaymentViewModelProtocolOutput

final class PaymentViewModel: PaymentViewModelProtocol {

    var id: String {
        input.merchant.id
    }

    var merchant: String {
        input.merchant.merchant
    }

    var nominal: String {
        input.merchant.nominal.formatCurrenyIDR()
    }


    class Input {
        let merchant: Merchant

        init(merchant: Merchant) {
            self.merchant = merchant
        }
    }

    private let input: Input

    let eventPresentSuccessPayment: PassthroughSubject<Void, Never> = .init()

    init(input: Input) {
        self.input = input
    }

    func onPaymentDidTapped() {
        eventPresentSuccessPayment.send(())
    }

    func onCloseButtonDidTapped() {
        
    }
}
