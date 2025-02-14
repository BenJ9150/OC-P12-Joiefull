//
//  DetailView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct DetailView: View {

    private let avatar: Image
    private let clothing: Clothing
    private let isPad: Bool

    @State private var ratingValue: Int = 0

    init(for clothing: Clothing, isPad: Bool, avatar: Image = Image(systemName: "person.crop.circle")) {
        self.avatar = avatar
        self.clothing = clothing
        self.isPad = isPad
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                PictureView(clothing: clothing, width: .infinity, height: .infinity)
                    .padding(.bottom, 24)
                PictureDescriptionView(for: clothing, largeSize: true, isPad)
                    .padding(.bottom, 12)
                details
                    .padding(.bottom, 24)
            }
            .accessibilityHidden(true)

            rating
                .padding(.bottom, isPad ? 24 : 16)
            review
        }
        .padding(.horizontal, isPad ? 32 : 16)
    }
}

// MARK: Details

private extension DetailView {

    var details: some View {
        Text(clothing.picture.description)
            .font(isPad ? .body : .footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
    }
}

// MARK: Rating

private extension DetailView {

    var rating: some View {
        HStack(spacing: 16) {
            avatar
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: isPad ? 43 : 39, height: isPad ? 43 : 39)
                .accessibilityHidden(true)

            ForEach(1..<6, id: \.self) { value in
                let isOn = value <= ratingValue
                Image(systemName: isOn ? "star.fill" : "star")
                    .font(isPad ? .title2 : .title3)
                    .opacity(isOn ? 1 : 0.5)
                    .onTapGesture {
                        updateRating(with: value)
                    }
                    .accessibilityAddTraits(.isButton)
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
}

// MARK: Review

private extension DetailView {

    var review: some View {
        TextField(
            "Partagez ici vos impressions sur cette pièce",
            text: .constant(""),
            prompt:
                Text("Partagez ici vos impressions sur cette pièce")
                .font(isPad ? .body : .footnote), axis: .vertical
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

#Preview {
    let clothing = ClothesPreview().getClothing(6)
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    DetailView(for: clothing, isPad: isPad, avatar: Image(.avatar))
}
