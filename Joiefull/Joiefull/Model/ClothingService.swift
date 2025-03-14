//
//  ClothingService.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

class ClothingService {

    private let networkClient: NetworkClient
    private let apiUrl = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
                        + "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api"

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.networkClient = NetworkClient(using: httpClient)
    }
}

// MARK: Public

extension ClothingService {

    func fetchClothes() async throws -> [Clothing] {
        /// Fetch data
        let data = try await networkClient.getData(from: "\(apiUrl)/clothes.json")

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
        try await networkClient.post(toUrl: "\(apiUrl)/review", body: body)
    }

    func postLike(clothingId: Int, isLiked: Bool) async throws {
        /// Post data
        try await networkClient.post(
            toUrl: "\(apiUrl)/like",
            body: ["clothing_id": clothingId, "is_liked": isLiked]
        )
    }
}
