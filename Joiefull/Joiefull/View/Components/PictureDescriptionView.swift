//
//  PictureDescriptionView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 07/02/2025.
//

import SwiftUI

struct PictureDescriptionView: View {

    // MARK: Environment

    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    // MARK: Properties

    private let clothing: Clothing
    private let isPad: Bool
    private let showOriginalPrice: Bool
    private let isDetailView: Bool
    private let descriptionFont: Font

    // MARK: init

    init(for clothing: Clothing, isDetailView: Bool = false, _ isPad: Bool) {
        self.clothing = clothing
        self.isPad = isPad
        self.isDetailView = isDetailView
        self.descriptionFont = isDetailView ? .adaptiveBody : .adaptiveFootnote

        /// Do not show original price if equal to price
        self.showOriginalPrice = clothing.originalPrice != clothing.price
    }

    // MARK: Body

    var body: some View {
        ZStack {
            /// If dynamicTypeSize is an AccessibilitySize, description is vertical to give more space for each text
            if dynamicTypeSize.isAccessibilitySize {
                verticalDescription
            } else {
                defaultDescription
            }
        }
    }
}

// MARK: Descriptions

private extension PictureDescriptionView {

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
            if dynamicTypeSize.isVeryHigh {
                /// Not enough place to show price and stars on the same line
                stars
                price
            } else {
                HStack(spacing: 0) {
                    price
                        .fixedSize(horizontal: true, vertical: false)
                    Spacer()
                    stars
                }
            }
            if showOriginalPrice {
                originalPrice
            }
        }
    }
}

// MARK: Description details

private extension PictureDescriptionView {

    var clothingName: some View {
        /// Adjust line limit according to accessibility size
        let limit = isDetailView ? 5 : dynamicTypeSize.isHigh ? 3 : dynamicTypeSize.isAccessibilitySize ? 2 : 1
        return Text(clothing.name)
            .font(descriptionFont)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(limit)
    }

    var stars: some View {
        HStack(spacing: 1) {
            Image(systemName: "star.fill")
                .font(descriptionFont)
                .foregroundStyle(.orange)
                .padding(.bottom, 2)

            /// Display rating with US style to have dot as decimal separator
            Text(clothing.rating.toString(locale: Locale(identifier: "en_US")))
                .font(descriptionFont)
                .fixedSize(horizontal: true, vertical: false)
        }
    }

    var price: some View {
        Text(clothing.price.toEuros())
            .font(descriptionFont)
    }

    var originalPrice: some View {
        Text(clothing.originalPrice.toEuros())
            .font(descriptionFont)
            .strikethrough()
            .opacity(0.7)
    }
}

// MARK: - Preview for item view

struct PictureDescriptionViewForItemView_Previews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper()
            .previewDevice(.iPhoneMini)
    }

    struct PreviewWrapper: View {
        @Environment(\.dynamicTypeSize) var dynamicTypeSize
        private let clothing = ClothesPreview().getClothing(12)
        private let isPad = UIDevice.current.userInterfaceIdiom == .pad

        var pictureWidth: CGFloat {
            let originalWidth: CGFloat = isPad ? 234 : 198
            return originalWidth.adaptTo(dynamicTypeSize)
        }

        var body: some View {
            PictureDescriptionView(for: clothing, isPad)
                .frame(width: pictureWidth)
        }
    }
}

// MARK: - Preview for detail view

struct PictureDescriptionViewForDetailView_Previews: PreviewProvider {
    static let clothing = ClothesPreview().getClothing(12)
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad

    static var previews: some View {
        PictureDescriptionView(for: clothing, isDetailView: true, isPad)
            .padding(.horizontal, isPad ? 32 : 16)
            .previewDevice(.iPhoneMini)
    }
}
