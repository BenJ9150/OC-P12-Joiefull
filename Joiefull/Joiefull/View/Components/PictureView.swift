//
//  PictureView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 31/01/2025.
//

import SwiftUI

struct PictureView: View {

    // MARK: Properties

    private let clothing: Clothing
    private let width: CGFloat
    private let height: CGFloat
    private let isPad: Bool
    private let isDetailView: Bool
    private let likesBannerFont: Font

    // MARK: Init

    init(
        for clothing: Clothing,
        width: CGFloat = .infinity,
        height: CGFloat = .infinity,
        isPad: Bool,
        isDetailView: Bool = false
    ) {
        self.clothing = clothing
        self.width = width
        self.height = height
        self.isPad = isPad
        self.isDetailView = isDetailView
        self.likesBannerFont = isDetailView ? (isPad ? .title2 : .body) : .footnote
    }

    // MARK: Body

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            asyncPicture
            if clothing.likes > 0 {
                likesBanner
                    .padding(.all, 12)
            }
        }
        .accessibilityHidden(true)
    }
}

extension PictureView {

    // MARK: Async image

    var asyncPicture: some View {
        AsyncImage(url: URL(string: clothing.picture.url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
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
        .background(
            RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
        )
    }

    // MARK: Likes banner

    var likesBanner: some View {
        HStack(spacing: 2) {
            Image(systemName: "heart")
                .font(.footnote.weight(.semibold))
            Text("\(clothing.likes)")
                .font(.footnote.weight(.semibold))
        }
        .padding(.all, 6)
        .padding(.horizontal, 2)
        .background(
            Capsule().fill(.background)
        )
    }
}

// MARK: - Preview

struct PictureView_Previews: PreviewProvider {

    enum PreviewMode {
        case item
        case detailView
    }

    static let previewMode: PreviewMode = .detailView

    static let clothing = ClothesPreview().getClothing()
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad

    static var previews: some View {
        switch previewMode {
        case .item:
            ScrollView {
                PictureView(for: clothing, width: 198, height: 198, isPad: isPad)
            }
        case .detailView:
            VStack {
                PictureView(for: clothing, isPad: isPad)
                Color.clear
                    .frame(height: 100)
            }
            .padding(.horizontal, isPad ? 32 : 16)
        }
    }
}
