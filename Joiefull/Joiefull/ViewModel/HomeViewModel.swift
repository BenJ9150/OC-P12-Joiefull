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

    private let httpClient: HTTPClient

    init(using httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
        if isPreview() { return }
        fetchClothes()
    }
}

// MARK: Fetch clothes

extension HomeViewModel {

    func fetchClothes() {
        fetchingClothes = true
        fetchClothesError = ""

        Task(priority: .background) {
            do {
                let fetchedclothes = try await ClothingService(using: httpClient).fetchClothes()
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

// MARK: - Preview

extension HomeViewModel {

    private func isPreview() -> Bool {
#if DEBUG
        /// Do not access to ClothesPreview in release
        /// This file is in the Preview Content folder
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            clothesByCategory = Dictionary(grouping: ClothesPreview().getClothes(), by: { $0.category })
            fetchingClothes = false
            return true
        }
#endif
        return false
    }
}
