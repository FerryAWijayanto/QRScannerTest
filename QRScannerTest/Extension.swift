//
//  Extension.swift
//  QRScannerTest
//
//  Created by Ferry Adi Wijayanto on 11/11/23.
//

import UIKit

extension UIViewController {
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Double {
    func formatCurrenyIDR(isHidden: Bool = false, roundingMode: NumberFormatter.RoundingMode = .down, withDecimal: Bool = false) -> String {
        if isHidden {
            return "Rp••••••"
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.roundingMode = roundingMode
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        if !withDecimal {
            numberFormatter.maximumFractionDigits = 0
        }

        let formatedString = numberFormatter.string(from: self as NSNumber)!
        return "Rp\(formatedString)"
    }
}

extension UINavigationController {

    func popToRootViewController(saldo: Double) {
        let vc = self.viewControllers[safe: 0] as! HomeViewController
        vc.viewModel.onUpdateSaldo(saldo: saldo)

        self.popToViewController(vc, animated: true)
    }
}

extension UITableView {
    func register<T:UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    func dequeueReusableCell<T:UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: Self.self)
    }
}
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: Self.self)
    }
}
