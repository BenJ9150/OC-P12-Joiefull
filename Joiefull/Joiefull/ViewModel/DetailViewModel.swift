//
//  DetailViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import SwiftUI

@MainActor class DetailViewModel: ObservableObject {

    /// Review
    @Published var postingReview = false
    @Published var postReviewError = ""
    @State var review: String = ""
    @State var rating: Int = 0

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
        } catch {
            withAnimation(.bouncy) {
                postReviewError = "Oups... Une erreur s'est produite, veuillez réessayer."
            }
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
                postLikeError = "Oups... Une erreur s'est produite, veuillez réessayer."
            }
        }
        postingLike = false
    }
}
