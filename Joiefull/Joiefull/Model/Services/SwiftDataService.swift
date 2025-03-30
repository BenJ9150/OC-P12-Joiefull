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

extension SwiftDataService: ReviewRepository {

    func saveReviewAndRating(_ reviewAndRating: ReviewAndRating) {
        modelContext?.insert(reviewAndRating)
        save()
    }

    func fetchReviewAndRating(clothingId: Int) -> ReviewAndRating? {
        let descriptor = FetchDescriptor<ReviewAndRating>(predicate: #Predicate { review in
            review.clothingId == clothingId
        })
        return try? modelContext?.fetch(descriptor).first
    }
}

// MARK: Favorite

extension SwiftDataService: FavoriteRepository {

    func addToFavorite(clothingId: Int) {
        modelContext?.insert(Favorite(clothingId: clothingId))
        save()
    }

    func deleteFavorite(clothingId: Int) {
        if let favorite = fetchFavorite(clothingId: clothingId) {
            modelContext?.delete(favorite)
            save()
        }
    }

    func fetchFavorites() -> [Favorite] {
        let descriptor = FetchDescriptor<Favorite>()
        return (try? modelContext?.fetch(descriptor)) ?? []
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
