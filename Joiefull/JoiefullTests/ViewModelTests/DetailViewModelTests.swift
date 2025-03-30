//
//  DetailViewModelTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import XCTest
@testable import Joiefull

@MainActor final class DetailViewModelTests: XCTestCase {

    // MARK: Review

    func testSuccessToPostReview() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient(with: .success)
        let clothing = mockHTTPClient.getClothing()
        let reviewRepo = MockReviewRepository()

        let viewModel = DetailViewModel(for: clothing, reviewRepo: reviewRepo, using: mockHTTPClient)

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
        let savedReview = reviewRepo.fetchReviewAndRating(clothingId: clothing.id)
        XCTAssertNotNil(savedReview)
        XCTAssertEqual(savedReview?.clothingId, clothing.id)
        XCTAssertEqual(savedReview?.review, "testSuccessToPostReview")
        XCTAssertEqual(savedReview?.rating, 5)
    }

    func testSuccessToLoadReview() async throws {
        // Given
        let mockHTTPClient = MockHTTPClient(with: .success)
        let clothing = mockHTTPClient.getClothing()
        let reviewRepo = MockReviewRepository()

        /// Save review for test
        let reviewAndRating = ReviewAndRating(clothingId: clothing.id, review: "testSuccessToLoadReview", rating: 2)
        reviewRepo.saveReviewAndRating(reviewAndRating)

        // When
        let viewModel = DetailViewModel(for: clothing, reviewRepo: reviewRepo, using: mockHTTPClient)

        // Then there is a saved review
        XCTAssertEqual(viewModel.postReviewSuccess, true)
        XCTAssertEqual(viewModel.clothing.id, reviewAndRating.clothingId)
        XCTAssertEqual(viewModel.review, reviewAndRating.review)
        XCTAssertEqual(viewModel.rating, reviewAndRating.rating)
    }

    func testFailedToPostReview() async {
        // Given
        let mockHTTPClient = MockHTTPClient(with: .failed)
        let clothing = mockHTTPClient.getClothing()

        let viewModel = DetailViewModel(for: clothing, reviewRepo: MockReviewRepository(), using: mockHTTPClient)
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
