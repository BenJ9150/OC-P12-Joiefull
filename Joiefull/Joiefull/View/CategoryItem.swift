//
//  CategoryItem.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryItem: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    let clothing: Clothing

    private var maxWidth: CGFloat {
        sizeClass == .regular ? 222 : 198
    }

    var body: some View {
        VStack(spacing: sizeClass == .regular ? 12 : 8) {
            picture
            description
        }
        .frame(width: maxWidth)
    }
}

// MARK: Picture

private extension CategoryItem {

    var picture: some View {
        ZStack {
            AsyncImage(url: URL(string: clothing.picture.url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: maxWidth, height: sizeClass == .regular ? 254 : 198)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: maxWidth, height: sizeClass == .regular ? 254 : 198)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                default:
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                            .frame(width: maxWidth, height: sizeClass == .regular ? 254 : 198)
                        Image(systemName: "photo")
                    }
                }
            }
        }
    }
}

// MARK: Description

private extension CategoryItem {

    var description: some View {
        VStack(spacing: sizeClass == .regular ? 4 : 2) {
            HStack(spacing: 5) {
                Text(clothing.name)
                    .font(.system(size: sizeClass == .regular ? 18 : 14, weight: .semibold))
                    .lineLimit(1)
                Spacer()
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: sizeClass == .regular ? 16 : 12)
                    .foregroundStyle(.orange)
                Text("4.3")
                    .font(.system(size: sizeClass == .regular ? 18 : 14, weight: .regular))
            }
            HStack(spacing: 5) {
                Text(clothing.priceToString)
                    .font(.system(size: sizeClass == .regular ? 18 : 14, weight: .regular))
                Spacer()
                Text(clothing.originalPriceString)
                    .font(.system(size: sizeClass == .regular ? 18 : 14, weight: .regular))
                    .strikethrough()
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Preview

#Preview {

    let urlPar1 = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
    let urlPar2 = "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg"

    let clothing: Clothing = Clothing(
        id: 0,
        picture: Picture(
            url: urlPar1 + urlPar2,
            description: "Sac à main orange posé sur une poignée de porte"
        ),
        name: "Sac à main orange",
        category: "ACCESSORIES",
        likes: 56,
        price: 69.99,
        originalPrice: 69.99
    )

    CategoryItem(clothing: clothing)
}
