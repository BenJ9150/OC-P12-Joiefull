//
//  ReviewRepository.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 30/03/2025.
//

import Foundation

protocol ReviewRepository {

    func saveReviewAndRating(_ reviewAndRating: ReviewAndRating)
    func fetchReviewAndRating(clothingId: Int) -> ReviewAndRating?
}
