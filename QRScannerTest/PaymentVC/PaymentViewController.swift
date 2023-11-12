//
//  PaymentViewController.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit
import Combine

class PaymentViewController: UIViewController {

    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var merchantValueLabel: UILabel!
    @IBOutlet weak var nominalValueLabel: UILabel!

    private let viewModel: PaymentViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: PaymentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        idValueLabel.text = viewModel.id
        merchantValueLabel.text = viewModel.merchant
        nominalValueLabel.text = viewModel.nominal
    }

    private func bindViewModel() {
        viewModel.eventPresentPaymentAlert
            .sink { [weak self] (title, message) in
                self?.showSuccessPaymentAlert(title: title, message: message)
            }.store(in: &cancellables)

        viewModel.eventNavigateBackToHome
            .sink { [weak self] saldo in
                self?.navigateBack(saldo: saldo)
            }.store(in: &cancellables)
    }

    @IBAction func paymentBtn(_ sender: UIButton) {
        viewModel.onPaymentDidTapped()
    }

    private func showSuccessPaymentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "Close", style: .default) { _ in
            self.viewModel.onCloseButtonDidTapped()
        }
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    private func navigateBack(saldo: Double) {
        navigationController?.popToRootViewController(saldo: saldo)
    }
}

