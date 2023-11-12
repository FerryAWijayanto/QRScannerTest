//
//  MerchantViewModel.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation
import Combine

protocol MerchantViewModelProtocolInput {
    var merchantLists: [Merchant] { get set }
    var eventUpdateData: PassthroughSubject<Void, Never> { get }
}

protocol MerchantViewModelProtocolOutput {
    func onViewDidLoad()
}

typealias MerchantViewModelProtocol = MerchantViewModelProtocolInput & MerchantViewModelProtocolOutput

final class MerchantViewModel: MerchantViewModelProtocol {

    class Input {
        let merchantList: [Merchant]

        init(merchantList: [Merchant]) {
            self.merchantList = merchantList
        }
    }

    private let input: Input
    let eventUpdateData: PassthroughSubject<Void, Never> = .init()

    var merchantLists: [Merchant] = []

    init(input: Input) {
        self.input = input
    }

    func onViewDidLoad() {
        merchantLists.removeAll()
        merchantLists = input.merchantList
        eventUpdateData.send(())
    }
}
