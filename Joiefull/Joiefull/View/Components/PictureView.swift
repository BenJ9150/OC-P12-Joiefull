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

    private let clothing: Clothing
    private let width: CGFloat
    private let height: CGFloat
    private let isPad: Bool
    private let isDetailView: Bool

    private var isSplitView: Bool {
        return horizontalSC == .regular
    }

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
        .accessibilityHidden(true)
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
        Button {
            // TODO: apple shared
        } label: {
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
                PictureView(for: clothing, isPad: isPad, isDetailView: true)
                Color.clear
                    .frame(height: 100)
            }
            .padding(.horizontal, isPad ? 32 : 16)
        }
    }
}
