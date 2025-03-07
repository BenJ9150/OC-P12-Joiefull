//
//  PictureView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 31/01/2025.
//

import SwiftUI

struct PictureView: View {

    // MARK: Environment

    @Environment(\.horizontalSizeClass) var horizontalSC

    // MARK: Properties

    @State private var showFullScreen: Bool = false

    private let clothing: Clothing
    private let width: CGFloat
    private let height: CGFloat
    private let isDetailView: Bool
    @State private var clothingImage: Image?

    // MARK: Init

    init(
        for clothing: Clothing,
        width: CGFloat = .infinity,
        height: CGFloat = .infinity,
        isDetailView: Bool = false
    ) {
        self.clothing = clothing
        self.width = width
        self.height = height
        self.isDetailView = isDetailView
    }

    // MARK: Body

    var body: some View {
        asyncPicture
            .overlay(alignment: .bottomTrailing, when: clothing.likes > 0) {
                likesBanner
            }
            .overlay(alignment: .topTrailing, when: isDetailView) {
                shareButton
            }
    }
}

private extension PictureView {

    // MARK: Async image

    var asyncPicture: some View {
        AsyncImage(url: URL(string: clothing.picture.url)) { phase in
            switch phase {
            case .empty: ProgressView()
            case .success(let image): clothingImage(from: image)
            default:
                Image(systemName: "photo")
                    .foregroundStyle(.gray)
            }
        }
        .frame(
            minWidth: 0,
            idealWidth: width == .infinity ? nil : width,
            maxWidth: width,
            minHeight: 0,
            idealHeight: height == .infinity ? nil : height,
            maxHeight: height
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
        )
        .accessibilityHidden(true)
    }
}

// MARK: Clothing image

private extension PictureView {

    func clothingImage(from fetchedImage: Image) -> some View {
        ZStack {
            if isDetailView {
                fetchedImage
                    .resizable()
                    .scaledToFill()
                    .onAppear { clothingImage = fetchedImage }
                    .onTapGesture {
                        if isDetailView { showFullScreen.toggle() }
                    }
                    .fullScreenCover(isPresented: $showFullScreen) {
                        FullScreenPictureView(isPresented: $showFullScreen, image: fetchedImage)
                    }
            } else {
                fetchedImage
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

// MARK: Likes banner

private extension PictureView {

    var likesBanner: some View {
        HStack(spacing: 2) {
            Image(systemName: "heart")
            Text("\(clothing.likes)")
        }
        .font(isDetailView ? .adaptiveBody : .footnote)
        .fontWeight(.semibold)
        .padding(.all, 6)
        .padding(.horizontal, 2)
        .background(
            Capsule().fill(.background)
        )
        .padding(.all, 12)
    }
}

// MARK: Share button

private extension PictureView {

    var shareButton: some View {
        ZStack {
            if let shareURL = clothing.shareURL, let image = clothingImage {
                ShareLink(
                    item: shareURL,
                    message: Text("Regarde ça !"),
                    preview: SharePreview(clothing.name, image: image)
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .padding(.all, 6)
                        .padding(.bottom, 3)
                        .background(
                            Circle().fill(.background)
                        )
                }
                .foregroundStyle(.primary)
                .padding(.top, 9)
                .padding(.trailing, 12)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let clothing = ClothesPreview().getClothing()

    VStack {
        PictureView(for: clothing, height: 300, isDetailView: true)
        PictureView(for: clothing, width: 198, height: 198)
    }
    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16)
}
