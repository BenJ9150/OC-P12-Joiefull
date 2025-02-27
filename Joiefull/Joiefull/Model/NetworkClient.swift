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

    func getData(from url: String) async throws -> Data {
        /// Fetch data
        let request = try requestBuilder.build(httpMethod: .get, forUrl: url)
        let (data, response) = try await httpClient.data(for: request)

        /// Check response and return data
        try handleUrlResponse(response)
        return data
    }

    func post(toUrl url: String, body: [String: Any]) async throws {
        /// Post data
        let request = try requestBuilder.build(httpMethod: .post, forUrl: url, httpBody: body)
        let ( _, response) = try await httpClient.data(for: request)

        /// Check response
        try handleUrlResponse(response)
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
