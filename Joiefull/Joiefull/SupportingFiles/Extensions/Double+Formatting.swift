//
//  Double+Formatting.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 30/01/2025.
//

import Foundation

extension Double {

    func toEuros() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return (formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))") + "€"
    }

    func toString(locale: Locale = Locale.current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.locale = locale

        return (formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))")
    }
}
