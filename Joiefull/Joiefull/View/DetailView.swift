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

    @State private var ratingValue: Int = 0
    @State private var review: String = ""

    private var isNavigationStack: Bool {
        horizontalSC == .compact
    }

    // MARK: Init

    init(for clothing: Clothing, isPad: Bool, avatar: Image = Image(systemName: "person.crop.circle")) {
        self.avatar = avatar
        self.clothing = clothing
        self.isPad = isPad
    }

    // MARK: Body

    var body: some View {
        ZStack {
            /// If view is presented like a navigation stack (horizontalSizeClass == compact)
            /// and is an iPhone in landscape (verticalSizeClass == compact), show details to the right of the picture.
            if isNavigationStack && verticalSC == .compact {
                horizontalDetails
            } else {
                verticalDetails
            }
        }
        .navigationBarBackButtonHidden(!isNavigationStack)
        .background(
            Color(horizontalSC == .regular ? UIColor.systemGroupedBackground : UIColor.systemBackground)
        )
    }
}

// MARK: Details

private extension DetailView {

    var verticalDetails: some View {
        ScrollView {
            VStack(spacing: 0) {
                PictureView(for: clothing, height: 430, isPad: isPad, isDetailView: true)
                pictureDescription
                clothingDetails
                ratingBanner
                textEditorForReview
            }
        }
        .padding(.horizontal, isPad ? 32 : 16)
        .scrollIndicators(.hidden)
    }

    var horizontalDetails: some View {
        HStack(spacing: 24) {
            PictureView(for: clothing, width: 234, isPad: isPad, isDetailView: true)
                .padding(.top, 24)
            ScrollView {
                pictureDescription
                clothingDetails
                ratingBanner
                textEditorForReview
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

    var textEditorForReview: some View {
        ZStack(alignment: .topLeading) {
            if review.isEmpty {
                Text("Partagez ici vos impressions sur cette pièce")
                    .font(.adaptiveFootnote)
                    .opacity(0.5)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 18)
            }
            TextEditor(text: $review)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
                .scrollContentBackground(.hidden)
                .background(.clear)
        }
        .frame(height: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .opacity(0.2)
        )
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

#Preview("Details in Split View", traits: .modifier(SplitView())) {
    let device: MyPreviewDevice = .iPhoneMax
    let clothing = ClothesPreview().getClothing(.withSmallDescription)
    DetailView(for: clothing, isPad: device.isPad, avatar: Image(.avatar))
}

private struct SplitView: PreviewModifier {

    @State private var navigateToDetail = false

    func body(content: Content, context: ()) -> some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Text("PREVIEW")
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(isPresented: $navigateToDetail) {
                    content
                }
                .onTapGesture {
                    navigateToDetail.toggle()
                }
        } detail: {
            EmptyView()
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            navigateToDetail = true
        }
    }
}
