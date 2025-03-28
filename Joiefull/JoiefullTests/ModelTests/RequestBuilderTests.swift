//
//  RequestBuilderTests.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import XCTest
@testable import Joiefull

final class RequestBuilderTests: XCTestCase {

    // MARK: Build GET

    func testValidGet() throws {
        // Given
        let url = URL(string: "www.joifull-test.com")

        // When
        let request = try RequestBuilder().build(httpMethod: .get, url: url)

        // Then
        XCTAssertNotNil(request.url)
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertNil(request.httpBody)
    }

    // MARK: Build POST

    func testValidPost() throws {
        // Given
        let url = URL(string: "www.joifull-test.com")
        let body: [String: Any] = ["id": 1234, "name": "John"]

        // When
        let request = try RequestBuilder().build(httpMethod: .post, url: url, httpBody: body)

        // Then
        if let bodyResult = try JSONSerialization.jsonObject(with: request.httpBody!) as? [String: Any] {
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertEqual(bodyResult["id"] as? Int, 1234)
            XCTAssertEqual(bodyResult["name"] as? String, "John")
        } else {
            XCTFail("Error when parsing JSON body.")
        }
    }

    // MARK: Invalid URL

    func testInvalidUrl() {
        // Given
        let invalidURL = URL(string: "ht!tp://invalid-url")

        // When
        do {
            _ = try RequestBuilder().build(httpMethod: .get, url: invalidURL)
            XCTFail("Expected URLError(.badURL), but no error was thrown.")

        } catch let urlError as URLError {
            // Then
            XCTAssertEqual(urlError.code, .badURL)
        } catch {
            XCTFail("Expected URLError, but got \(error).")
        }
    }
}
