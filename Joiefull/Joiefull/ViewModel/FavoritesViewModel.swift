//
//  FavoritesViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 14/03/2025.
//

import SwiftUI
import SwiftData

@MainActor class FavoritesViewModel: ObservableObject {

    @Published var favorites: [Favorite] = []

    private let swiftDataService: SwiftDataService
    private let clothingService: ClothingService

    // MARK: Init

    init(modelContext: ModelContext? = nil, using httpClient: HTTPClient = URLSession.shared) {
        self.clothingService = ClothingService(using: httpClient)
        self.swiftDataService = SwiftDataService(modelContext: modelContext)

        /// Fetch favorites
        favorites = swiftDataService.fetchFavorites()
    }
}

// MARK: Is favorite

extension FavoritesViewModel {

    func isFavorite(clothingId: Int) -> Bool {
        favorites.contains { $0.clothingId == clothingId }
    }
}

// MARK: Add or delete

extension FavoritesViewModel {

    func addToFavorite(clothingId: Int) {
        swiftDataService.addToFavorite(clothingId: clothingId)
        postLike(clothingId: clothingId, isLiked: true)
    }

    func deleteFavorite(clothingId: Int) {
        swiftDataService.deleteFavorite(clothingId: clothingId)
        postLike(clothingId: clothingId, isLiked: false)
    }

    private func postLike(clothingId: Int, isLiked: Bool) {
        /// Update favorites for views
        favorites = swiftDataService.fetchFavorites()

        /// Post like or dislike to update the number of likes for other users
        Task(priority: .background) {
            try? await clothingService.postLike(clothingId: clothingId, isLiked: isLiked)
            /// TODO: When the call will be implemented on the API, if call fails:
            /// Try to make the call later to update the number of likes for other users
        }
    }
}
