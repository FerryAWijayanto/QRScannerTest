//
//  HomeViewController.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var saldoTitleLabel: UILabel!
    @IBOutlet weak var saldoValueLabel: UILabel!
    @IBOutlet weak var scannerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenQR))
        scannerView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleOpenQR(_ sender: UIButton) {
        let vc = ViewControllerFactory.createQRScannerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
