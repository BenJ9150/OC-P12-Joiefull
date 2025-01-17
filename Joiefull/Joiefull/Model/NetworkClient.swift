//
//  NetworkClient.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

class NetworkClient {

    private let networking: Networking

    init(networking: Networking = URLSession.shared) {
        self.networking = networking
    }
}

// MARK: Fetch data

extension NetworkClient {

    func data(from urlString: String) async throws -> Data {
        // Check if URL is valid
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        // Fetch data
        let (data, response) = try await networking.data(from: url)

        // Check response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}