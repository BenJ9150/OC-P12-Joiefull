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
    private let isSelected: Bool

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

    init(for clothing: Clothing, isSelected: Bool) {
        self.clothing = clothing
        self.isSelected = isSelected
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
                    picture
                    description
                        .frame(width: dynamicTypeSize.isHigh ? pictureWidth : originalPictureWidth)
                }
            } else {
                VStack(spacing: isPad ? 12 : 8) {
                    picture
                    description
                        .padding(.horizontal, 8)
                }
                .frame(width: pictureWidth)
            }
        }
    }
}

// MARK: Picture

private extension CategoryItemView {

    private var picture: some View {
        PictureView(for: clothing, width: pictureWidth, height: pictureHeight)
            .overlay(when: isSelected) {
                RoundedRectangle(cornerRadius: 20 - 3)
                    .stroke(Color.selectedItem, lineWidth: 3)
                    .padding(.all, 1.5)
            }
    }
}

// MARK: Description

private extension CategoryItemView {

    private var description: some View {
        PictureDescriptionView(for: clothing)
            .foregroundStyle(isSelected ? .selectedItem : .primary)
    }
}

// MARK: - Preview

#Preview {
    ScrollView(.horizontal) {
        HStack(alignment: .top, spacing: UIDevice.isPad ? 16 : 8) {
            CategoryItemView(
                for: ClothesPreview().getClothing(.withBigDescription),
                isSelected: true
            )
            CategoryItemView(
                for: ClothesPreview().getClothing(.withSmallDescription),
                isSelected: false
            )
        }
        .padding()
    }
}
