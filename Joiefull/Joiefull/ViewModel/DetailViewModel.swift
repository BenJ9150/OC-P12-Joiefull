//
//  DetailViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import SwiftUI
import SwiftData

@MainActor class DetailViewModel: ObservableObject {

    @Published var showReviewAlert: Bool = false
    @Published var postingReview = false
    @Published var postReviewSuccess = false
    @Published var showReviewError = false
    @Published var postReviewError: String = ""
    @Published var review: String = ""
    @Published var rating: Int = 0

    private let reviewRepo: ReviewRepository
    private let clothingService: ClothingService
    let clothing: Clothing

    // MARK: Init

    init(for clothing: Clothing, reviewRepo: ReviewRepository, using httpClient: HTTPClient = URLSession.shared) {
        self.clothingService = ClothingService(using: httpClient)
        self.reviewRepo = reviewRepo
        self.clothing = clothing

        /// Fetch saved review if exist
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

// MARK: Save or fetch review

extension DetailViewModel {

    private func saveReviewAndRating() {
        let reviewAndRating = ReviewAndRating(clothingId: clothing.id, review: review, rating: rating)
        reviewRepo.saveReviewAndRating(reviewAndRating)
    }

    private func fetchReview() {
        guard let reviewAndRating = reviewRepo.fetchReviewAndRating(clothingId: clothing.id) else {
            return
        }
        review = reviewAndRating.review
        rating = reviewAndRating.rating
        postReviewSuccess = true
    }
}
