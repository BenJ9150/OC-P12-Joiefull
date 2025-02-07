//
//  ClothingService.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

class ClothingService {

    private let httpClient: HTTPClient
    private let clothesUrlStart = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
    private let clothesUrlEnd = "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json"

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
    }

    func fetchClothes() async throws -> [Clothing] {
        /// Fetch data
        let data = try await NetworkClient(using: httpClient).data(from: clothesUrlStart + clothesUrlEnd)

        /// Try return decoded data
        return try JSONDecoder().decode([Clothing].self, from: data)
    }
}
