//
//  HomeViewController.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var saldoTitleLabel: UILabel!
    @IBOutlet weak var saldoValueLabel: UILabel!
    @IBOutlet weak var scannerView: UIView!

    let viewModel: HomeViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HomeViewModelProtocol) {
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

    private func bindViewModel() {
        viewModel.eventNavigateToScanner
            .sink { [weak self] input in
                self?.navigateToScanner(input: input)
            }.store(in: &cancellables)

        viewModel.eventUpdateSaldo
            .sink { [weak self] updateSaldo in
                self?.saldoValueLabel.text = updateSaldo.formatCurrenyIDR()
            }.store(in: &cancellables)

        viewModel.eventGetMerchantList
            .sink { [weak self] input in
                self?.navigateToMerchantList(input: input)
            }.store(in: &cancellables)
    }

    private func setupUI() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(handleShowMerchantList))
        navigationItem.rightBarButtonItem = rightBarButtonItem

        saldoValueLabel.text = viewModel.saldo.formatCurrenyIDR()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenQR))
        scannerView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleOpenQR(_ sender: UIButton) {
        viewModel.onQRButtonDidTapped()
    }

    @objc private func handleShowMerchantList() {
        viewModel.onShowMerchantListDidTapped()
    }

    private func navigateToScanner(input: ScannerViewModel.Input) {
        let vc = ViewControllerFactory.createQRScannerViewController(input: input)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToMerchantList(input: MerchantViewModel.Input) {
        let vc = ViewControllerFactory.createMerchantListViewController(input: input)
        navigationController?.pushViewController(vc, animated: true)
    }

}
