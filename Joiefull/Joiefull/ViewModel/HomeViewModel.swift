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
            print("💥 Fetch cltothes failed: \(error)")
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
