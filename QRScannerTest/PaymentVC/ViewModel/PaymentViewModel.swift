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
    var eventPresentPaymentAlert: PassthroughSubject<(String, String), Never> { get }
    var eventNavigateBackToHome: PassthroughSubject<Double, Never> { get }
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
        let saldo: Double

        init(merchant: Merchant, saldo: Double) {
            self.merchant = merchant
            self.saldo = saldo
        }
    }

    private let input: Input
    private let store: MerchantStoreProtocol

    private var newSaldo: Double {
        input.saldo - input.merchant.nominal
    }

    let eventPresentPaymentAlert: PassthroughSubject<(String, String), Never> = .init()
    let eventNavigateBackToHome: PassthroughSubject<Double, Never> = .init()

    init(input: Input, store: MerchantStoreProtocol) {
        self.input = input
        self.store = store
    }

    func onPaymentDidTapped() {
        var lists = store.getListMerchant()
        if newSaldo >= 0 {
            var merchant: Merchant = .init()
            merchant.id = input.merchant.id
            merchant.merchant = input.merchant.merchant
            merchant.nominal = input.merchant.nominal
            merchant.source = input.merchant.source

            lists.append(merchant)
            store.saveListMerchant(list: lists)
            eventPresentPaymentAlert.send(("Success", "Payment success"))
        } else {
            eventPresentPaymentAlert.send(("Failed", "Payment failed"))
        }
    }

    func onCloseButtonDidTapped() {
        if newSaldo >= 0 {
            eventNavigateBackToHome.send(newSaldo)
        } else {
            eventNavigateBackToHome.send(0)
        }
    }
}
