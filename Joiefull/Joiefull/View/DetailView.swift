//
//  DetailView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct DetailView: View {

    let clothing: Clothing
    let isPad: Bool

    var body: some View {
        VStack(spacing: 0) {
            PictureView(clothing: clothing, width: .infinity, height: .infinity)
                .padding(.bottom, 24)

            PictureDescriptionView(for: clothing, largeSize: true, isPad)
                .padding(.bottom, 12)

            details
                .padding(.bottom, 24)

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
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: isPad ? 43 : 39)
                .mask(Circle())

            ForEach(0..<5, id: \.self) { _ in
                Image(systemName: "star")
                    .font(isPad ? .title2 : .title3)
                    .opacity(0.5)
            }
            Spacer()
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
    DetailView(clothing: clothing, isPad: isPad)
}
