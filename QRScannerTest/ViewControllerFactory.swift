//
//  ViewControllerFactory.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation

protocol ViewControllerFactoryProtocol {
    static func createHomeViewController() -> HomeViewController
    static func createQRScannerViewController(input: ScannerViewModel.Input) -> QRScannerViewController
    static func createPaymentViewController(input: PaymentViewModel.Input) -> PaymentViewController
    static func createMerchantListViewController(input: MerchantViewModel.Input) -> MerchantListViewController
}

final class ViewControllerFactory: ViewControllerFactoryProtocol {
    static func createHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(store: MerchantStore())
        return HomeViewController(viewModel: viewModel)
    }

    static func createQRScannerViewController(input: ScannerViewModel.Input) -> QRScannerViewController {
        let viewModel = ScannerViewModel(input: input)
        return QRScannerViewController(viewModel: viewModel)
    }

    static func createPaymentViewController(input: PaymentViewModel.Input) -> PaymentViewController {
        let viewModel = PaymentViewModel(input: input, store: MerchantStore())

        return PaymentViewController(viewModel: viewModel)
    }

    static func createMerchantListViewController(input: MerchantViewModel.Input) -> MerchantListViewController {
        let viewModel = MerchantViewModel(input: input)
        return MerchantListViewController(viewModel: viewModel)
    }
}
