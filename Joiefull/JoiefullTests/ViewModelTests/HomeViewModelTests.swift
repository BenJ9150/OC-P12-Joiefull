//
//  HomeViewModelTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 24/01/2025.
//

import XCTest
@testable import Joiefull

@MainActor final class HomeViewModelTests: XCTestCase {

    // MARK: Fetch clothes

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

    func testFetchClothesFailure() async {
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

    // MARK: Open clothing from url

    func testOpenClothingSuccess() async {
        // Given
        let viewModel = HomeViewModel(using: MockHTTPClient(with: .success))
        await viewModel.fetchClothes()
        guard let firstClothing = viewModel.clothesByCategory.values.first?.first else {
            XCTFail("HomeViewModel as not fetched any data")
            return
        }
        XCTAssertNil(viewModel.selectedItem)

        // When
        viewModel.opendDetails(from: firstClothing.shareURL!)

        // Then
        XCTAssertEqual(viewModel.selectedItem, firstClothing)
    }

    func testOpenClothingFailure() async {
        // Given
        let viewModel = HomeViewModel(using: MockHTTPClient(with: .success))

        // When
        viewModel.opendDetails(from: URL(string: "www.joifull-test.com")!)

        // Then
        XCTAssertNil(viewModel.selectedItem)
    }
}
