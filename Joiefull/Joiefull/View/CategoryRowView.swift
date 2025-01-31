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
    let jsonString = """
    [
      {
        "id": 3,
        "picture": {
          "url": "test",
          "description": "Homme en costume et veste de blazer qui regarde la caméra"
        },
        "name": "Blazer marron",
        "category": "TOPS",
        "likes": 15,
        "price": 79.99,
        "original_price": 79.99
      },
      {
        "id": 4,
        "picture": {
          "url": "test",
          "description": "Femme dehors qui pose avec un pull en maille vert"
        },
        "name": "Pull vert femme",
        "category": "TOPS",
        "likes": 15,
        "price": 29.99,
        "original_price": 39.99
      },
      {
        "id": 7,
        "picture": {
          "url": "test",
          "description": "Homme jeune stylé en jean et bomber qui pose dans la rue"
        },
        "name": "Bomber automnal pour homme",
        "category": "TOPS",
        "likes": 30,
        "price": 89.99,
        "original_price": 109.99
      },
      {
        "id": 8,
        "picture": {
          "url": "test",
          "description": "Homme en sweat jaune qui regarde à droite"
        },
        "name": "Sweat jaune",
        "category": "TOPS",
        "likes": 6,
        "price": 39.99,
        "original_price": 39.99
      }
    ]
    """

    let clothes: [Clothing]
    do {
        clothes = try JSONDecoder().decode([Clothing].self, from: jsonString.data(using: .utf8)!)
    } catch {
        fatalError("Failed to decode Clothes: \(error)")
    }

    return CategoryRowView(category: clothes[0].category, items: clothes)
}
