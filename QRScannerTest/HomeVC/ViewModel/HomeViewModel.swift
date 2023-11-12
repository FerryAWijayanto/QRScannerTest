//
//  HomeViewModel.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation
import Combine

protocol HomeViewModelProtocolInput {
    var saldo: Double { get set }
    var eventNavigateToScanner: PassthroughSubject<ScannerViewModel.Input, Never> { get }
    var eventUpdateSaldo: PassthroughSubject<Double, Never> { get }
    var eventGetMerchantList: PassthroughSubject<MerchantViewModel.Input, Never> { get }
}

protocol HomeViewModelProtocolOutput {
    func onQRButtonDidTapped()
    func onUpdateSaldo(saldo: Double)
    func onShowMerchantListDidTapped()
}

typealias HomeViewModelProtocol = HomeViewModelProtocolInput & HomeViewModelProtocolOutput

final class HomeViewModel: HomeViewModelProtocol {

    private let store: MerchantStoreProtocol

    var saldo: Double = 500_000

    let eventNavigateToScanner: PassthroughSubject<ScannerViewModel.Input, Never> = .init()
    let eventUpdateSaldo: PassthroughSubject<Double, Never> = .init()
    let eventGetMerchantList: PassthroughSubject<MerchantViewModel.Input, Never> = .init()

    init(store: MerchantStoreProtocol) {
        self.store = store
    }

    func onQRButtonDidTapped() {
        let input: ScannerViewModel.Input = .init(saldo: saldo)
        eventNavigateToScanner.send(input)
    }

    func onUpdateSaldo(saldo: Double) {
        self.saldo = saldo
        eventUpdateSaldo.send(saldo)
    }

    func onShowMerchantListDidTapped() {
        let input: MerchantViewModel.Input = .init(merchantList: store.getListMerchant())
        eventGetMerchantList.send(input)
    }
}
