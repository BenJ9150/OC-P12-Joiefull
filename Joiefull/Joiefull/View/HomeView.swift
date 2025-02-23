//
//  HomeView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    // MARK: Body

    var body: some View {
        /// Using geometry reader to update sidebar width after iPad rotations
        GeometryReader { geometry in
            NavigationSplitView(columnVisibility: .constant(.all)) {
                splitViewSidebar
                    .navigationSplitViewColumnWidth(geometry.size.width * 766/1280)
                    .toolbar(.hidden, for: .navigationBar)
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

    var splitViewDetail: some View {
        ZStack {
            if viewModel.firstLoading || !viewModel.fetchClothesError.isEmpty {
                Color
                    .launchScreenBackground
                    .ignoresSafeArea()

            } else {
                EmptyView()
            }
        }
    }
}

private extension HomeView {

    // MARK: Clothes list

    var clothesList: some View {
        List(viewModel.clothesByCategory.keys.sorted(), id: \.self) { category in
            if let clothes = viewModel.clothesByCategory[category] {
                CategoryRowView(category: category, items: clothes, isPad: isPad)
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        EdgeInsets(
                            top: 0,
                            leading: isPad ? 32 : 16,
                            bottom: 0,
                            trailing: 0
                        )
                    )
            }
        }
        .listStyle(PlainListStyle())
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
            .accessibilityLabel(
                viewModel.fetchClothesError.replacingOccurrences(of: "...", with: ".") + " Réessayer"
            )
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
        case clothes
    }

    static let device: MyPreviewDevice = .iPhoneMax
    static let previewMode: PreviewMode = .clothes
    static let viewModel = HomeViewModel()

    static var previews: some View {
        HomeView(viewModel: viewModel)
            .previewDevice(device.preview)
            .onAppear {
                switch previewMode {
                case .loading:
                    break
                case .error:
                    viewModel.handleFetchClothesResult(nil)
                case .clothes:
                    viewModel.handleFetchClothesResult(ClothesPreview().getClothes())
                }
            }
    }
}
