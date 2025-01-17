//
//  HomeView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationSplitView {
            List(viewModel.clothesByCategory.keys.sorted(), id: \.self) { category in
                if let clothes = viewModel.clothesByCategory[category] {
                    CategoryRow(category: category, items: clothes)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 0))
                }
            }
            .listStyle(PlainListStyle())
        } detail: {
            Text("Select item")
        }

    }
}

#Preview {
    HomeView()
}
