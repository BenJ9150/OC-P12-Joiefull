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
    @Environment(\.verticalSizeClass) var verticalSC

    // MARK: Properties

    private let avatar: Image
    private let clothing: Clothing
    private let isPad: Bool

    private var isPhoneInLandscape: Bool {
        return verticalSC == .compact
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
        if isPhoneInLandscape {
            HStack(spacing: 24) {
                PictureView(for: clothing, width: 234, isPad: isPad)
                ScrollView {
                    details
                }
                .scrollIndicators(.hidden)
            }

        } else {
            ZStack {
                if dynamicTypeSize.isAccessibilitySize {
                    ScrollView {
                        PictureView(for: clothing, height: 256, isPad: isPad)
                        details
                    }
                    .scrollIndicators(.hidden)
                } else {
                    VStack(spacing: 24) {
                        PictureView(for: clothing, isPad: isPad)
                        details
                    }
                }
            }
            .padding(.horizontal, isPad ? 32 : 16)
        }
    }
}

// MARK: Details

private extension DetailView {

    var details: some View {
        VStack(spacing: 0) {
            PictureDescriptionView(for: clothing, isDetailView: true, isPad)
                .accessibilityHidden(true)
                .padding(.bottom, 12)

            if dynamicTypeSize.isAccessibilitySize || isPhoneInLandscape {
                /// Already a ScrollView in parent view
                pictureDescription
                    .padding(.bottom, 24)
            } else {
                /// Use ScrollView to be sure to read all description
                ScrollView {
                    pictureDescription
                }
                .frame(maxHeight: 200)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 24)
            }
            ratingBanner
                .padding(.bottom, isPad ? 24 : 16)
            review
        }
    }
}

// MARK: Details

private extension DetailView {

    var pictureDescription: some View {
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

struct DetailViewWithSlipView_Previews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper()
            .previewDevice(.iPhoneMax)
    }

    struct PreviewWrapper: View {

        private let clothing = ClothesPreview().getClothing(12)
        private let isPad = UIDevice.current.userInterfaceIdiom == .pad
        @State private var navigateToDetail = false

        var body: some View {
            GeometryReader { geometry in
                NavigationSplitView(columnVisibility: .constant(.all)) {
                    Text("PREVIEW")
                        .navigationSplitViewColumnWidth(geometry.size.width * 766/1280)
                        .toolbar(.hidden, for: .navigationBar)
                        .navigationDestination(isPresented: $navigateToDetail) {
                            DetailView(for: clothing, isPad: isPad, avatar: Image(.avatar))
                        }
                        .onTapGesture {
                            navigateToDetail.toggle()
                        }
                } detail: {
                    EmptyView()
                }
                .navigationSplitViewStyle(.balanced)
            }
            .onAppear {
                navigateToDetail = true
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {

    static let clothing = ClothesPreview().getClothing(12)
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad

    static var previews: some View {
        DetailView(for: clothing, isPad: isPad, avatar: Image(.avatar))
            .previewDevice(.iPhoneMini)
    }
}
