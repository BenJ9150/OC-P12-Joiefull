//
//  NetworkingMock.swift
//  JoiefullTests
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation
@testable import Joiefull

class MockHTTPClient {

    enum NetworkResult {
        case success
        case badUrlResponse
        case failed
    }

    // MARK: Private properties

    private let jsonFile = "clothesExample"

    private let statusOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:]
    )!

    private let badUrlResponse = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 400, httpVersion: nil, headerFields: [:]
    )!

    private var dataResult: Result<Data, Error> = .success(Data())
    private var response: HTTPURLResponse = HTTPURLResponse()

    // MARK: Init

    init(with networkResult: NetworkResult) {
        initProperties(networkResult)
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

    func initProperties(_ networkResult: NetworkResult) {
        switch networkResult {
        case .success:
            self.dataResult = .success(getData())
            self.response = statusOK

        case .badUrlResponse:
            self.dataResult = .success(Data())
            self.response = badUrlResponse

        case .failed:
            self.dataResult = .failure(URLError(.cannotLoadFromNetwork))
            self.response = statusOK // not use, error in dataResul is thrown before
        }
    }

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
}
