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

// MARK: Private

private extension SwiftDataService {

    private func save() {
        try? modelContext?.save()
    }
}
