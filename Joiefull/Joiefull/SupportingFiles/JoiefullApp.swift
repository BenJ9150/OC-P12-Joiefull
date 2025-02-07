//
//  JoiefullApp.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

@main
struct JoiefullApp: App {

    @StateObject private var viewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel)
                .task {
                    await viewModel.fetchClothes()
                }
        }
    }
}
