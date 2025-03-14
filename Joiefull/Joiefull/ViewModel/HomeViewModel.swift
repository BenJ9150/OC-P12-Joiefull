//
//  HomeViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

@MainActor class HomeViewModel: ObservableObject {

    @Published var clothesByCategory: [String: [Clothing]] = [:]
    @Published var firstLoading = true
    @Published var fetchClothesError = ""
    @Published var selectedItem: Clothing?

    private let clothingService: ClothingService

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.clothingService = ClothingService(using: httpClient)
    }
}

// MARK: Fetch clothes

extension HomeViewModel {

    func fetchClothes() async {
        fetchClothesError = ""
        do {
            let clothes = try await clothingService.fetchClothes()
            handleFetchResult(clothes)
            print("✅ Fetch clothes with success")
        } catch {
            print("💥 Fetch clothes failed: \(error)")
            showError()
        }
        firstLoading = false
    }

    func handleFetchResult(_ clothes: [Clothing]) {
        clothesByCategory = Dictionary(grouping: clothes, by: { $0.category })
    }

    func showError() {
        withAnimation(.bouncy) {
            fetchClothesError = "Oups... Une erreur s'est produite."
        }
    }
}

// MARK: Open detail from url

extension HomeViewModel {

    func opendDetails(from url: URL) {
        print("Deep link received: \(url.absoluteString)")

        /// Get clothing id from url
        guard url.scheme == Clothing.shareUrlScheme,
              url.host == Clothing.shareUrlHost,
              let clothingId = Int(url.lastPathComponent) else {
            return
        }
        /// Get clothing that match with id from url
        if let clothing = clothesByCategory
            .values
            .flatMap({ $0 })
            .first(where: { $0.id == clothingId }) {
            /// Show clothing
            selectedItem = clothing
        }
    }
}
