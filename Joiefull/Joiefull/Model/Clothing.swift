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
    let rating: Double = 4.3

    enum CodingKeys: String, CodingKey {
        case id
        case picture
        case name
        case category
        case likes
        case price
        case originalPrice = "original_price"
    }
}
