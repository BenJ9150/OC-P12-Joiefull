//
//  MockReviewRepository.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 30/03/2025.
//

import Foundation
@testable import Joiefull

class MockReviewRepository: ReviewRepository {

    private var reviews: Set<ReviewAndRating> = []

    func saveReviewAndRating(_ reviewAndRating: ReviewAndRating) {
        reviews.insert(reviewAndRating)
    }

    func fetchReviewAndRating(clothingId: Int) -> ReviewAndRating? {
        if let review = reviews.first(where: { $0.clothingId == clothingId }) {
            return review
        }
        return nil
    }
}
