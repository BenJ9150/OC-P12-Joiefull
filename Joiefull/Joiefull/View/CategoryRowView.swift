//
//  CategoryRowView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI
import SwiftData

struct CategoryRowView: View {

    @Environment(\.modelContext) private var modelContext

    let category: String
    let items: [Clothing]

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: isPad ? 16 : 12) {
            Text(NSLocalizedString(category, comment: "").capitalized)
                .font(.title2.weight(.semibold))
                .accessibilityAddTraits(.isHeader)

            itemsList
        }
    }
}

// MARK: Items

private extension CategoryRowView {

    var itemsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: isPad ? 16 : 8) {
                ForEach(items) { clothing in
                    NavigationLink {
                        DetailView(viewModel: DetailViewModel(
                            modelContext: modelContext,
                            clothing: clothing)
                        )
                    } label: {
                        CategoryItemView(for: clothing)
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
        + "aimé par \(clothing.likes) personnes, "
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
