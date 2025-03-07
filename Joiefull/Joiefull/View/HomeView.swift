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

    private var isInspectorPresented: Binding<Bool> {
        Binding(
            get: { viewModel.selectedItem != nil },
            set: { if !$0 { viewModel.selectedItem = nil } }
        )
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
                if isPad {
                    clothesList
                        .listStyle(.grouped)
                        .background(Color(UIColor.systemGroupedBackground))
                        .inspector(isPresented: isInspectorPresented) {
                            if let clothing = viewModel.selectedItem {
                                DetailView(with: DetailViewModel(modelContext: context, for: clothing))
                                    .inspectorColumnWidth(min: 400, ideal: 514)
                            }
                        }
                } else {
                    clothesList
                        .listStyle(.inset)
                        .navigationDestination(item: $viewModel.selectedItem) { clothing in
                            DetailView(with: DetailViewModel(modelContext: context, for: clothing))
                        }
                }
            } else {
                fetchError
            }
        }
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
        .scrollContentBackground(.hidden)
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

#Preview {
    let previewMode: ClothesPreview.PreviewMode = .content

    let viewModel = HomeViewModel()
    HomeView(viewModel: viewModel)
        .modelContainer(ClothesPreview().previewModelContainer())
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
