//
//  Merchant.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation

struct Merchant: Codable {
    var id: String = ""
    var source: String = ""
    var merchant: String = ""
    var transaction: String = ""
    var nominal: Double = 0
}
