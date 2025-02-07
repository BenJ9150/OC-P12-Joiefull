//
//  HomeViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var clothesByCategory: [String: [Clothing]] = [:]
    @Published var firstLoading = true
    @Published var fetchClothesError = ""

    private let httpClient: HTTPClient

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
    }
}

// MARK: Fetch clothes

extension HomeViewModel {

    func fetchClothes() async {
        await clothesAreLoading()
        let fetchedClothes = try? await ClothingService(using: httpClient).fetchClothes()
        await handleFetchClothesResult(fetchedClothes)
    }

    @MainActor func clothesAreLoading() {
        fetchClothesError = ""
    }

    @MainActor func handleFetchClothesResult(_ clothes: [Clothing]?) {
        withAnimation(.bouncy) {
            if let clothesResult = clothes {
                clothesByCategory = Dictionary(grouping: clothesResult, by: { $0.category })
            } else {
                fetchClothesError = "Oups... Une erreur s'est produite."
            }
            firstLoading = false
        }
    }
}
