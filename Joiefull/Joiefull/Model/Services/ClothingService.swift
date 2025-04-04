//
//  ClothingService.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

class ClothingService {

    private let networkClient: NetworkClient

    init(using httpClient: HTTPClient = URLSession(configuration: .ephemeral)) {
        self.networkClient = NetworkClient(using: httpClient)
    }
}

// MARK: Public

extension ClothingService {

    func fetchClothes() async throws -> [Clothing] {
        /// Fetch data
        let data = try await networkClient.getData(endpoint: .getClothes)

        /// Try return decoded data
        return try JSONDecoder().decode([Clothing].self, from: data)
    }

    func postReview(_ review: String, withRating rating: Int, clothingId: Int) async throws {
        /// Build http body
        let body: [String: Any] = [
            "clothing_id": clothingId,
            "review": review,
            "rating": rating
        ]
        /// Post data
        try await networkClient.post(endpoint: .postReview, body: body)
    }

    func postLike(clothingId: Int, isLiked: Bool) async throws {
        /// Post data
        try await networkClient.post(
            endpoint: .postLike,
            body: ["clothing_id": clothingId, "is_liked": isLiked]
        )
    }
}
