//
//  Clothing.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

struct Clothing: Decodable, Identifiable {
    let id: Int
    let picture: Picture
    let name: String
    let category: String
    let likes: Int
    let price: Double
    let originalPrice: Double

    enum CodingKeys: String, CodingKey {
        case id
        case picture
        case name
        case category
        case likes
        case price
        case originalPrice = "original_price"
    }

    var priceToString: String {
        return formattedNumber(for: price)
    }

    var originalPriceString: String {
        return formattedNumber(for: originalPrice)
    }
}

extension Clothing {

    private func formattedNumber(for number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: number)) ?? "\(Int(number))" + "€"
    }
}
