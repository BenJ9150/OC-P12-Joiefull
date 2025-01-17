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
        let network = NetworkClient(networking: NetworkingMock(.success))
        let clothingService = ClothingService(networkClient: network)

        // When
        let clothes = try await clothingService.fetchClothes()

        // Then
        XCTAssertTrue(clothes.isEmpty == false)
    }
}
