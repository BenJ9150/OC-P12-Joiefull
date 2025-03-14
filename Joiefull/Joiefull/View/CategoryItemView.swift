//
//  CategoryItemView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryItemView: View {

    // MARK: Properties

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.verticalSizeClass) var verticalSizeClass

    private let clothing: Clothing
    private let isSelected: Bool

    private var pictureWidth: CGFloat {
        /// Increase  width when dynamic type size increases to give more spaces for clothing description
        return .originalPictureWidth.adaptTo(dynamicTypeSize)
    }

    private var pictureHeight: CGFloat {
        /// Increase picture height when picture width increases to keep original aspect ratio
        return pictureWidth * .originalPictureHeight / .originalPictureWidth
    }

    private var isPhoneInLandscape: Bool {
        if isPad { return false }
        return verticalSizeClass == .compact
    }

    // MARK: Init

    init(for clothing: Clothing, isSelected: Bool) {
        self.clothing = clothing
        self.isSelected = isSelected
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
                        .frame(width: dynamicTypeSize.isHigh ? pictureWidth : .originalPictureWidth)
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

#Preview(traits: .modifier(FavoritesViewModelInEnvironment())) {
    @Previewable @State var isSelected = false
    let clothing = ClothesPreview().getClothing(.withBigDescription)

    CategoryItemView(for: clothing, isSelected: isSelected)
        .onTapGesture {
            isSelected.toggle()
        }
}
