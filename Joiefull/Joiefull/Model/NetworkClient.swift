//
//  NetworkClient.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

class NetworkClient {

    private let httpClient: HTTPClient

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
    }
}

// MARK: Fetch data

extension NetworkClient {

    func data(from urlString: String) async throws -> Data {
        /// Check if URL is valid
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        /// Build request
        var request = URLRequest(url: url)
        /// Ignore cache to be sure that correct prices are displayed
        request.cachePolicy = .reloadIgnoringLocalCacheData

        /// Fetch data
        let (data, response) = try await httpClient.data(for: request)

        /// Check response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
