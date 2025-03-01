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
        guard let modelContext else { return }
        modelContext.insert(reviewAndRating)
        save()
    }
    
    func fetchReview(clothingId: Int) -> ReviewAndRating? {
        guard let modelContext else { return nil }
        let descriptor = FetchDescriptor<ReviewAndRating>(predicate: #Predicate { review in
            review.clothingId == clothingId
        })
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("Failed to fetch review: \(error)")
            return nil
        }
    }
}

// MARK: Private

private extension SwiftDataService {

    private func save() {
        do {
            try modelContext?.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
