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
    @Published var postingLike = false
    @Published var postLikeError = ""

    private let swiftDataService: SwiftDataService
    private let clothingService: ClothingService
    let clothing: Clothing

    init(modelContext: ModelContext? = nil, for clothing: Clothing, using httpClient: HTTPClient = URLSession.shared) {
        self.clothingService = ClothingService(using: httpClient)
        self.swiftDataService = SwiftDataService(modelContext: modelContext)
        self.clothing = clothing
        fetchReview()
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

// MARK: Post like

extension DetailViewModel {

    func postLike() async {
        postingLike = true
        postLikeError = ""
        do {
            try await clothingService.postLike(clothingId: clothing.id)
        } catch {
            withAnimation(.bouncy) {
                print("💥 Post like failed: \(error)")
                postLikeError = "Oups... Une erreur s'est produite, veuillez réessayer."
            }
        }
        postingLike = false
    }
}

// MARK: SwiftData review

private extension DetailViewModel {

    func saveReviewAndRating() {
        let reviewAndRating = ReviewAndRating(clothingId: clothing.id, review: review, rating: rating)
        swiftDataService.saveReviewAndRating(reviewAndRating)
    }

    func fetchReview() {
        guard let reviewAndRating = swiftDataService.fetchReview(clothingId: clothing.id) else {
            return
        }
        review = reviewAndRating.review
        rating = reviewAndRating.rating
        postReviewSuccess = true
    }
}
