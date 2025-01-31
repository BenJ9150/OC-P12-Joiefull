//
//  CategoryRowView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryRowView: View {
    @Environment(\.horizontalSizeClass) var horizontalSC
    @Environment(\.verticalSizeClass) var verticalSC

    let category: String
    let items: [Clothing]

    private var isPad: Bool {
        /// Use Size Class to define if device is an iPad
        /// to keep iPhone UI when app is displayed on iPad split view
        /// (horizontalSizeClass == .compact for iPad in split view)
        return horizontalSC == .regular && verticalSC == .regular
    }

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
            HStack(alignment: .top, spacing: isPad ? 15 : 8) {
                ForEach(items) { clothing in
                    NavigationLink {
                        DetailView(clothing: clothing)
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
        return "\(clothing.name), "
        + "noté \(clothing.rating.toString()) sur 5. "
        + "\(clothing.price.toEuros())"
        + "\(clothing.price == clothing.originalPrice ? "." : ", au lieu de \(clothing.originalPrice.toEuros()) !")"
    }
}

// MARK: - Preview

#Preview {
    let clothes = ClothesPreview().getClothes()
    CategoryRowView(category: clothes[0].category, items: clothes)
}
