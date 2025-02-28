//
//  DetailViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import SwiftUI

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

    private let clothingService: ClothingService

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.clothingService = ClothingService(using: httpClient)
    }
}

// MARK: Post review

extension DetailViewModel {

    func postReview(clothingId: Int) async {
        postingReview = true
        postReviewError = ""
        do {
            try await clothingService.postReview(review, withRating: rating, clothingId: clothingId)
            postReviewSuccess = true
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

    func postLike(clothingId: Int) async {
        postingLike = true
        postLikeError = ""
        do {
            try await clothingService.postLike(clothingId: clothingId)
        } catch {
            withAnimation(.bouncy) {
                print("💥 Post like failed: \(error)")
                postLikeError = "Oups... Une erreur s'est produite, veuillez réessayer."
            }
        }
        postingLike = false
    }
}
