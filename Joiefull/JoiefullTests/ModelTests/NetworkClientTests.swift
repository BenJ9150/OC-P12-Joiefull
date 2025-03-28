//
//  NetworkClientTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import XCTest
@testable import Joiefull

final class NetworkClientTests: XCTestCase {

    // MARK: Error

    func testBadServerResponse() async {
        // Given
        let networkClient = NetworkClient(using: MockHTTPClient(with: .badServerResponse))

        // When
        do {
            _ = try await networkClient.getData(endpoint: .getClothes)
            XCTFail("Expected URLError(.badServerResponse), but no error was thrown.")

        } catch let urlError as URLError {
            // Then
            XCTAssertEqual(urlError.code, .badServerResponse)
        } catch {
            XCTFail("Expected URLError, but got \(error).")
        }
    }

    func testBadStatusCode() async {
        // Given
        let networkClient = NetworkClient(using: MockHTTPClient(with: .badStatusCode))

        // When
        do {
            _ = try await networkClient.getData(endpoint: .getClothes)
            XCTFail("Expected HTTPError(.badServerResponse), but no error was thrown.")

        } catch let nsError as NSError {
            // Then
            XCTAssertEqual(nsError.domain, "HTTPError")
            XCTAssertEqual(nsError.code, 400)
        } catch {
            XCTFail("Expected NSError, but got \(error).")
        }
    }

    func testFetchDataFailure() async {
        // Given
        let networkClient = NetworkClient(using: MockHTTPClient(with: .failed))

        // When
        do {
            _ = try await networkClient.getData(endpoint: .getClothes)
            XCTFail("Expected URLError(.cannotLoadFromNetwork), but no error was thrown.")

        } catch let urlError as URLError {
            // Then
            XCTAssertEqual(urlError.code, .cannotLoadFromNetwork)
        } catch {
            XCTFail("Expected URLError, but got \(error).")
        }
    }

    // MARK: Get valid Data

    func testSuccessToFetchData() async throws {
        // Given
        let networkClient = NetworkClient(using: MockHTTPClient(with: .success))

        // When
        let fetchedData = try await networkClient.getData(endpoint: .getClothes)

        // Then
        XCTAssertTrue(fetchedData.count > 0)
    }

    // MARK: Post data

    func testSuccessToPostData() async {
        // Given
        let body: [String: Any] = ["id": 1234, "name": "John"]
        let networkClient = NetworkClient(using: MockHTTPClient(with: .success))

        // When
        do {
            try await networkClient.post(endpoint: .postReview, body: body)
            // Then the post method is executed without error.
        } catch {
            XCTFail("Expected success when post data, but got \(error).")
        }
    }
}
