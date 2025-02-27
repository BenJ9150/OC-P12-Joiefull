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

    func testSuccessToPostReview() async {
        // Given
        let httpClient = MockHTTPClient(with: .success)

        // When post review
        let viewModel = DetailViewModel(using: httpClient)
        XCTAssertFalse(viewModel.postingReview)
        XCTAssertTrue(viewModel.postReviewError.isEmpty)
        await viewModel.postReview(clothingId: 1234)

        // Then there is no error
        XCTAssertFalse(viewModel.postingReview)
        XCTAssertTrue(viewModel.postReviewError.isEmpty)
    }

    func testFailedToPostReview() async {
        // Given
        let httpClient = MockHTTPClient(with: .failed)

        // When post review
        let viewModel = DetailViewModel(using: httpClient)
        XCTAssertFalse(viewModel.postingReview)
        XCTAssertTrue(viewModel.postReviewError.isEmpty)
        await viewModel.postReview(clothingId: 1234)

        // Then there an error
        XCTAssertFalse(viewModel.postingReview)
        XCTAssertFalse(viewModel.postReviewError.isEmpty)
    }

    // MARK: Like

    func testSuccessToPostLike() async {
        // Given
        let httpClient = MockHTTPClient(with: .success)

        // When post review
        let viewModel = DetailViewModel(using: httpClient)
        XCTAssertFalse(viewModel.postingLike)
        XCTAssertTrue(viewModel.postLikeError.isEmpty)
        await viewModel.postLike(clothingId: 1234)

        // Then there is no error
        XCTAssertFalse(viewModel.postingLike)
        XCTAssertTrue(viewModel.postLikeError.isEmpty)
    }

    func testFailedToPostLike() async {
        // Given
        let httpClient = MockHTTPClient(with: .failed)

        // When post review
        let viewModel = DetailViewModel(using: httpClient)
        XCTAssertFalse(viewModel.postingLike)
        XCTAssertTrue(viewModel.postLikeError.isEmpty)
        await viewModel.postLike(clothingId: 1234)

        // Then there an error
        XCTAssertFalse(viewModel.postingLike)
        XCTAssertFalse(viewModel.postLikeError.isEmpty)
    }
}
