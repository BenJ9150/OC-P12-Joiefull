//
//  MockHTTPClient.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation
@testable import Joiefull

class MockHTTPClient {

    enum NetworkResult {
        case success
        case badServerResponse
        case badStatusCode
        case failed
    }

    // MARK: Private properties

    private let jsonFile = "clothesExample"
    private var dataResult: Result<Data, Error> = .success(Data())
    private var response: URLResponse = URLResponse()

    // MARK: Init

    init(with result: NetworkResult) {
        switch result {
        case .success:
            self.dataResult = .success(getData())
            self.response = buildHttpResponse(withCode: 200)

        case .badStatusCode:
            self.response = buildHttpResponse(withCode: 400)

        case .failed:
            self.dataResult = .failure(URLError(.cannotLoadFromNetwork))

        case .badServerResponse:
            /// Return just an URLResponse()  and not HTTPURLResponse()
            break
        }
    }

    func getClothing() -> Clothing {
        do {
            let clothes = try JSONDecoder().decode([Clothing].self, from: getData())
            return clothes[0]
        } catch {
            fatalError("Error when decode JSON clothes")
        }
    }
}

// MARK: Networking protocol

extension MockHTTPClient: HTTPClient {

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try (dataResult.get(), response)
    }
}

// MARK: Private methods

private extension MockHTTPClient {

    func getData() -> Data {
        // Get bundle for json localization
        let bundle = Bundle(for: MockHTTPClient.self)

        // Create url
        guard let url = bundle.url(forResource: jsonFile, withExtension: "json") else {
            return Data()
        }
        // Return data
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return Data()
        }
    }

    func buildHttpResponse(withCode code: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: "www.joifull-test.com")!,
            statusCode: code, httpVersion: nil, headerFields: [:]
        )!
    }
}
