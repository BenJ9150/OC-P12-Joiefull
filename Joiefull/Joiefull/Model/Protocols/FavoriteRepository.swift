//
//  FavoriteRepository.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 30/03/2025.
//

import Foundation

protocol FavoriteRepository {

    func addToFavorite(clothingId: Int)
    func deleteFavorite(clothingId: Int)
    func fetchFavorites() -> [Favorite]
}
