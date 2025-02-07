//
//  HomeViewModelTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 24/01/2025.
//

import XCTest
import Combine
@testable import Joiefull

final class HomeViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    func testSuccessToFetchData() async {
        // Given
        let httpClient = MockHTTPClient(with: .success)

        // When fetch data
        let viewModel = HomeViewModel(using: httpClient)
        await viewModel.fetchClothes()

        // Then there are data with no error
        let errorExpectation = XCTestExpectation(description: "fetchClothesError updated")
        let clothesExpectation = XCTestExpectation(description: "clothesByCategory updated")

        viewModel.$fetchClothesError
            .sink { fetchError in
                XCTAssertTrue(fetchError.isEmpty, "fetchClothesError should be empty")
                errorExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$clothesByCategory
            .sink { clothes in
                print(clothes)
                XCTAssertTrue(clothes.isEmpty == false)
                clothesExpectation.fulfill()
            }
            .store(in: &cancellables)

        // Expectation timeout
        await fulfillment(of: [errorExpectation, clothesExpectation], timeout: 1)
    }

    func testFailedToFetchData() async {
        // Given
        let httpClient = MockHTTPClient(with: .failed)

        // When fetch data
        let viewModel = HomeViewModel(using: httpClient)
        await viewModel.fetchClothes()

        // Then there is an error and no data
        let errorExpectation = XCTestExpectation(description: "fetchClothesError updated")
        let clothesExpectation = XCTestExpectation(description: "clothesByCategory updated")

        viewModel.$fetchClothesError
            .sink { fetchError in
                XCTAssertTrue(fetchError.isEmpty == false)
                errorExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$clothesByCategory
            .sink { clothes in
                XCTAssertTrue(clothes.isEmpty)
                clothesExpectation.fulfill()
            }
            .store(in: &cancellables)

        // Expectation timeout
        await fulfillment(of: [errorExpectation, clothesExpectation], timeout: 1)
    }
}
