//
//  MerchantListViewController.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit
import Combine

class MerchantListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel: MerchantViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MerchantViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.onViewDidLoad()
        setupTableView()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.eventUpdateData
            .sink { [weak self] in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }

    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "MerchantCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MerchantCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

}

extension MerchantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.merchantLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MerchantCell.identifier, for: indexPath) as! MerchantCell
        let merchant = viewModel.merchantLists[indexPath.row]
        cell.set(merchant: merchant)
        return cell
    }
}
