//
//  DetailViewModelTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import XCTest
import SwiftData
@testable import Joiefull

@MainActor final class DetailViewModelTests: XCTestCase {

    var container: ModelContainer!
    var modelContext: ModelContext!
    var swiftDataService: SwiftDataService!

    // MARK: Setup

    override func setUpWithError() throws {
        try super.setUpWithError()

        /// SwiftData
        container = try ModelContainer(
            for: ReviewAndRating.self, Favorite.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        modelContext = container.mainContext
        swiftDataService = SwiftDataService(modelContext: modelContext)
    }

    override func tearDown() {
        container = nil
        modelContext = nil
        swiftDataService = nil
        super.tearDown()
    }

    // MARK: Review

    func testSuccessToPostReview() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient(with: .success)
        let clothing = mockHTTPClient.getClothing()

        let viewModel = DetailViewModel(modelContext: modelContext, for: clothing, using: mockHTTPClient)

        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, false)
        XCTAssertTrue(viewModel.postReviewError == "")
        XCTAssertEqual(viewModel.showReviewError, false)

        // When post review
        viewModel.review = "testSuccessToPostReview"
        viewModel.rating = 5
        await viewModel.postReview()

        // Then there is a success with no error...
        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, true)
        XCTAssertTrue(viewModel.postReviewError == "")
        XCTAssertEqual(viewModel.showReviewError, false)

        // ... and review is saved
        let savedReview = swiftDataService.fetchReview(clothingId: clothing.id)
        XCTAssertNotNil(savedReview)
        XCTAssertEqual(savedReview?.clothingId, clothing.id)
        XCTAssertEqual(savedReview?.review, "testSuccessToPostReview")
        XCTAssertEqual(savedReview?.rating, 5)
    }

    func testSuccessToLoadReview() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient(with: .success)
        let clothing = mockHTTPClient.getClothing()

        /// Save review for test
        let reviewAndRating = ReviewAndRating(clothingId: clothing.id, review: "testSuccessToLoadReview", rating: 2)
        swiftDataService.saveReviewAndRating(reviewAndRating)

        // When
        let viewModel = DetailViewModel(modelContext: modelContext, for: clothing, using: mockHTTPClient)

        // Then there is a saved review
        XCTAssertEqual(viewModel.postReviewSuccess, true)
        XCTAssertEqual(viewModel.clothing.id, reviewAndRating.clothingId)
        XCTAssertEqual(viewModel.review, reviewAndRating.review)
        XCTAssertEqual(viewModel.rating, reviewAndRating.rating)
    }

    func testFailedToPostReview() async {
        // Given
        let mockHTTPClient = MockHTTPClient(with: .failed)
        let viewModel = DetailViewModel(for: mockHTTPClient.getClothing(), using: mockHTTPClient)
        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, false)
        XCTAssertTrue(viewModel.postReviewError == "")
        XCTAssertEqual(viewModel.showReviewError, false)

        // When post review
        await viewModel.postReview()

        // Then there is an error
        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, false)
        XCTAssertTrue(viewModel.postReviewError != "")
        XCTAssertEqual(viewModel.showReviewError, true)
    }
}
