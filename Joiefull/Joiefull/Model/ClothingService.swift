//
//  ClothingService.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

class ClothingService {

    private let networkClient: NetworkClient

    private let clothesUrlStart = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
    private let clothesUrlEnd = "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json"

    init(networkClient: NetworkClient = .init()) {
        self.networkClient = networkClient
    }

    func fetchClothes() async throws -> [Clothing] {
        // Fetch data
        let data = try await networkClient.data(from: clothesUrlStart + clothesUrlEnd)

        // Try return decoded data
        return try JSONDecoder().decode([Clothing].self, from: data)
    }
}
