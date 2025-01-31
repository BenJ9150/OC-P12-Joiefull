//
//  CategoryItemView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryItemView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.verticalSizeClass) var verticalSC

    private var isPhoneInLandscape: Bool {
        return verticalSC == .compact
    }

    private let clothing: Clothing
    private let isPad: Bool
    private let originalPictureWidth: CGFloat
    private let originalPictureHeight: CGFloat
    private let showOriginalPrice: Bool

    // MARK: Init

    init(for clothing: Clothing, _ isPad: Bool) {
        self.clothing = clothing
        self.isPad = isPad

        /// Set original picture size depending on device size
        self.originalPictureWidth = isPad ? 222 : 198
        self.originalPictureHeight = isPad ? 254 : 198

        /// Do not show original price if equal to price
        self.showOriginalPrice = clothing.originalPrice != clothing.price
    }

    // MARK: Picture dimensions

    /// Increase picture width when dynamic type size increases
    /// to have more spaces for clothing description
    private var pictureWidth: CGFloat {
        let extraWidth: CGFloat = switch dynamicTypeSize {
        case .xSmall, .small, .medium: 0
        case .large: 12
        case .xLarge: 36
        case .xxLarge: 62
        case .xxxLarge: 80
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5: 88
        @unknown default: 0
        }
        return originalPictureWidth + extraWidth
    }

    /// Increase picture height when picture width increases to keep original aspect ratio
    private var pictureHeight: CGFloat {
        return pictureWidth * originalPictureHeight / originalPictureWidth
    }

    // MARK: Body

    var body: some View {
        if isPhoneInLandscape {
            iphoneInlandscapeItem
        } else {
            defaultIem
        }
    }
}

// MARK: default item

private extension CategoryItemView {

    /// Default item with different description UI depending on dynamic type size
    var defaultIem: some View {
        VStack(spacing: isPad ? 12 : 8) {
            asyncPicture
                .frame(height: pictureHeight)
            Group {
                switch dynamicTypeSize {
                case .accessibility1, .accessibility2, .accessibility3:
                    descriptionAX1
                case .accessibility4, .accessibility5:
                    descriptionAX4
                default:
                    defaultDescription
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(width: pictureWidth)
    }
}

// MARK: iPhone in landscape item

private extension CategoryItemView {

    /// From accesibility2 dynamic type size, show the description on the right of the picture
    /// Below accesibility2, using default UI (description below the picture)
    var iphoneInlandscapeItem: some View {
        ZStack {
            switch dynamicTypeSize {
            case .accessibility2, .accessibility3:
                /// Keep ogirinal picture size to save place for category name
                horizontalItem(width: originalPictureWidth, height: originalPictureHeight)
            case .accessibility4, .accessibility5:
                /// Picture with increased size to be consistent with the large size of the description
                horizontalItem(width: pictureWidth, height: pictureHeight)
            default:
                /// Default UI with description below the picture
                VStack(spacing: 8) {
                    asyncPicture
                        .frame(height: originalPictureHeight)
                    defaultDescription
                        .padding(.horizontal, 8)
                }
                .frame(width: pictureWidth)
            }
        }
    }

    func horizontalItem(width: CGFloat, height: CGFloat) -> some View {
        HStack(spacing: 24) {
            asyncPicture
                .frame(width: width)
                .frame(height: height)
            descriptionAX4
                .frame(width: pictureWidth)
        }
    }
}

// MARK: Async picture

private extension CategoryItemView {

    var asyncPicture: some View {
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
        .frame(maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
        )
    }
}

// MARK: Descriptions

private extension CategoryItemView {

    /// If original price equal to price, show stars on the second line
    /// to have more space for clothing name
    var defaultDescription: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                clothingName
                if showOriginalPrice { stars }
            }
            HStack {
                price
                Spacer()
                if showOriginalPrice {
                    originalPrice
                } else {
                    stars
                }
            }
        }
    }

    var descriptionAX1: some View {
        VStack(spacing: 4) {
            clothingName
            HStack {
                if showOriginalPrice {
                    VStack(alignment: .leading, spacing: 4) {
                        price
                        originalPrice
                    }
                } else {
                    price
                }
                Spacer()
                stars
            }
        }
    }

    var descriptionAX4: some View {
        VStack(alignment: .leading, spacing: 4) {
            clothingName
            price
            if showOriginalPrice {
                originalPrice
            }
            stars
        }
    }
}

// MARK: Description details

private extension CategoryItemView {

    var clothingName: some View {
        let lineLimit: Int = switch dynamicTypeSize {
        case .accessibility1:
            showOriginalPrice ? 1 : 2
        case .accessibility2, .accessibility3, .accessibility4, .accessibility5:
            showOriginalPrice ? 2 : 3
        default: 1
        }
        return Text(clothing.name)
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

struct CategoryItemView_Previews: PreviewProvider {

    static var previews: some View {
        let clothing = loadClothing()

        CategoryItemPreviewWrapper(clothing: clothing)
            .previewDevice("iPhone 13 mini")
//            .previewDevice("iPhone 16 Pro Max")
//            .previewDevice("iPad mini (6th generation)")
//            .previewDevice("iPad Pro 13-inch (M4)")
    }

    private static func loadClothing() -> Clothing {
//        let urlPar1 = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
//        let urlPar2 = "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg"
//        let url = urlPar1 + urlPar2
        let url = "test"

//        let name = "New: sac à main orange (posé sur une poignée de porte)"
        let name = "Sac à main orange"

        let jsonString = """
            {
                "id": 0,
                "picture": {
                  "url": "\(url)",
                  "description": "Sac à main orange posé sur une poignée de porte"
                },
                "name": "\(name)",
                "category": "ACCESSORIES",
                "likes": 56,
                "price": 2269.99,
                "original_price": 3269.99
            }
            """

        let clothing: Clothing
        do {
            clothing = try JSONDecoder().decode(Clothing.self, from: jsonString.data(using: .utf8)!)
        } catch {
            fatalError("Failed to decode Clothing: \(error)")
        }
        return clothing
    }

    private struct CategoryItemPreviewWrapper: View {
        @Environment(\.horizontalSizeClass) var horizontalSC
        @Environment(\.verticalSizeClass) var verticalSC
        let clothing: Clothing

        var body: some View {
            CategoryItemView(for: clothing, horizontalSC == .regular && verticalSC == .regular)
        }
    }
}
