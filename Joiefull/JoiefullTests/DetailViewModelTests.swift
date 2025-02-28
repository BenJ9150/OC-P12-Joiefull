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
        let viewModel = DetailViewModel(using: MockHTTPClient(with: .success))
        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, false)
        XCTAssertTrue(viewModel.postReviewError == "")
        XCTAssertEqual(viewModel.showReviewError, false)

        // When post review
        await viewModel.postReview(clothingId: 1234)

        // Then there is a success with no error
        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, true)
        XCTAssertTrue(viewModel.postReviewError == "")
        XCTAssertEqual(viewModel.showReviewError, false)
    }

    func testFailedToPostReview() async {
        // Given
        let viewModel = DetailViewModel(using: MockHTTPClient(with: .failed))
        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, false)
        XCTAssertTrue(viewModel.postReviewError == "")
        XCTAssertEqual(viewModel.showReviewError, false)

        // When post review
        await viewModel.postReview(clothingId: 1234)

        // Then there is an error
        XCTAssertEqual(viewModel.postingReview, false)
        XCTAssertEqual(viewModel.postReviewSuccess, false)
        XCTAssertTrue(viewModel.postReviewError != "")
        XCTAssertEqual(viewModel.showReviewError, true)
    }

    // MARK: Like

    func testSuccessToPostLike() async {
        // Given
        let viewModel = DetailViewModel(using: MockHTTPClient(with: .success))
        XCTAssertEqual(viewModel.postingLike, false)
        XCTAssertTrue(viewModel.postLikeError == "")

        // When post review
        await viewModel.postLike(clothingId: 1234)

        // Then there is no error
        XCTAssertEqual(viewModel.postingLike, false)
        XCTAssertTrue(viewModel.postLikeError.isEmpty)
    }

    func testFailedToPostLike() async {
        // Given
        let viewModel = DetailViewModel(using: MockHTTPClient(with: .failed))
        XCTAssertEqual(viewModel.postingLike, false)
        XCTAssertTrue(viewModel.postLikeError == "")

        // When post review
        await viewModel.postLike(clothingId: 1234)

        // Then there is an error
        XCTAssertEqual(viewModel.postingLike, false)
        XCTAssertTrue(viewModel.postLikeError != "")
    }
}
