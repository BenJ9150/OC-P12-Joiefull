//
//  CategoryRowView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryRowView: View {

    let category: String
    let items: [Clothing]
    let isPad: Bool

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: isPad ? 16 : 12) {
            Text(NSLocalizedString(category, comment: "").capitalized)
                .font(.title3.weight(.semibold))
                .accessibilityAddTraits(.isHeader)

            itemsList
        }
        .padding(.top, 18)
    }
}

// MARK: Items

private extension CategoryRowView {

    var itemsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: isPad ? 16 : 8) {
                ForEach(items) { clothing in
                    NavigationLink {
                        DetailView(for: clothing, isPad: isPad)
                    } label: {
                        CategoryItemView(for: clothing, isPad)
                    }
                    .foregroundStyle(.primary)
                    /// VoiceOver accessibility
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(label(for: clothing))
                    .accessibilityAddTraits(.isButton)
                }
            }
        }
    }

    func label(for clothing: Clothing) -> String {
        return "\(clothing.picture.description), "
        + "aimé par \(clothing.likes) personnes, "
        + "noté \(clothing.rating.toString()) sur 5. "
        + "\(clothing.price.toEuros())"
        + "\(clothing.price == clothing.originalPrice ? "." : ", au lieu de \(clothing.originalPrice.toEuros()) !")"
    }
}

// MARK: - Preview

#Preview {
    let clothes = ClothesPreview().getClothes()
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    CategoryRowView(category: clothes[0].category, items: clothes, isPad: isPad)
}
