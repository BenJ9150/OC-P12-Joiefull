//
//  DetailView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct DetailView: View {

    // MARK: Environment

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.horizontalSizeClass) var horizontalSC
    @Environment(\.verticalSizeClass) var verticalSC
    @Environment(\.dismiss) var dismiss

    // MARK: Properties

    private let avatar: Image
    private let clothing: Clothing
    private let isPad: Bool

    private var isPhoneInLandscape: Bool {
        return verticalSC == .compact
    }

    private var isSplitView: Bool {
        return horizontalSC == .regular
    }

    private var showDetailsInScrollView: Bool {
        /// If dynamic type size is accessibility size,
        /// show details in scrollview to be sure that all elements can be see
        if dynamicTypeSize.isAccessibilitySize {
            return true
        }
        /// If detailView is presented in split view on iPhone in landscape,
        /// show details in scrollview to be sure that all elements can be see
        return isSplitView && isPhoneInLandscape
    }

    private var showDetailsInHStack: Bool {
        /// If details is presented in navigation stack
        /// and is an iPhone in landscape,
        /// show details to the right of the picture
        !isSplitView && isPhoneInLandscape
    }

    @State private var ratingValue: Int = 0

    // MARK: Init

    init(for clothing: Clothing, isPad: Bool, avatar: Image = Image(systemName: "person.crop.circle")) {
        self.avatar = avatar
        self.clothing = clothing
        self.isPad = isPad
    }

    // MARK: Body

    var body: some View {
        ZStack {
            if showDetailsInHStack {
                detailsInHStack
            } else if showDetailsInScrollView {
                detailsInScrollView
            } else {
                detailsInVStack
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color(isSplitView ? UIColor.systemGroupedBackground : UIColor.systemBackground))
    }
}

// MARK: Details

private extension DetailView {

    var detailsInScrollView: some View {
        ScrollView {
            VStack(spacing: 0) {
                PictureView(for: clothing, height: 420, isPad: isPad, isDetailView: true)
                pictureDescription
                clothingDetails
                ratingBanner
                review
            }
        }
        .padding(.horizontal, isPad ? 32 : 16)
        .scrollIndicators(.hidden)
    }

    var detailsInVStack: some View {
        VStack(spacing: 0) {
            PictureView(for: clothing, isPad: isPad, isDetailView: true)
            pictureDescription
            /// Use ScrollView to be sure to read all description
            ScrollView {
                clothingDetails
            }
            .frame(maxHeight: 200)
            .fixedSize(horizontal: false, vertical: true)

            ratingBanner
            review
        }
        .padding(.horizontal, isPad ? 32 : 16)
    }

    var detailsInHStack: some View {
        HStack(spacing: 24) {
            PictureView(for: clothing, width: 234, isPad: isPad, isDetailView: true)
            ScrollView {
                pictureDescription
                clothingDetails
                ratingBanner
                review
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: Details

private extension DetailView {

    var pictureDescription: some View {
        PictureDescriptionView(for: clothing, isDetailView: true, isPad)
            .accessibilityHidden(true)
            .padding(.top, 24)
            .padding(.bottom, 12)
    }

    var clothingDetails: some View {
        Text(clothing.picture.description)
            .font(.adaptiveFootnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
    }
}

// MARK: Rating

private extension DetailView {

    var ratingBanner: some View {
        let starSize: CGFloat = isPad ? 43 : 39

        return HStack(spacing: isPad ? 6 : 2) {
            if dynamicTypeSize.isHigh {
                Spacer()
            } else {
                avatar
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: starSize, height: starSize)
                    .padding(.trailing, 6)
                    .accessibilityHidden(true)
            }
            ForEach(1..<6, id: \.self) { value in
                let isOn = value <= ratingValue
                ZStack {
                    Image(systemName: isOn ? "star.fill" : "star")
                        .font(.title2)
                        .opacity(isOn ? 1 : 0.5)
                        .accessibilityRemoveTraits(.isImage)
                }
                .frame(minWidth: starSize, minHeight: starSize)
                .onTapGesture {
                    updateRating(with: value)
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel(label(for: value))
            }
            Spacer()
        }
        .padding(.top, 24)
        .padding(.bottom, isPad ? 24 : 16)
    }

    func updateRating(with value: Int) {
        if ratingValue != value {
            ratingValue = value
        } else {
            /// Clic on the same rating value, delete the rating if it's the first star
            ratingValue = value == 1 ? 0 : value
        }
    }

    func label(for newRatingValue: Int) -> String {
        if newRatingValue == ratingValue {
            return "Vous avez mis une note de \(newRatingValue) sur 5"
        }
        return "Mettre une note de \(newRatingValue) sur 5"
    }
}

// MARK: Review

private extension DetailView {

    var review: some View {
        TextField(
            "Partagez ici vos impressions sur cette pièce",
            text: .constant(""),
            prompt:
                Text("Partagez ici vos impressions sur cette pièce")
                .font(.adaptiveFootnote), axis: .vertical
        )
        .lineLimit(2, reservesSpace: true)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .opacity(0.2)
        }
    }
}

// MARK: - Preview

struct DetailView_Previews: PreviewProvider {

    static let device: MyPreviewDevice = .iPhoneMini
    static let clothing = ClothesPreview().getClothing(.withSmallDescription)

    static var previews: some View {
        DetailView(for: clothing, isPad: device.isPad, avatar: Image(.avatar))
            .previewDevice(device.preview)
    }
}
