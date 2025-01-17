//
//  NetworkClientTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import XCTest
@testable import Joiefull

final class NetworkClientTests: XCTestCase {

    func testValidData() async throws {
        // Given
        let networkClient = NetworkClient(networking: NetworkingMock(.success))

        // When
        let fetchedData = try await networkClient.data(from: "www.joifull-test.com")

        // Then
        XCTAssertTrue(fetchedData.isEmpty == false)
    }

    func testBadUrlResponse() async throws {
        // Given
        let networkClient = NetworkClient(networking: NetworkingMock(.badUrlResponse))

        // When
        do {
            _ = try await networkClient.data(from: "www.joifull-test.com")
            XCTFail("Expected URLError(.badServerResponse), but no error was thrown.")

        } catch let urlError as URLError {

            // Then
            XCTAssertEqual(urlError.code, .badServerResponse)

        } catch {
            XCTFail("Expected URLError, but got \(error).")
        }
    }

    func testBadRequest() async throws {
        // Given
        let networkClient = NetworkClient(networking: NetworkingMock(.failed))

        // When
        do {
            _ = try await networkClient.data(from: "www.joifull-test.com")
            XCTFail("Expected URLError(.cannotLoadFromNetwork), but no error was thrown.")

        } catch let urlError as URLError {

            // Then
            XCTAssertEqual(urlError.code, .cannotLoadFromNetwork)

        } catch {
            XCTFail("Expected URLError, but got \(error).")
        }
    }

    func testBadUrl() async {
        // Given
        let invalidURL = "ht!tp://invalid-url"

        // When
        do {
            _ = try await NetworkClient().data(from: invalidURL)
            XCTFail("Expected URLError(.badURL), but no error was thrown.")

        } catch let urlError as URLError {

            // Then
            XCTAssertEqual(urlError.code, .badURL)

        } catch {
            XCTFail("Expected URLError, but got \(error).")
        }
    }
}
