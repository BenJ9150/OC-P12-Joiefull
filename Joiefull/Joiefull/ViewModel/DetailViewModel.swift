//
//  DetailViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import SwiftUI
import SwiftData

@MainActor class DetailViewModel: ObservableObject {

    /// Review
    @Published var showReviewAlert: Bool = false
    @Published var postingReview = false
    @Published var postReviewSuccess = false
    @Published var showReviewError = false
    @Published var postReviewError: String = ""
    @Published var review: String = ""
    @Published var rating: Int = 0

    /// Like
    @Published var isFavorite = false {
        didSet {
            isFavoriteToggle()
        }
    }

    private let swiftDataService: SwiftDataService
    private let clothingService: ClothingService
    let clothing: Clothing

    init(modelContext: ModelContext? = nil, for clothing: Clothing, using httpClient: HTTPClient = URLSession.shared) {
        self.clothingService = ClothingService(using: httpClient)
        self.swiftDataService = SwiftDataService(modelContext: modelContext)
        self.clothing = clothing

        /// SwiftData
        fetchReview()
        isFavorite = swiftDataService.isFavorite(clothingId: clothing.id)
    }
}

// MARK: Post review

extension DetailViewModel {

    func postReview() async {
        postingReview = true
        postReviewError = ""
        do {
            try await clothingService.postReview(review, withRating: rating, clothingId: clothing.id)
            /// Success!
            postReviewSuccess = true
            saveReviewAndRating()
        } catch {
            print("💥 Post review failed: \(error)")
            postReviewError = "Oups... Une erreur s'est produite, veuillez réessayer ultérieurement 🙁"
            showReviewError.toggle()
        }
        postingReview = false
    }
}

// MARK: Favorite

extension DetailViewModel {

    private func isFavoriteToggle() {
        guard isFavorite else {
            /// Favorite removed
            swiftDataService.deleteFavorite(clothingId: clothing.id)
            return
        }
        swiftDataService.addToFavorite(clothingId: clothing.id)

        /// Post like  to update the number of likes for other users
        Task {
            /// TODO: When the call will be implemented on the API, if call fails:
            /// Try to make the call later to update the number of likes for other users
            try? await clothingService.postLike(clothingId: clothing.id)
        }
    }
}

// MARK: SwiftData review

extension DetailViewModel {

    private func saveReviewAndRating() {
        let reviewAndRating = ReviewAndRating(clothingId: clothing.id, review: review, rating: rating)
        swiftDataService.saveReviewAndRating(reviewAndRating)
    }

    private func fetchReview() {
        guard let reviewAndRating = swiftDataService.fetchReview(clothingId: clothing.id) else {
            return
        }
        review = reviewAndRating.review
        rating = reviewAndRating.rating
        postReviewSuccess = true
    }
}
