//
//  CategoryItemView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryItemView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    let clothing: Clothing

    // MARK: Picture dimensions

    private var pictureWidth: CGFloat {
        let width: CGFloat = sizeClass == .regular ? 222 : 198

        switch dynamicTypeSize {
        case .xSmall, .small, .medium:
            return width
        case .large:
            return width + 12
        case .xLarge:
            return width + 36
        case .xxLarge:
            return width + 62
        default:
            // xxxLarge and accessibilities
            return width + 88
        }
    }

    private var pictureHeight: CGFloat {
        let originalWidth: CGFloat = sizeClass == .regular ? 222 : 198
        let originalHeight: CGFloat = sizeClass == .regular ? 254 : 198
        return pictureWidth * originalHeight / originalWidth
    }

    // MARK: Body

    var body: some View {
        VStack(spacing: sizeClass == .regular ? 12 : 8) {
            picture
            // Description
            Group {
                switch dynamicTypeSize {
                case .accessibility1, .accessibility2, .accessibility3:
                    descriptionAX1
                case .accessibility4, .accessibility5:
                    descriptionAX4
                default:
                    descriptionMedium
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(width: pictureWidth)
    }
}

// MARK: Picture

private extension CategoryItemView {

    var picture: some View {
        AsyncImage(url: URL(string: clothing.picture.url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                Image(systemName: "photo")
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: pictureHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
        )
    }
}

// MARK: Descriptions

private extension CategoryItemView {

    var descriptionMedium: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                clothingName()
                stars
            }
            HStack {
                price
                Spacer()
                originalPrice
            }
        }
    }

    var descriptionAX1: some View {
        VStack(spacing: 4) {
            clothingName(withLineLimit: 2)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    price
                    originalPrice
                }
                Spacer()
                stars
            }
        }
    }

    var descriptionAX4: some View {
        VStack(alignment: .leading, spacing: 4) {
            clothingName(withLineLimit: 2)
            price
            originalPrice
            stars
        }
    }
}

// MARK: Description details

private extension CategoryItemView {

    func clothingName(withLineLimit lineLimit: Int = 1) -> some View {
        Text(clothing.name)
            .font(.footnote.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(lineLimit)
    }

    var stars: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption2)
                .foregroundStyle(.orange)
                .padding(.bottom, 1)
            /// Display rating with US style to have dot as decimal separator
            Text(clothing.rating.toString(locale: Locale(identifier: "en_US")))
                .font(.footnote.weight(.regular))
        }
    }

    var price: some View {
        Text(clothing.price.toEuros())
            .font(.footnote.weight(.regular))
    }

    var originalPrice: some View {
        Text(clothing.originalPrice.toEuros())
            .font(.footnote.weight(.regular))
            .strikethrough()
    }
}

// MARK: - Preview

#Preview {
//    let urlPar1 = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
//    let urlPar2 = "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg"
//
//    let jsonString = """
//    {
//        "id": 2,
//        "picture": {
//          "url": "\(urlPar1 + urlPar2)",
//          "description": "Modèle femme qui pose dans la rue en bottes de pluie noires"
//        },
//        "name": "Bottes noires pour l'automne",
//        "category": "SHOES",
//        "likes": 4,
//        "price": 99.99,
//        "original_price": 119.99
//    }
//    """

    let jsonString = """
    {
        "id": 0,
        "picture": {
          "url": "test",
          "description": "Sac à main orange posé sur une poignée de porte"
        },
        "name": "New: sac à main orange",
        "category": "ACCESSORIES",
        "likes": 56,
        "price": 2269.99,
        "original_price": 2269.99
    }
    """

    let clothing: Clothing
    do {
        clothing = try JSONDecoder().decode(Clothing.self, from: jsonString.data(using: .utf8)!)
    } catch {
        fatalError("Failed to decode Clothing: \(error)")
    }

    return CategoryItemView(clothing: clothing)
}
