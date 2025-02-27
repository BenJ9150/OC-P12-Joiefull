//
//  HomeViewModelTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 24/01/2025.
//

import XCTest
@testable import Joiefull

@MainActor final class HomeViewModelTests: XCTestCase {

    func testSuccessToFetchData() async {
        // Given
        let httpClient = MockHTTPClient(with: .success)

        // When fetch data
        let viewModel = HomeViewModel(using: httpClient)
        XCTAssertTrue(viewModel.firstLoading)
        XCTAssertTrue(viewModel.fetchClothesError.isEmpty)
        await viewModel.fetchClothes()

        // Then there are data with no error
        XCTAssertFalse(viewModel.firstLoading)
        XCTAssertTrue(viewModel.fetchClothesError.isEmpty)
        XCTAssertFalse(viewModel.clothesByCategory.isEmpty)
    }

    func testFailedToFetchData() async {
        // Given
        let httpClient = MockHTTPClient(with: .failed)

        // When fetch data
        let viewModel = HomeViewModel(using: httpClient)
        XCTAssertTrue(viewModel.firstLoading)
        XCTAssertTrue(viewModel.fetchClothesError.isEmpty)
        await viewModel.fetchClothes()

        // Then there is an error and no data
        XCTAssertFalse(viewModel.firstLoading)
        XCTAssertFalse(viewModel.fetchClothesError.isEmpty)
        XCTAssertTrue(viewModel.clothesByCategory.isEmpty)
    }
}
