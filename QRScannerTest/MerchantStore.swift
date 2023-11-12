//
//  MerchantStore.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import Foundation

protocol MerchantStoreProtocol {
    func saveListMerchant(list: [Merchant])
    func getListMerchant() -> [Merchant]
}

final class MerchantStore: MerchantStoreProtocol {

    private let defaults = UserDefaults.standard
    private let merchantKey = "merchantKey"

    func saveListMerchant(list: [Merchant]) {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(list)
            defaults.set(encoded, forKey: merchantKey)
            defaults.synchronize()
        } catch {
            print("Failed to save list")
        }
    }

    func getListMerchant() -> [Merchant] {
        do {
            guard let data = defaults.data(forKey: merchantKey) else { return [] }
            let decoder = JSONDecoder()
            let list = try decoder.decode([Merchant].self, from: data)

            print("List: ", list)
            return list
        } catch {
            print("Failed to retrieve data")
            return []
        }
    }
}
