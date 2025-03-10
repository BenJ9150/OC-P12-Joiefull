//
//  SwiftDataService.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 01/03/2025.
//

import Foundation
import SwiftData

class SwiftDataService {

    let modelContext: ModelContext?

    init(modelContext: ModelContext?) {
        self.modelContext = modelContext
    }
}

// MARK: Review

extension SwiftDataService {

    func saveReviewAndRating(_ reviewAndRating: ReviewAndRating) {
        modelContext?.insert(reviewAndRating)
        save()
    }

    func fetchReview(clothingId: Int) -> ReviewAndRating? {
        let descriptor = FetchDescriptor<ReviewAndRating>(predicate: #Predicate { review in
            review.clothingId == clothingId
        })
        return try? modelContext?.fetch(descriptor).first
    }
}

// MARK: Favorite

extension SwiftDataService {

    func addToFavorite(clothingId: Int) {
        modelContext?.insert(Favorite(clothingId: clothingId))
        save()
    }

    func isFavorite(clothingId: Int) -> Bool {
        if fetchFavorite(clothingId: clothingId) != nil {
            return true
        }
        return false
    }

    func deleteFavorite(clothingId: Int) {
        if let favorite = fetchFavorite(clothingId: clothingId) {
            modelContext?.delete(favorite)
            save()
        }
    }

    private func fetchFavorite(clothingId: Int) -> Favorite? {
        let descriptor = FetchDescriptor<Favorite>(predicate: #Predicate { favorite in
            favorite.clothingId == clothingId
        })
        return try? modelContext?.fetch(descriptor).first
    }
}

// MARK: Save

extension SwiftDataService {

    private func save() {
        try? modelContext?.save()
    }
}
