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

    /// Default item with different description UI depending on dynamic type size
    var defaultIem: some View {
        VStack(spacing: isPad ? 12 : 8) {
            PictureView(clothing: clothing, width: pictureWidth, height: pictureHeight)
            Group {
                switch dynamicTypeSize {
                case .accessibility1, .accessibility2, .accessibility3:
                    descriptionAX1
                case .accessibility4, .accessibility5:
                    descriptionAX4
                default:
                    defaultDescription
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(width: pictureWidth)
    }
}

// MARK: iPhone in landscape item

private extension CategoryItemView {

    /// Item for iPhone in landscape
    var iphoneInlandscapeItem: some View {
        ZStack {
            /// From accesibility2 dynamic type size, show the description on the right of the picture
            switch dynamicTypeSize {
            case .accessibility2, .accessibility3:
                /// Keep ogirinal picture size to save place for category name
                horizontalItem(width: originalPictureWidth, height: originalPictureHeight)
            case .accessibility4, .accessibility5:
                /// Picture with increased size to be consistent with the large size of the description
                horizontalItem(width: pictureWidth, height: pictureHeight)
            default:
                /// Default UI with description below the picture
                VStack(spacing: 8) {
                    PictureView(clothing: clothing, width: pictureWidth, height: originalPictureHeight)
                    defaultDescription
                        .padding(.horizontal, 8)
                }
                .frame(width: pictureWidth)
            }
        }
    }

    func horizontalItem(width: CGFloat, height: CGFloat) -> some View {
        HStack(spacing: 24) {
            PictureView(clothing: clothing, width: width, height: height)
            descriptionAX4
                .frame(width: pictureWidth)
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

    var descriptionAX1: some View {
        VStack(spacing: 4) {
            clothingName
            HStack {
                if showOriginalPrice {
                    VStack(alignment: .leading, spacing: 4) {
                        price
                        originalPrice
                    }
                } else {
                    price
                }
                Spacer()
                stars
            }
        }
    }

    var descriptionAX4: some View {
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
        let lineLimit: Int = switch dynamicTypeSize {
        case .accessibility1:
            showOriginalPrice ? 1 : 2
        case .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            showOriginalPrice ? 2 : 3
        default: 1
        }
        return Text(clothing.name)
            .font(.footnote.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(lineLimit)
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
        let clothing = ClothesPreview().getClothing(2)

        var body: some View {
            CategoryItemView(for: clothing, horizontalSC == .regular && verticalSC == .regular)
        }
    }
}
