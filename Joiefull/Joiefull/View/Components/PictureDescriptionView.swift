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
    private let inVerticalMode: Bool
    private let largeSize: Bool
    private let showOriginalPrice: Bool

    private var descriptionFont: Font {
        if largeSize {
            return isPad ? .title2 : .body
        }
        return isPad ? .body : .caption
    }

    // MARK: init

    init(for clothing: Clothing, inVerticalMode: Bool = false, largeSize: Bool = false, _ isPad: Bool) {
        self.clothing = clothing
        self.isPad = isPad
        self.inVerticalMode = inVerticalMode
        self.largeSize = largeSize

        /// Do not show original price if equal to price
        self.showOriginalPrice = clothing.originalPrice != clothing.price
    }

    // MARK: Body

    var body: some View {
        if inVerticalMode {
            verticalDescription
        } else {
            defaultDescription
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
            price
            if showOriginalPrice {
                originalPrice
            }
            stars
        }
    }
}

// MARK: Description details

private extension PictureDescriptionView {

    var clothingName: some View {
        /// Adjust line limit according to accessibility size
        let limit = dynamicTypeSize.isHighAccessibilitySize ? 3 : dynamicTypeSize.isAccessibilitySize ? 2 : 1
        return Text(clothing.name)
            .font(descriptionFont)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(limit)
    }

    var stars: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(descriptionFont)
                .foregroundStyle(.orange)
                .padding(.bottom, 1)

            /// Display rating with US style to have dot as decimal separator
            Text(clothing.rating.toString(locale: Locale(identifier: "en_US")))
                .font(descriptionFont)
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

#Preview {
    let clothing = ClothesPreview().getClothing()
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    PictureDescriptionView(for: clothing, isPad)
}
