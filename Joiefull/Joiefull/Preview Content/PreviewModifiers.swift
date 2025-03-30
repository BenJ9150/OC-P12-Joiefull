//
//  PreviewModifiers.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 14/03/2025.
//

import SwiftUI
import SwiftData

struct SampleFavorites: PreviewModifier {

    static func makeSharedContext() throws -> ModelContainer {
        let container = try ModelContainer(
            for: ReviewAndRating.self, Favorite.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        container.mainContext.insert(Favorite(clothingId: 0))
        container.mainContext.insert(Favorite(clothingId: 1))
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
}

struct FavoritesViewModelInEnvironment: PreviewModifier {

    static func makeSharedContext() throws -> (container: ModelContainer, viewModel: FavoritesViewModel) {
        let container = try ModelContainer(
            for: ReviewAndRating.self, Favorite.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        let favoriteRepo = SwiftDataService(modelContext: container.mainContext)
        let viewModel = FavoritesViewModel(favoriteRepo: favoriteRepo, using: HTTPClientPreview())
        return (container, viewModel)
    }

    func body(content: Content, context: (container: ModelContainer, viewModel: FavoritesViewModel)) -> some View {
        content
            .modelContainer(context.container)
            .environmentObject(context.viewModel)
    }
}

struct InspectorPresentation: PreviewModifier {
    @State private var navigateToDetail = false

    func body(content: Content, context: ()) -> some View {
        NavigationStack {
            if UIDevice.isPad {
                Text("PREVIEW")
                    .onTapGesture {
                        navigateToDetail.toggle()
                    }
                    .inspector(isPresented: $navigateToDetail) {
                        content
                            .inspectorColumnWidth(min: 400, ideal: 480)
                    }
            } else {
                Text("PREVIEW")
                    .onTapGesture {
                        navigateToDetail.toggle()
                    }
                    .navigationDestination(isPresented: $navigateToDetail) {
                        content
                    }
            }
        }
        .onAppear {
            navigateToDetail = true
        }
    }
}

struct ItemDetailWithDynamicWidth: PreviewModifier {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var pictureWidth: CGFloat {
        let originalWidth: CGFloat = UIDevice.isPad ? 234 : 198
        return originalWidth.adaptTo(dynamicTypeSize)
    }

    func body(content: Content, context: ()) -> some View {
        content
            .frame(width: pictureWidth)
    }
}
