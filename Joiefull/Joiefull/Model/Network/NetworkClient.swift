//
//  NetworkClient.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

class NetworkClient {

    private let httpClient: HTTPClient
    private let requestBuilder = RequestBuilder()

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
    }
}

// MARK: Public

extension NetworkClient {

    func getData(endpoint: Endpoint) async throws -> Data {
        /// Fetch data
        let request = try requestBuilder.build(httpMethod: .get, url: endpoint.url)
        let (data, response) = try await httpClient.data(for: request)

        /// Check response and return data
        try handleUrlResponse(response)
        return data
    }

    func post(endpoint: Endpoint, body: [String: Any]) async throws {
        /// Post data
        let request = try requestBuilder.build(httpMethod: .post, url: endpoint.url, httpBody: body)
        let ( _, response) = try await httpClient.data(for: request)

        /// Check response
#if DEBUG
        /// Post methods are not implemented on Joiefull API
        /// So skip handle response for development (use handleUrlResponse only on unit test)
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            /// Unit test: test final code
            try handleUrlResponse(response)
        }
#else
        try handleUrlResponse(response)
#endif
    }
}

// MARK: Private

private extension NetworkClient {

    func handleUrlResponse(_ response: URLResponse) throws {
        /// Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        /// Check status code
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTPError", code: httpResponse.statusCode)
        }
    }
}
