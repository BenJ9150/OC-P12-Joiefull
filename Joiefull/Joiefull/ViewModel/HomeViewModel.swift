//
//  HomeViewModel.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var clothesByCategory: [String: [Clothing]] = [:]
    @Published var fetchingClothes = true
    @Published var fetchClothesError = ""

    init() {
        fetchClothes()
    }
}

// MARK: Fetch clothes

extension HomeViewModel {

    func refreshClothes() {
        guard clothesByCategory.isEmpty else {
            return
        }
        fetchClothes()
    }

    private func fetchClothes() {
        fetchingClothes = true
        Task(priority: .background) {
            do {
                let fetchedclothes = try await ClothingService().fetchClothes()
                await MainActor.run {
                    clothesByCategory = Dictionary(grouping: fetchedclothes, by: { $0.category })
                    fetchingClothes = false
                }
            } catch {
                await MainActor.run {
                    fetchClothesError = "Une erreur s'est produite. Veuillez réessayer ultérieurement."
                    fetchingClothes = false
                }
            }
        }
    }
}
