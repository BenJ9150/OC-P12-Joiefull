//
//  CategoryItemView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryItemView: View {

    // MARK: Environment

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.verticalSizeClass) var verticalSC

    // MARK: Properties

    private let clothing: Clothing
    private let isPad: Bool
    private let originalPictureWidth: CGFloat
    private let originalPictureHeight: CGFloat
    private let showOriginalPrice: Bool

    private var isPhoneInLandscape: Bool {
        return verticalSC == .compact
    }

    private var pictureWidth: CGFloat {
        /// Increase  width when dynamic type size increases to give more spaces for clothing description
        return originalPictureWidth.adaptTo(dynamicTypeSize)
    }

    private var pictureHeight: CGFloat {
        /// Increase picture height when picture width increases to keep original aspect ratio
        return pictureWidth * originalPictureHeight / originalPictureWidth
    }

    // MARK: Init

    init(for clothing: Clothing, _ isPad: Bool) {
        self.clothing = clothing
        self.isPad = isPad
        self.originalPictureWidth = isPad ? 234 : 198
        self.originalPictureHeight = isPad ? 256 : 198

        /// Do not show original price if equal to price
        self.showOriginalPrice = clothing.originalPrice != clothing.price
    }

    // MARK: Body

    var body: some View {
        if isPhoneInLandscape {
            iphoneInlandscapeItem
        } else {
            defaultIem
        }
    }
}

// MARK: default item

private extension CategoryItemView {

    /// Default item with default UI description
    /// If dynamicTypeSize is an AccessibilitySize, description is vertical to give more space for each text
    var defaultIem: some View {
        VStack(spacing: isPad ? 12 : 8) {
            PictureView(clothing: clothing, width: pictureWidth, height: pictureHeight)
            if dynamicTypeSize.isAccessibilitySize {
                verticalDescription
                    .padding(.horizontal, 8)
            } else {
                defaultDescription
                    .padding(.horizontal, 8)
            }
        }
        .frame(width: pictureWidth)
    }
}

// MARK: iPhone in landscape item

private extension CategoryItemView {

    /// Item for iPhone in landscape
    /// If dynamicTypeSize is an AccessibilitySize, the description is vertical and on the right of the picture
    var iphoneInlandscapeItem: some View {
        ZStack {
            if dynamicTypeSize.isAccessibilitySize {
                HStack(spacing: 24) {
                    PictureView(clothing: clothing, width: pictureWidth, height: pictureHeight)
                    verticalDescription
                        .frame(width: dynamicTypeSize.isHighAccessibilitySize ? pictureWidth : originalPictureWidth)
                }
            } else {
                defaultIem
            }
        }
    }
}

// MARK: Descriptions

private extension CategoryItemView {

    /// If original price equal to price, show stars on the second line
    /// to have more space for clothing name
    var defaultDescription: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                clothingName
                if showOriginalPrice { stars }
            }
            HStack {
                price
                Spacer()
                if showOriginalPrice {
                    originalPrice
                } else {
                    stars
                }
            }
        }
    }

    var verticalDescription: some View {
        VStack(alignment: .leading, spacing: 4) {
            clothingName
            price
            if showOriginalPrice {
                originalPrice
            }
            stars
        }
    }
}

// MARK: Description details

private extension CategoryItemView {

    var clothingName: some View {
        /// Adjust line limit according to accessibility size
        let limit = dynamicTypeSize.isHighAccessibilitySize ? 3 : dynamicTypeSize.isAccessibilitySize ? 2 : 1
        return Text(clothing.name)
            .font(.footnote.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(limit)
    }

    var stars: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption2)
                .foregroundStyle(.orange)
                .padding(.bottom, 1)

            /// Display rating with US style to have dot as decimal separator
            Text(clothing.rating.toString(locale: Locale(identifier: "en_US")))
                .font(.footnote.weight(.regular))
        }
    }

    var price: some View {
        Text(clothing.price.toEuros())
            .font(.footnote.weight(.regular))
    }

    var originalPrice: some View {
        Text(clothing.originalPrice.toEuros())
            .font(.footnote.weight(.regular))
            .strikethrough()
    }
}

// MARK: - Preview

struct CategoryItemView_Previews: PreviewProvider {

    static var previews: some View {
        CategoryItemPreviewWrapper()
            .previewDevice("iPhone 13 mini")
//            .previewDevice("iPhone 16 Pro Max")
//            .previewDevice("iPad mini (6th generation)")
//            .previewDevice("iPad Pro 13-inch (M4)")
    }

    private struct CategoryItemPreviewWrapper: View {
        @Environment(\.horizontalSizeClass) var horizontalSC
        @Environment(\.verticalSizeClass) var verticalSC
        let clothing = ClothesPreview().getClothing()

        var body: some View {
            CategoryItemView(for: clothing, horizontalSC == .regular && verticalSC == .regular)
        }
    }
}
