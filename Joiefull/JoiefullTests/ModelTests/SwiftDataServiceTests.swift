//
//  SwiftDataServiceTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2025.
//

import XCTest
import SwiftData
@testable import Joiefull

@MainActor final class SwiftDataServiceTests: XCTestCase {

    // MARK: Review

    func testAddAndFetchReviewSuccess() throws {
        // Given
        let review = ReviewAndRating(clothingId: 1234, review: "test", rating: 4)
        let container = try ModelContainer(for: ReviewAndRating.self, configurations: .init(isStoredInMemoryOnly: true))
        let service = SwiftDataService(modelContext: container.mainContext)

        // When
        service.saveReviewAndRating(review)

        // Then
        let savedReview = service.fetchReview(clothingId: 1234)
        XCTAssertNotNil(savedReview)
        XCTAssertEqual(savedReview?.clothingId, 1234)
        XCTAssertEqual(savedReview?.review, "test")
        XCTAssertEqual(savedReview?.rating, 4)
    }

    func testAddAndFetchReviewFailure() {
        // Given
        let review = ReviewAndRating(clothingId: 1234, review: "test", rating: 4)
        let service = SwiftDataService(modelContext: nil)

        // When
        service.saveReviewAndRating(review)

        // Then
        let savedReview = service.fetchReview(clothingId: 1234)
        XCTAssertNil(savedReview)
    }

    // MARK: Favorite

    func testAddAndDeleteFavorite() throws {
        // Given
        let clothingId: Int = 1234
        let container = try ModelContainer(for: Favorite.self, configurations: .init(isStoredInMemoryOnly: true))
        let service = SwiftDataService(modelContext: container.mainContext)
        XCTAssertEqual(service.isFavorite(clothingId: clothingId), false)

        // When
        service.addToFavorite(clothingId: clothingId)
        XCTAssertEqual(service.isFavorite(clothingId: clothingId), true)
        service.deleteFavorite(clothingId: clothingId)

        // Then
        XCTAssertEqual(service.isFavorite(clothingId: clothingId), false)
    }
}
