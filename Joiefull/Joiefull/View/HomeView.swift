//
//  HomeView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct HomeView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSC

    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedItem: Clothing?

    private var isSplitView: Bool {
        return horizontalSC == .regular
    }

    // MARK: Body

    var body: some View {
        /// Using geometry reader to update sidebar width after iPad rotations
        GeometryReader { geo in
            NavigationSplitView(columnVisibility: .constant(.all)) {
                if isSplitView {
                    splitViewSidebar
                        .navigationSplitViewColumnWidth(sidebar(screenSize: geo.size))
                        .toolbar(.hidden, for: .navigationBar)
                        .listStyle(.sidebar)
                } else {
                    splitViewSidebar
                        .listStyle(.plain)
                }
            } detail: {
                splitViewDetail
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
}

// MARK: Split view columns

private extension HomeView {

    var splitViewSidebar: some View {
        ZStack {
            if viewModel.firstLoading {
                firstLoadingProgressView
                    .onAppear {
                        /// At the begining, firstLoading is already set to true, so state is not udpaded.
                        /// Using announcement notification instead of accessibilityLabel
                        /// to force VoiceOver announcement.
                        UIAccessibility.post(
                            notification: .announcement,
                            argument: "Chargement des vêtements."
                        )
                    }
            } else if viewModel.fetchClothesError.isEmpty {
                clothesList
            } else {
                fetchError
            }
        }
    }

    private func sidebar(screenSize: CGSize) -> CGFloat {
        let isLandscape = screenSize.width > screenSize.height
        let maxWidth: CGFloat = screenSize.width - 1
        let landscapeWidth = screenSize.width * 766/1280
        return selectedItem == nil ? maxWidth : (isLandscape ? landscapeWidth : 0)
    }

    var splitViewDetail: some View {
        ZStack {
            if viewModel.firstLoading || !viewModel.fetchClothesError.isEmpty {
                Color
                    .launchScreenBackground
                    .ignoresSafeArea()

            } else {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
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
                    selectedItem: $selectedItem,
                    category: category,
                    items: clothes
                )
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(
                        top: 0,
                        leading: 16,
                        bottom: 12,
                        trailing: 0
                    )
                )
            }
        }
        .navigationDestination(item: $selectedItem) { clothing in
            DetailView(viewModel: DetailViewModel(
                modelContext: modelContext,
                clothing: clothing)
            )
        }
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
