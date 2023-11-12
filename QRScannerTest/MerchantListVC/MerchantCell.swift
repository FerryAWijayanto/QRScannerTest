//
//  MerchantCell.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit

class MerchantCell: UITableViewCell {

    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var merchantValueLabel: UILabel!
    @IBOutlet weak var nominalValueLabel: UILabel!

    static let identifier = "MerchantCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(merchant: Merchant) {
        idValueLabel.text = merchant.id
        merchantValueLabel.text = merchant.merchant
        nominalValueLabel.text = merchant.nominal.formatCurrenyIDR()
    }

}
