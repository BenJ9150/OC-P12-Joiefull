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

    func test_addAndFetchReviewSuccess() throws {
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

    func test_addAndFetchReviewFailure() throws {
        // Given
        let review = ReviewAndRating(clothingId: 1234, review: "test", rating: 4)
        let service = SwiftDataService(modelContext: nil)

        // When
        service.saveReviewAndRating(review)

        // Then
        let savedReview = service.fetchReview(clothingId: 1234)
        XCTAssertNil(savedReview)
    }
}
