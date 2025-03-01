//
//  HomeViewModelTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 24/01/2025.
//

import XCTest
@testable import Joiefull

@MainActor final class HomeViewModelTests: XCTestCase {

    func testFetchClothesSuccess() async {
        // Given
        let viewModel = HomeViewModel(using: MockHTTPClient(with: .success))
        XCTAssertEqual(viewModel.firstLoading, true)
        XCTAssertTrue(viewModel.fetchClothesError == "")
        XCTAssertTrue(viewModel.clothesByCategory.count == 0)

        // When fetch data
        await viewModel.fetchClothes()

        // Then there are data with no error
        XCTAssertEqual(viewModel.firstLoading, false)
        XCTAssertTrue(viewModel.fetchClothesError == "")
        XCTAssertTrue(viewModel.clothesByCategory.count > 0)
    }

    func testFailedToFetchData() async {
        // When fetch data
        let viewModel = HomeViewModel(using: MockHTTPClient(with: .failed))
        XCTAssertEqual(viewModel.firstLoading, true)
        XCTAssertTrue(viewModel.fetchClothesError == "")
        XCTAssertTrue(viewModel.clothesByCategory.isEmpty)

        // When fetch data
        await viewModel.fetchClothes()

        // Then there is an error and no data
        XCTAssertEqual(viewModel.firstLoading, false)
        XCTAssertTrue(viewModel.fetchClothesError != "")
        XCTAssertTrue(viewModel.clothesByCategory.isEmpty)
    }
}
