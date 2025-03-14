//
//  FavoritesViewModelTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 14/03/2025.
//

import XCTest
import SwiftData
@testable import Joiefull

@MainActor final class FavoritesViewModelTests: XCTestCase {

    func testAddAndDeleteFavorite() throws {
        // Given
        let container = try ModelContainer(
            for: ReviewAndRating.self, Favorite.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        let swiftDataService = SwiftDataService(modelContext: container.mainContext)
        let viewModel = FavoritesViewModel(modelContext: container.mainContext, using: MockHTTPClient(with: .success))
        XCTAssertEqual(viewModel.isFavorite(clothingId: 1234), false)
        XCTAssertEqual(swiftDataService.fetchFavorites().count, 0)

        // When add...
        viewModel.addToFavorite(clothingId: 1234)
        XCTAssertEqual(viewModel.isFavorite(clothingId: 1234), true)

        let favorites = swiftDataService.fetchFavorites()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.clothingId, 1234)

        // ... and delete
        viewModel.deleteFavorite(clothingId: 1234)

        // Then
        XCTAssertEqual(viewModel.isFavorite(clothingId: 1234), false)
        XCTAssertEqual(swiftDataService.fetchFavorites().count, 0)
    }
}
