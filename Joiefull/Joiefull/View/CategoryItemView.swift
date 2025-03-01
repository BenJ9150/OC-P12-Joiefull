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

    init(for clothing: Clothing) {
        self.clothing = clothing
        self.originalPictureWidth = UIDevice.isPad ? 234 : 198
        self.originalPictureHeight = UIDevice.isPad ? 256 : 198
    }

    // MARK: Body

    var body: some View {
        ZStack {
            /// If is an iPhone in landcape and dynamicTypeSize is an AccessibilitySize:
            /// Show the description on the right of the picture
            if isPhoneInLandscape && dynamicTypeSize.isAccessibilitySize {
                HStack(spacing: 24) {
                    PictureView(for: clothing, width: pictureWidth, height: pictureHeight)
                    PictureDescriptionView(for: clothing)
                        .frame(width: dynamicTypeSize.isHigh ? pictureWidth : originalPictureWidth)
                }
            } else {
                VStack(spacing: isPad ? 12 : 8) {
                    PictureView(for: clothing, width: pictureWidth, height: pictureHeight)
                    PictureDescriptionView(for: clothing)
                        .padding(.horizontal, 8)
                }
                .frame(width: pictureWidth)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CategoryItemView(for: ClothesPreview().getClothing(12))
}
