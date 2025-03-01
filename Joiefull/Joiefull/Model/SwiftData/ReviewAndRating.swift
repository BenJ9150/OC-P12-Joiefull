//
//  ReviewAndRating.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 01/03/2025.
//

import Foundation
import SwiftData

@Model class ReviewAndRating {

    var clothingId: Int
    var review: String
    var rating: Int

    init(clothingId: Int, review: String, rating: Int) {
        self.clothingId = clothingId
        self.review = review
        self.rating = rating
    }
}
