//
//  HomeView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct HomeView: View {

    // MARK: Properties

    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: HomeViewModel

    private let httpClient: HTTPClient

    private var isInspectorPresented: Binding<Bool> {
        Binding(
            get: { viewModel.selectedItem != nil },
            set: { if !$0 { viewModel.selectedItem = nil } }
        )
    }

    init(viewModel: HomeViewModel, using httpClient: HTTPClient = URLSession.shared) {
        self.viewModel = viewModel
        self.httpClient = httpClient
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            if viewModel.firstLoading {
                firstLoadingProgressView
                    .onAppear {
                        /// At the begining, firstLoading is already set to true, so state is not udpaded.
                        /// Using announcement notification instead of accessibilityLabel
                        /// to force VoiceOver announcement.
                        UIAccessibility.post(notification: .announcement, argument: "Chargement des vêtements")
                    }
            } else if viewModel.fetchClothesError.isEmpty {
                let reviewRepo = SwiftDataService(modelContext: context)
                if isPad {
                    clothesList
                        .background(
                            Color(UIColor.systemGroupedBackground)
                                .ignoresSafeArea()
                        )
                        .inspector(isPresented: isInspectorPresented) {
                            if let clothing = viewModel.selectedItem {
                                DetailView(
                                    with: DetailViewModel( for: clothing, reviewRepo: reviewRepo, using: httpClient)
                                )
                                .inspectorColumnWidth(min: 400, ideal: 480)
                            }
                        }
                } else {
                    clothesList
                        .navigationDestination(item: $viewModel.selectedItem) { clothing in
                            DetailView(
                                with: DetailViewModel( for: clothing, reviewRepo: reviewRepo, using: httpClient)
                            )
                        }
                }
            } else {
                fetchError
            }
        }
        .environmentObject(FavoritesViewModel(favoriteRepo: SwiftDataService(modelContext: context)))
    }
}

private extension HomeView {

    // MARK: Clothes list

    var clothesList: some View {
        List(viewModel.clothesByCategory.keys.sorted(), id: \.self) { category in
            if let clothes = viewModel.clothesByCategory[category] {
                CategoryRowView(
                    selectedItem: $viewModel.selectedItem,
                    category: category,
                    items: clothes
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        .padding(.top, isPad ? 5 : 0)
        .onOpenURL { viewModel.opendDetails(from: $0) }
        .refreshable {
            await viewModel.fetchClothes()
        }
    }

    // MARK: Loading

    var firstLoadingProgressView: some View {
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
                .accessibilityHidden(true)

            Text(viewModel.fetchClothesError)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .padding()
                .accessibilityHidden(true)

            Button("Réessayer") {
                Task { await viewModel.fetchClothes() }
            }
            .buttonStyle(JoifullButton())
            .accessibilityLabel(
                viewModel.fetchClothesError.replacingOccurrences(of: "...", with: ".") + " Réessayer"
            )
        }
    }
}

// MARK: - Preview

#Preview(traits: .modifier(SampleFavorites())) {
    let previewMode: ClothesPreview.PreviewMode = .content
    let viewModel = HomeViewModel(using: HTTPClientPreview())

    HomeView(viewModel: viewModel, using: HTTPClientPreview())
        .onAppear {
            switch previewMode {
            case .loading:
                break
            case .error:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.showError()
                    viewModel.firstLoading = false
                }
            case .content:
                viewModel.handleFetchResult(ClothesPreview().getClothes())
                viewModel.firstLoading = false
            }
        }
}
