//
//  ClothingServiceTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import XCTest
@testable import Joiefull

final class ClothingServiceTests: XCTestCase {

    func testSuccessToFetchData() async throws {
        // Given
        let clothingService = ClothingService(using: MockHTTPClient(with: .success))

        // When
        let clothes = try await clothingService.fetchClothes()

        // Then
        XCTAssertTrue(clothes.isEmpty == false)
        XCTAssertEqual(clothes[0].price.toEuros(), "69,99€")
        XCTAssertEqual(clothes[0].originalPrice.toEuros(), "69,99€")
        XCTAssertEqual(clothes[0].rating.toString(), "4,3")
    }
}
