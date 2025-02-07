//
//  HomeView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationSplitView {
            if viewModel.firstLoading {
                firstLoading
            } else if viewModel.fetchClothesError.isEmpty {
                clothesList
            } else {
                fetchError
            }
        } detail: {
            Text("Select item")
        }
    }
}

// MARK: Clothes list

private extension HomeView {

    var clothesList: some View {
        List(viewModel.clothesByCategory.keys.sorted(), id: \.self) { category in
            if let clothes = viewModel.clothesByCategory[category] {
                CategoryRowView(category: category, items: clothes)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 0))
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await viewModel.fetchClothes()
        }
    }
}

private extension HomeView {

    // MARK: Loading

    var firstLoading: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.launchScreenBackground)
    }

    // MARK: Error

    var fetchError: some View {
        VStack(spacing: 24) {
            Image(.logoJoiefull)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            Text(viewModel.fetchClothesError)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .padding()
            Button {
                Task {
                    await viewModel.fetchClothes()
                }
            } label: {
                Text("Réessayer")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.loadingErrorButtonText)
                    .padding()
                    .padding(.horizontal)
                    .background(Color.loadingErrorButton, in: .capsule)
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.launchScreenBackground)
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {

    enum PreviewMode {
        case loading
        case error
        case normal
    }

    static let previewMode: PreviewMode = .normal
    static let viewModel = HomeViewModel()

    static var previews: some View {
        HomeView(viewModel: viewModel)
            .onAppear {
                switch previewMode {
                case .loading:
                    break
                case .error:
                    viewModel.handleFetchClothesResult(nil)
                case .normal:
                    viewModel.handleFetchClothesResult(ClothesPreview().getClothes())
                }
            }
    }
}
