//
//  DetailView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct DetailView: View {

    // MARK: Properties

    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @ObservedObject private var viewModel: DetailViewModel
    @FocusState private var reviewIsFocused: Bool
    private let avatar: Image

    private var isPhoneInLandscape: Bool {
        if isPad { return false }
        return verticalSizeClass == .compact
    }

    // MARK: Init

    init(with viewModel: DetailViewModel, avatar: Image = Image(systemName: "person.crop.circle")) {
        self.avatar = avatar
        self.viewModel = viewModel
    }

    // MARK: Body

    var body: some View {
        ZStack {
            /// If it is an iPhone in landscape, show details to the right of the picture.
            if isPhoneInLandscape {
                horizontalDetails
            } else {
                verticalDetails
            }
        }
        .onTapGesture { hideKeyboard() }
        .background(
            Color(isPad ? UIColor.systemGroupedBackground : UIColor.systemBackground)
        )
        /// Alert to confirm sending review
        .reviewAlert(show: $viewModel.showReviewAlert, addCommentBtn: viewModel.review.isEmpty, onSubmit: {
            Task { await viewModel.postReview() }
        }, onAddComment: {
            reviewIsFocused = true
        })
        /// Alert if error when sending review
        .alert(viewModel.postReviewError, isPresented: $viewModel.showReviewError, actions: {})
    }
}

// MARK: Details

private extension DetailView {

    var verticalDetails: some View {
        ScrollView {
            VStack(spacing: 0) {
                picture
                clothingDetails
                ratingAndReviewSection
            }
        }
        .padding(.horizontal, isPad ? 24 : 16)
        .scrollIndicators(.hidden)
    }

    var horizontalDetails: some View {
        HStack(spacing: 24) {
            picture
            ScrollView {
                clothingDetails
                ratingAndReviewSection
            }
            .scrollIndicators(.hidden)
        }
    }

    var picture: some View {
        PictureView(
            for: viewModel.clothing,
            width: isPhoneInLandscape ? .detailPictureWidth : .infinity,
            height: isPhoneInLandscape ? .infinity : .detailPictureHeight,
            isDetailView: true
        )
    }
}

// MARK: Clothing details

private extension DetailView {

    var clothingDetails: some View {
        VStack(spacing: 16) {
            PictureDescriptionView(for: viewModel.clothing, isDetailView: true)

            Text(viewModel.clothing.picture.description)
                .font(.adaptiveFootnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
        .padding(.top, 24)
        .accessibilitySortPriority(2)
    }
}

// MARK: Rating and Review section

private extension DetailView {

    var ratingAndReviewSection: some View {
        VStack(spacing: isPad ? 24 : 16) {
            if viewModel.postingReview {
                ProgressView()
                    .frame(height: 180)
            } else {
                ratingBanner
                /// Show read only review if alreay sended
                if viewModel.postReviewSuccess {
                    Text("Mon commentaire : \n\(viewModel.review.isEmpty ? "..." : viewModel.review)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .font(.adaptiveFootnote)
                        .opacity(0.5)
                } else {
                    /// Show submit review button only if there is a rating
                    if viewModel.rating > 0 {
                        Button("Partager mon avis") {
                            viewModel.showReviewAlert.toggle()
                        }
                        .buttonStyle(JoifullButton())
                    }
                    textEditorForReview
                }
            }
        }
        .padding(.top, 26)
    }
}

// MARK: Rating

private extension DetailView {

    var ratingBanner: some View {
        HStack(spacing: isPad ? 6 : 1) {
            if dynamicTypeSize.isHigh {
                Spacer()
            } else {
                avatar
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: .minButtonSize, height: .minButtonSize)
                    .padding(.trailing, 6)
                    .accessibilityHidden(true)
            }
            ForEach(1..<6, id: \.self) { value in
                let isOn = value <= viewModel.rating
                ZStack {
                    Image(systemName: isOn ? "star.fill" : "star")
                        .font(.title2)
                        .opacity(isOn ? 1 : 0.5)
                        .foregroundStyle(viewModel.postReviewSuccess ? .orange : .primary)
                        .accessibilityRemoveTraits(.isImage)
                }
                .frame(minWidth: .minButtonSize, minHeight: .minButtonSize)
                .onTapGesture {
                    /// Rating is read only if review has already sended
                    if !viewModel.postReviewSuccess {
                        withAnimation(.bouncy(duration: 0.3)) { updateRating(with: value) }
                    }
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel(label(for: value))
            }
            Spacer()
        }
        .accessibilityElement(children: viewModel.postReviewSuccess ? .ignore : .contain)
        .accessibilityLabel(labelForPostedRate)
    }

    func updateRating(with value: Int) {
        /// If clic on the same rating value, delete the rating
        viewModel.rating = viewModel.rating != value ? value : 0
    }

    var labelForPostedRate: String {
        viewModel.postReviewSuccess ? "Vous avez mis une note de \(viewModel.rating) sur 5," : ""
    }

    func label(for newRatingValue: Int) -> String {
        if newRatingValue == viewModel.rating {
            return "Vous avez noté \(newRatingValue) sur 5,"
            + "ajoutez un commentaire ou cliquez directement sur 'partager mon avis'"
        }
        return "Mettre une note de \(newRatingValue) sur 5"
    }
}

// MARK: Review

private extension DetailView {

    var textEditorForReview: some View {
        VStack {
            if !viewModel.review.isEmpty && viewModel.rating == 0 && !reviewIsFocused {
                Text("Ajoutez une note pour partager votre commentaire 🙂")
                    .multilineTextAlignment(.center)
                    .font(.adaptiveBody)
                    .padding(.all, 9)
            }

            ZStack(alignment: .topLeading) {
                if viewModel.review.isEmpty {
                    Text("Partagez ici vos impressions sur cette pièce")
                        .font(.adaptiveFootnote)
                        .opacity(0.5)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 18)
                        .accessibilityHidden(true)
                }
                TextEditor(text: $viewModel.review)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .focused($reviewIsFocused)
                    .toolbar {
                        ToolbarItem(placement: .keyboard, content: {
                            Button("Fermer", action: { hideKeyboard() })
                        })
                    }
                    .accessibilityLabel("Partagez ici vos impressions sur cette pièce")
            }
            .frame(height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .opacity(0.2)
            )
        }
    }
}

// MARK: - Preview

#Preview(
    "With navigation",
    traits: .modifier(InspectorPresentation()), .modifier(FavoritesViewModelInEnvironment())
) {
    @Previewable @Environment(\.modelContext) var context
    DetailView(
        with: DetailViewModel(
            for: ClothesPreview().getClothing(.withSmallDescription),
            reviewRepo: SwiftDataService(modelContext: context),
            using: HTTPClientPreview()
        ),
        avatar: Image(.avatar)
    )
}

#Preview(traits: .modifier(FavoritesViewModelInEnvironment())) {
    @Previewable @Environment(\.modelContext) var context
    DetailView(
        with: DetailViewModel(
            for: ClothesPreview().getClothing(.withSmallDescription),
            reviewRepo: SwiftDataService(modelContext: context),
            using: HTTPClientPreview()
        ),
        avatar: Image(.avatar)
    )
}
