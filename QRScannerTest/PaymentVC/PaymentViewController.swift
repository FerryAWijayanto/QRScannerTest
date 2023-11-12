//
//  PaymentViewController.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var merchantValueLabel: UILabel!
    @IBOutlet weak var nominalValueLabel: UILabel!

    private let viewModel: PaymentViewModelProtocol

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
    }

    private func setupUI() {
        idValueLabel.text = viewModel.id
        merchantValueLabel.text = viewModel.merchant
        nominalValueLabel.text = viewModel.nominal
    }

    @IBAction func paymentBtn(_ sender: UIButton) {
        viewModel.onPaymentDidTapped()
    }
}

