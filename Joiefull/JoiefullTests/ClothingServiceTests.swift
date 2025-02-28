//
//  ClothingServiceTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import XCTest
@testable import Joiefull

final class ClothingServiceTests: XCTestCase {

    // MARK: fetch clothes

    func testFetchClothesSuccess() async throws {
        // Given
        let clothingService = ClothingService(using: MockHTTPClient(with: .success))

        // When
        let clothes = try await clothingService.fetchClothes()

        // Then
        XCTAssertTrue(clothes.count > 0)
        XCTAssertEqual(clothes[0].price.toEuros(), "69,99€")
        XCTAssertEqual(clothes[0].originalPrice.toEuros(), "69,99€")
        XCTAssertEqual(clothes[0].rating.toString(), "4,3")
    }

    // MARK: Post data

    func testReviewSuccess() async {
        // Given
        let clothingService = ClothingService(using: MockHTTPClient(with: .success))

        // When
        do {
            try await clothingService.postReview("My review", withRating: 5, clothingId: 1234)
            // Then the post method is executed without error.
        } catch {
            XCTFail("Expected success when post data, but got \(error).")
        }
    }

    func testLikeSuccess() async {
        // Given
        let clothingService = ClothingService(using: MockHTTPClient(with: .success))

        // When
        do {
            try await clothingService.postLike(clothingId: 1234)
            // Then the post method is executed without error.
        } catch {
            XCTFail("Expected success when post data, but got \(error).")
        }
    }
}
