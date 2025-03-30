//
//  MockFavoriteRepository.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 30/03/2025.
//

import Foundation
@testable import Joiefull

class MockFavoriteRepository: FavoriteRepository {

    private var favorites: Set<Favorite> = []

    func addToFavorite(clothingId: Int) {
        favorites.insert(Favorite(clothingId: clothingId))
    }

    func deleteFavorite(clothingId: Int) {
        if let favorite = favorites.first(where: { $0.clothingId == clothingId }) {
            favorites.remove(favorite)
        }
    }

    func fetchFavorites() -> [Favorite] {
        return Array(favorites)
    }
}
