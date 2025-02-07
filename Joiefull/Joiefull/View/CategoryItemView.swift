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
                PictureDescriptionView(for: clothing, inVerticalMode: true, isPad)
                    .padding(.horizontal, 8)
            } else {
                PictureDescriptionView(for: clothing, isPad)
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
                    PictureDescriptionView(for: clothing, inVerticalMode: true, isPad)
                        .frame(width: dynamicTypeSize.isHighAccessibilitySize ? pictureWidth : originalPictureWidth)
                }
            } else {
                defaultIem
            }
        }
    }
}

// MARK: - Preview

struct CategoryItemView_Previews: PreviewProvider {

    static let clothing = ClothesPreview().getClothing(2)
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad

    static var previews: some View {
        CategoryItemView(for: clothing, isPad)
            .previewDevice("iPhone 13 mini")
//            .previewDevice("iPhone 16 Pro Max")
//            .previewDevice("iPad mini (6th generation)")
//            .previewDevice("iPad Pro 13-inch (M4)")
    }
}
